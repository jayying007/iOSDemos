//
//  AudioUnitPlayer.m
//  Audio
//
//  Created by janezhuang on 2022/10/5.
//

#import "AudioUnitPlayer.h"
#import "AudioDataProvider.h"

#define kInputBus 1
#define kOutputBus 0

@interface AudioUnitPlayer (Private)
- (OSStatus)handleRenderCallback:(AudioUnitRenderActionFlags *)actionFlags
                       timeStamp:(const AudioTimeStamp *)timeStamp
                       busNumber:(UInt32)busNumber
                    numberFrames:(UInt32)numberFrames
                            data:(AudioBufferList *)data;
- (OSStatus)handleConvertData:(AudioBufferList *)data
            numberDataPackets:(UInt32 *)numberDataPackets
            packetDescription:(AudioStreamPacketDescription **)packetDescription;
@end

static OSStatus RenderCallback(void *inRefCon,
                               AudioUnitRenderActionFlags *ioActionFlags,
                               const AudioTimeStamp *inTimeStamp,
                               UInt32 inBusNumber,
                               UInt32 inNumberFrames,
                               AudioBufferList *__nullable ioData) {
    AudioUnitPlayer *player = (__bridge AudioUnitPlayer *)inRefCon;
    return [player handleRenderCallback:ioActionFlags timeStamp:inTimeStamp busNumber:inBusNumber numberFrames:inNumberFrames data:ioData];
}

static OSStatus AudioConverterComplexInputDataCallback(AudioConverterRef inAudioConverter,
                                                       UInt32 *ioNumberDataPackets,
                                                       AudioBufferList *ioData,
                                                       AudioStreamPacketDescription *__nullable *__nullable outDataPacketDescription,
                                                       void *__nullable inUserData) {
    AudioUnitPlayer *player = (__bridge AudioUnitPlayer *)inUserData;
    return [player handleConvertData:ioData numberDataPackets:ioNumberDataPackets packetDescription:outDataPacketDescription];
}

@interface AudioUnitPlayer () {
    AudioUnit ioUnit;

    UInt64 currentFrames;
    UInt64 currentConvertPacket;
    AudioStreamBasicDescription dataFormat;

    AudioConverterRef audioConverter;
}
@property (nonatomic) AudioDataProvider *dataProvider;
@end

@implementation AudioUnitPlayer

@synthesize rate;

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _dataProvider = [[AudioDataProvider alloc] initWithURL:url];
        [self initAudioUnit];
        AudioInfo(@"%s init success", __func__);
    }
    return self;
}

- (void)dealloc {
    AudioUnitUninitialize(ioUnit);
    AudioComponentInstanceDispose(ioUnit);
    AudioConverterDispose(audioConverter);
}

- (BOOL)play {
    OSStatus status = AudioOutputUnitStart(ioUnit);
    return status == noErr;
}

- (void)pause {
    AudioOutputUnitStop(ioUnit);
}

- (void)resume {
    AudioOutputUnitStart(ioUnit);
}

- (void)seekToTime:(UInt32)time {
    currentFrames = time * dataFormat.mSampleRate / 1000;
    currentConvertPacket = currentFrames / _dataProvider.dataFormat->mFramesPerPacket;
    AudioConverterReset(audioConverter);
    AudioInfo(@"seek:%llu", currentFrames);
}

- (void)stop {
    AudioOutputUnitStop(ioUnit);
}

- (UInt32)currentTime {
    return currentFrames * 1000 / dataFormat.mSampleRate;
}

- (UInt32)duration {
    return _dataProvider.duration;
}

- (BOOL)isPlaying {
    UInt32 size;
    AudioUnitGetPropertyInfo(ioUnit, kAudioOutputUnitProperty_IsRunning, kAudioUnitScope_Global, kOutputBus, &size, nil);
    UInt32 isRunning = 0;
    AudioUnitGetProperty(ioUnit, kAudioOutputUnitProperty_IsRunning, kAudioUnitScope_Global, kOutputBus, &isRunning, &size);

    return isRunning > 0;
}

- (void)setRate:(CGFloat)rate {
    AudioInfo(@"需要使用AUGraph，配合kAudioUnitSubType_TimePitch");
}
#pragma mark -
- (void)initAudioUnit {
    AudioComponentDescription desc;
    desc.componentType = kAudioUnitType_Output;
    desc.componentSubType = kAudioUnitSubType_RemoteIO;
    desc.componentManufacturer = kAudioUnitManufacturer_Apple;
    desc.componentFlags = 0;
    desc.componentFlagsMask = 0;

    AudioComponent comp = AudioComponentFindNext(NULL, &desc);
    AudioComponentInstanceNew(comp, &ioUnit);

    UInt32 flag = 1;
    AudioUnitSetProperty(ioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output, kOutputBus, &flag, sizeof(flag));

    [self initDataFormat];
    AudioUnitSetProperty(ioUnit,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Input,
                         kOutputBus,
                         &dataFormat,
                         sizeof(AudioStreamBasicDescription));

    AURenderCallbackStruct renderCallback;
    renderCallback.inputProc = RenderCallback;
    renderCallback.inputProcRefCon = (__bridge void *)self;
    AudioUnitSetProperty(ioUnit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, kOutputBus, &renderCallback, sizeof(renderCallback));

    AudioUnitInitialize(ioUnit);

    AudioConverterNew(_dataProvider.dataFormat, &dataFormat, &audioConverter);
}

- (void)initDataFormat {
    dataFormat.mFormatID = kAudioFormatLinearPCM;
    dataFormat.mSampleRate = _dataProvider.dataFormat->mSampleRate;
    dataFormat.mChannelsPerFrame = 1;
    dataFormat.mBitsPerChannel = 16;
    dataFormat.mBytesPerPacket = dataFormat.mBytesPerFrame = dataFormat.mChannelsPerFrame * sizeof(SInt16);
    dataFormat.mFramesPerPacket = 1;
    dataFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    dataFormat.mReserved = 0;
}

- (OSStatus)handleRenderCallback:(AudioUnitRenderActionFlags *)actionFlags
                       timeStamp:(const AudioTimeStamp *)timeStamp
                       busNumber:(UInt32)busNumber
                    numberFrames:(UInt32)numberFrames
                            data:(AudioBufferList *)data {
    UInt32 readNumberFrames = numberFrames;
    //看起来AudioConverter不允许同时转换SampleRate、FormatID
    AudioConverterFillComplexBuffer(audioConverter, AudioConverterComplexInputDataCallback, (__bridge void *)self, &readNumberFrames, data, nil);
    if (readNumberFrames != numberFrames) {
        [self stop];
    } else {
        currentFrames += numberFrames;
    }

    return noErr;
}

- (OSStatus)handleConvertData:(AudioBufferList *)data
            numberDataPackets:(UInt32 *)numberDataPackets
            packetDescription:(AudioStreamPacketDescription **)packetDescription {
    UInt32 numberOfPackets = *numberDataPackets;

    UInt32 bytesCopied = numberOfPackets * _dataProvider.maxPacketSize;
    static void *gSourceBuffer = NULL;
    if (gSourceBuffer != NULL) {
        free(gSourceBuffer);
        gSourceBuffer = NULL;
    }
    gSourceBuffer = (void *)calloc(1, bytesCopied);

    static AudioStreamPacketDescription *packetDescriptions = NULL;
    if (packetDescriptions != NULL) {
        free(packetDescriptions);
        packetDescriptions = NULL;
    }
    packetDescriptions = (AudioStreamPacketDescription *)calloc(numberOfPackets, sizeof(AudioStreamPacketDescription));

    [_dataProvider readPacketsFromCurrent:currentConvertPacket
                               numPackets:numberOfPackets
                       packetDescriptions:packetDescriptions
                                outBuffer:gSourceBuffer
                                 numBytes:bytesCopied];

    *numberDataPackets = numberOfPackets;
    if (packetDescription) {
        *packetDescription = packetDescriptions;
    }
    currentConvertPacket += numberOfPackets;

    data->mNumberBuffers = 1;
    data->mBuffers[0].mData = gSourceBuffer;
    data->mBuffers[0].mNumberChannels = _dataProvider.dataFormat->mChannelsPerFrame;
    data->mBuffers[0].mDataByteSize = bytesCopied;

    return noErr;
}
@end
