//
//  AACAudioEncoder.m
//  Audio
//
//  Created by janezhuang on 2022/10/13.
//

#import "AACAudioEncoder.h"
#import <DevelopKit/FileUtil.h>

#define kFramesPerPacket 1024

@interface AACAudioEncoder (Private)
- (OSStatus)handleConvertData:(AudioBufferList *)data
            numberDataPackets:(UInt32 *)numberDataPackets
            packetDescription:(AudioStreamPacketDescription **)packetDescription;
@end

static OSStatus AudioConverterComplexInputDataCallback(AudioConverterRef inAudioConverter,
                                                       UInt32 *ioNumberDataPackets,
                                                       AudioBufferList *ioData,
                                                       AudioStreamPacketDescription *__nullable *__nullable outDataPacketDescription,
                                                       void *__nullable inUserData) {
    AACAudioEncoder *encoder = (__bridge AACAudioEncoder *)inUserData;
    return [encoder handleConvertData:ioData numberDataPackets:ioNumberDataPackets packetDescription:outDataPacketDescription];
}

@interface AACAudioEncoder ()

@property (nonatomic) NSFileHandle *pcmFileHandle;
@property (nonatomic) const AudioStreamBasicDescription *pcmFormat;
@property (nonatomic) void *pcmBuffer;
@property (nonatomic) UInt32 pcmBufferSize;

@property (nonatomic) NSFileHandle *aacFileHandle;
@property (nonatomic) AudioStreamBasicDescription *aacFormat;
@property (nonatomic) void *aacBuffer;
@property (nonatomic) UInt32 aacBufferSize;

@property (nonatomic) AudioConverterRef audioConverter;
@property (nonatomic) BOOL encodeEnd;

@end

@implementation AACAudioEncoder
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initFormat];
    }
    return self;
}

- (void)encodePCMFileFromPath:(NSString *)fromPath withFormat:(const AudioStreamBasicDescription *)format toPath:(NSString *)toPath {
    [FileUtil createFile:toPath];

    _pcmFormat = format;
    _pcmFileHandle = [NSFileHandle fileHandleForReadingAtPath:fromPath];
    _aacFileHandle = [NSFileHandle fileHandleForWritingAtPath:toPath];

    [self initConverter];
    [self doEncode];
}
#pragma mark -
- (void)initFormat {
    _aacFormat = (AudioStreamBasicDescription *)malloc(sizeof(AudioStreamBasicDescription));
    memset(_aacFormat, 0, sizeof(AudioStreamBasicDescription)); // 置0很重要！！
    _aacFormat->mFormatID = kAudioFormatMPEG4AAC;
    _aacFormat->mFormatFlags = kMPEG4Object_AAC_LC; // 无损编码，0表示没有
    _aacFormat->mSampleRate = 44100;
    _aacFormat->mChannelsPerFrame = 1;
    _aacFormat->mBitsPerChannel = 0; // 压缩格式设置为0
    // 每帧的大小。每一帧的起始点到下一帧的起始点。如果是压缩格式，设置为0 。
    _aacFormat->mBytesPerFrame = 0;
    // 每个packet的帧数。如果是未压缩的音频数据，值是1。动态码率格式，这个值是一个较大的固定数字，比如说AAC的1024。如果是动态大小帧数（比如Ogg格式）设置为0。
    _aacFormat->mFramesPerPacket = kFramesPerPacket;
    // 每一个packet的音频数据大小。如果的动态大小，设置为0。动态大小的格式，需要用AudioStreamPacketDescription 来确定每个packet的大小。
    _aacFormat->mBytesPerPacket = 0;
    _aacFormat->mReserved = 0; // 8字节对齐，填0.
}

- (void)initConverter {
    UInt32 size = 0;
    //选择软件编码
    AudioFormatGetPropertyInfo(kAudioFormatProperty_Encoders, sizeof(_aacFormat->mFormatID), &_aacFormat->mFormatID, &size);
    UInt32 numEncoders = size / sizeof(AudioClassDescription);
    AudioClassDescription audioClassArr[numEncoders];
    AudioFormatGetProperty(kAudioFormatProperty_Encoders, sizeof(_aacFormat->mFormatID), &_aacFormat->mFormatID, &size, audioClassArr);
    AudioClassDescription audioClassDes;
    for (int i = 0; i < numEncoders; i++) {
        if (audioClassArr[i].mSubType == kAudioFormatMPEG4AAC && audioClassArr[i].mManufacturer == kAppleSoftwareAudioCodecManufacturer) {
            memcpy(&audioClassDes, &audioClassArr[i], sizeof(AudioClassDescription));
            break;
        }
    }
    //创建converter
    OSStatus status = AudioConverterNewSpecific(_pcmFormat, _aacFormat, 1, &audioClassDes, &_audioConverter);
    AudioInfo(@"new converter, ret:%d", status);

    //转换后packet最大大小
    UInt32 maxPacketSize = 0;
    size = sizeof(UInt32);
    AudioConverterGetProperty(_audioConverter, kAudioConverterPropertyMaximumOutputPacketSize, &size, &maxPacketSize);
    _aacBuffer = malloc(maxPacketSize);
    _aacBufferSize = maxPacketSize;
}

// 将frames转换为packet, 每1024个frames转为1个packet
- (OSStatus)handleConvertData:(AudioBufferList *)data
            numberDataPackets:(UInt32 *)numberDataPackets
            packetDescription:(AudioStreamPacketDescription **)packetDescription {
    UInt32 bytesLength = kFramesPerPacket * _pcmFormat->mBytesPerFrame;

    if (_pcmBufferSize < bytesLength) {
        free(_pcmBuffer);
        _pcmBuffer = (void *)malloc(bytesLength);
        _pcmBufferSize = bytesLength;
    }

    // 读取pcm数据
    NSData *pcmData = [_pcmFileHandle readDataUpToLength:bytesLength error:nil];
    if (pcmData.length < bytesLength) {
        _encodeEnd = YES;
        *numberDataPackets = 0;
        return -1;
    }
    [pcmData getBytes:_pcmBuffer length:bytesLength];

    *numberDataPackets = kFramesPerPacket;
    data->mNumberBuffers = 1;
    data->mBuffers[0].mData = _pcmBuffer;
    data->mBuffers[0].mNumberChannels = _pcmFormat->mChannelsPerFrame;
    data->mBuffers[0].mDataByteSize = (UInt32)pcmData.length;

    return noErr;
}
// https://blog.csdn.net/jay100500/article/details/52955232
/**
 *  Add ADTS header at the beginning of each and every AAC packet.
 *  This is needed as MediaCodec encoder generates a packet of raw
 *  AAC data.
 *
 *  Note the packetLen must count in the ADTS header itself.
 *  See: http://wiki.multimedia.cx/index.php?title=ADTS
 *  Also: http://wiki.multimedia.cx/index.php?title=MPEG-4_Audio#Channel_Configurations
 **/
- (NSData *)adtsDataForPacketLength:(NSUInteger)packetLength {
    int adtsLength = 7;
    char *packet = (char *)malloc(sizeof(char) * adtsLength);
    // Variables Recycled by addADTStoPacket
    int profile = 2; //AAC LC
    //39=MediaCodecInfo.CodecProfileLevel.AACObjectELD;
    int freqIdx = 4; //44.1KHz
    int chanCfg = 1; //MPEG-4 Audio Channel Configuration. 1 Channel front-center
    NSUInteger fullLength = adtsLength + packetLength;
    // fill in ADTS data
    packet[0] = (char)0xFF; // 11111111     = syncword
    packet[1] = (char)0xF9; // 1111 1 00 1  = syncword MPEG-2 Layer CRC
    packet[2] = (char)(((profile - 1) << 6) + (freqIdx << 2) + (chanCfg >> 2));
    packet[3] = (char)(((chanCfg & 3) << 6) + (fullLength >> 11));
    packet[4] = (char)((fullLength & 0x7FF) >> 3);
    packet[5] = (char)(((fullLength & 7) << 5) + 0x1F);
    packet[6] = (char)0xFC;
    NSData *data = [NSData dataWithBytesNoCopy:packet length:adtsLength freeWhenDone:YES];
    return data;
}

- (void)doEncode {
    while (!_encodeEnd) {
        AudioBufferList bufferList = { 0 };
        bufferList.mNumberBuffers = 1;
        bufferList.mBuffers[0].mDataByteSize = _aacBufferSize;
        bufferList.mBuffers[0].mData = _aacBuffer;
        bufferList.mBuffers[0].mNumberChannels = _pcmFormat->mChannelsPerFrame;

        UInt32 ioOutputDataPackets = 1;
        // encode pcm to aac
        AudioConverterFillComplexBuffer(_audioConverter,
                                        AudioConverterComplexInputDataCallback,
                                        (__bridge void *)self,
                                        &ioOutputDataPackets,
                                        &bufferList,
                                        NULL);
        // add ADTS header
        NSData *rawAAC = [NSData dataWithBytes:bufferList.mBuffers[0].mData length:bufferList.mBuffers[0].mDataByteSize];
        NSData *adtsHeader = [self adtsDataForPacketLength:rawAAC.length];
        NSMutableData *fullData = [NSMutableData dataWithData:adtsHeader];
        [fullData appendData:rawAAC];
        // save aac to file
        [_aacFileHandle writeData:fullData];
    }
    free(_pcmBuffer);
    free(_aacBuffer);
    [_pcmFileHandle closeFile];
    [_aacFileHandle closeFile];
    AudioConverterDispose(_audioConverter);
}
@end
