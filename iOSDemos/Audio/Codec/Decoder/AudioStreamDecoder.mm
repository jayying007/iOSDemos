//
//  AudioStreamDecoder.m
//  Audio
//
//  Created by janezhuang on 2022/10/1.
//

#import "AudioStreamDecoder.h"
#import <DevelopKit/FileUtil.h>
#import <DevelopKit/AudioUtil.h>

@interface AudioStreamData : NSObject
@property (nonatomic) NSData *data;
@property (nonatomic) AudioStreamPacketDescription packetDescription;
@end

@implementation AudioStreamData
@end

@interface AudioStreamDecoder (Private)
- (void)handleAudioFileStreamProperty:(AudioFileStreamPropertyID)propertyID flags:(AudioFileStreamPropertyFlags *)ioFlags;
- (void)handleAudioFileStreamPackets:(const void *)packets
                       numberOfBytes:(UInt32)numberOfBytes
                     numberOfPackets:(UInt32)numberOfPackets
                  packetDescriptions:(AudioStreamPacketDescription *)packetDescriptions;
@end

static void PropertyListenerCallback(void *inClientData,
                                     AudioFileStreamID inAudioFileStream,
                                     AudioFileStreamPropertyID inPropertyID,
                                     AudioFileStreamPropertyFlags *ioFlags) {
    AudioStreamDecoder *decoder = (__bridge AudioStreamDecoder *)inClientData;
    [decoder handleAudioFileStreamProperty:inPropertyID flags:ioFlags];
}

static void PacketsCallback(void *inClientData,
                            UInt32 inNumberBytes,
                            UInt32 inNumberPackets,
                            const void *inInputData,
                            AudioStreamPacketDescription *__nullable inPacketDescriptions) {
    AudioStreamDecoder *decoder = (__bridge AudioStreamDecoder *)inClientData;
    [decoder handleAudioFileStreamPackets:inInputData
                            numberOfBytes:inNumberBytes
                          numberOfPackets:inNumberPackets
                       packetDescriptions:inPacketDescriptions];
}

@interface AudioStreamDecoder () {
    AudioFileStreamID audioFileStreamID;

    NSFileHandle *fileHandle;
    UInt64 fileSize;
    UInt64 fileOffset;
    AudioFormatID formatID;
}
@property (nonatomic) NSString *filePath;
@property (nonatomic) UInt32 parsePacketCount;
@property (nonatomic) UInt32 parseMaxPacketSize;
@property (nonatomic) NSMutableArray<AudioStreamData *> *parsedData;
@end

@implementation AudioStreamDecoder
- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _filePath = url.path;
        // 很不幸，AudioFileStream不支持m4a 😓
        // https://developer.apple.com/documentation/audiotoolbox/audio_file_stream_services?language=objc
        AudioFileTypeID fileType = [AudioUtil fileTypeForUrl:url];
        AudioFileStreamOpen((__bridge void *)self, PropertyListenerCallback, PacketsCallback, fileType, &audioFileStreamID);
        fileHandle = [NSFileHandle fileHandleForReadingFromURL:url error:nil];
        fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:url.path error:nil] fileSize];
        self.parsedData = [NSMutableArray array];

        [self decodeData];
    }
    return self;
}

- (void)dealloc {
    AudioFileStreamClose(audioFileStreamID);
    [fileHandle closeAndReturnError:nil];
}

- (void)readPacketsFromCurrent:(UInt32)currentPacket
                    numPackets:(UInt32 &)numPackets
            packetDescriptions:(AudioStreamPacketDescription *)packetDescriptions
                     outBuffer:(void *)outBuffer
                      numBytes:(UInt32 &)numBytes {
    numBytes = 0;
    int i;
    for (i = currentPacket; i < self.parsedData.count && i < currentPacket + numPackets; i++) {
        AudioStreamData *streamData = self.parsedData[i];
        packetDescriptions[i - currentPacket] = streamData.packetDescription;
        packetDescriptions[i - currentPacket].mStartOffset = numBytes;
        memcpy((char *)outBuffer + numBytes, streamData.data.bytes, streamData.data.length);
        numBytes += streamData.data.length;
    }
    numPackets = i - currentPacket;
}
#pragma mark -
- (void)handleAudioFileStreamProperty:(AudioFileStreamPropertyID)propertyID flags:(AudioFileStreamPropertyFlags *)ioFlags {
    AudioInfo(@"get property: %@", [AudioUtil enumValueToString:propertyID]);
    UInt32 size;
    AudioFileStreamGetPropertyInfo(audioFileStreamID, propertyID, &size, nil);

    if (propertyID == kAudioFileStreamProperty_DataFormat) {
        AudioFileStreamGetProperty(audioFileStreamID, kAudioFileStreamProperty_DataFormat, &size, dataFormat);
    } else if (propertyID == kAudioFileStreamProperty_MaximumPacketSize) {
        AudioFileStreamGetProperty(audioFileStreamID, kAudioFileStreamProperty_MaximumPacketSize, &size, &maxPacketSize);
    } else if (propertyID == kAudioFileStreamProperty_PacketSizeUpperBound) {
        AudioFileStreamGetProperty(audioFileStreamID, kAudioFileStreamProperty_PacketSizeUpperBound, &size, &maxPacketSize);
    } else if (propertyID == kAudioFileStreamProperty_ReadyToProducePackets) {
        AudioFileStreamGetProperty(audioFileStreamID, kAudioFileStreamProperty_ReadyToProducePackets, &size, &readyToProducePackets);

        if (audioDataByteCount == 0) {
            audioDataByteCount = [FileUtil fileSize:_filePath];
        }

        UInt32 outSize;
        AudioFileStreamGetPropertyInfo(audioFileStreamID, kAudioFileStreamProperty_MaximumPacketSize, &outSize, nil);
        if (maxPacketSize == 0) {
            AudioFileStreamGetProperty(audioFileStreamID, kAudioFileStreamProperty_MaximumPacketSize, &outSize, &maxPacketSize);
        }
        if (maxPacketSize == 0) {
            AudioFileStreamGetProperty(audioFileStreamID, kAudioFileStreamProperty_PacketSizeUpperBound, &outSize, &maxPacketSize);
        }
        if (maxPacketSize == 0) {
            maxPacketSize = audioDataByteCount / audioDataPacketCount;
        }
        if (bitRate == 0) {
            bitRate = dataFormat->mSampleRate * dataFormat->mBytesPerFrame * 8;
        }
        duration = audioDataByteCount * 8000 / bitRate;
    } else if (propertyID == kAudioFileStreamProperty_AudioDataByteCount) {
        AudioFileStreamGetProperty(audioFileStreamID, kAudioFileStreamProperty_AudioDataByteCount, &size, &audioDataByteCount);
    } else if (propertyID == kAudioFileStreamProperty_BitRate) {
        AudioFileStreamGetProperty(audioFileStreamID, kAudioFileStreamProperty_BitRate, &size, &bitRate);
    } else if (propertyID == kAudioFileStreamProperty_AudioDataPacketCount) {
        AudioFileStreamGetProperty(audioFileStreamID, kAudioFileStreamProperty_AudioDataPacketCount, &size, &audioDataPacketCount);
    } else if (propertyID == kAudioFileStreamProperty_DataOffset) {
        AudioFileStreamGetProperty(audioFileStreamID, kAudioFileStreamProperty_DataOffset, &size, &audioDataOffset);
    } else if (propertyID == kAudioFileStreamProperty_FileFormat) {
        AudioFileStreamGetProperty(audioFileStreamID, kAudioFileStreamProperty_FileFormat, &size, &formatID);
        AudioInfo(@"fileFormat: %@", [AudioUtil enumValueToString:formatID]);
    } else if (propertyID == kAudioFilePropertyFormatList) {
        UInt32 formatListSize;
        AudioFileStreamGetPropertyInfo(audioFileStreamID, kAudioFileStreamProperty_FormatList, &formatListSize, NULL);
        //获取formatlist
        AudioFormatListItem *formatList = (AudioFormatListItem *)malloc(formatListSize);
        AudioFileStreamGetProperty(audioFileStreamID, kAudioFilePropertyFormatList, &size, formatList);
    }
}

- (void)handleAudioFileStreamPackets:(const void *)packets
                       numberOfBytes:(UInt32)numberOfBytes
                     numberOfPackets:(UInt32)numberOfPackets
                  packetDescriptions:(AudioStreamPacketDescription *)packetDescriptions {
    for (int i = 0; i < numberOfPackets; i++) {
        AudioStreamData *streamData = [[AudioStreamData alloc] init];
        if (packetDescriptions == NULL) {
            NSData *data = [NSData dataWithBytes:(char *)packets + i * dataFormat->mBytesPerFrame length:dataFormat->mBytesPerFrame];
            streamData.data = data;
        } else {
            NSData *data = [NSData dataWithBytes:(char *)packets + packetDescriptions[i].mStartOffset length:packetDescriptions[i].mDataByteSize];
            streamData.data = data;
            streamData.packetDescription = packetDescriptions[i];

            _parseMaxPacketSize = MAX(_parseMaxPacketSize, packetDescriptions[i].mDataByteSize);
        }

        [self.parsedData addObject:streamData];
    }
    _parsePacketCount += numberOfPackets;
}

- (void)decodeData {
    while (fileOffset < fileSize) {
        NSData *data = [fileHandle readDataOfLength:4096];
        AudioFileStreamParseBytes(audioFileStreamID, (UInt32)[data length], [data bytes], 0);

        fileOffset += [data length];
    }

    if (audioDataPacketCount == 0) {
        audioDataPacketCount = _parsePacketCount;
    }
    if (maxPacketSize == 0) {
        maxPacketSize = _parseMaxPacketSize;
    }
}
@end
