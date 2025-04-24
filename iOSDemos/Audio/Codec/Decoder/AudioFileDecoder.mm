//
//  AudioFileDecoder.m
//  Audio
//
//  Created by janezhuang on 2022/10/1.
//

#import "AudioFileDecoder.h"
#import <DevelopKit/AudioUtil.h>

@interface AudioFileDecoder (Private)
- (OSStatus)handleReadDataFrom:(SInt64)position count:(UInt32)requestCount toBuffer:(void *)buffer actualCount:(UInt32 *)actualCount;
- (UInt64)handleGetFileSize;
@end

static OSStatus ReadDataCallback(void *inClientData, SInt64 inPosition, UInt32 requestCount, void *buffer, UInt32 *actualCount) {
    AudioFileDecoder *decoder = (__bridge AudioFileDecoder *)inClientData;
    return [decoder handleReadDataFrom:inPosition count:requestCount toBuffer:buffer actualCount:actualCount];
}

static SInt64 GetSizeCallback(void *inClientData) {
    AudioFileDecoder *decoder = (__bridge AudioFileDecoder *)inClientData;
    return [decoder handleGetFileSize];
}

@interface AudioFileDecoder () {
    AudioFileID audioFile;

    NSFileHandle *fileHandle;
    UInt64 fileSize;
}
@end

@implementation AudioFileDecoder
- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        fileHandle = [NSFileHandle fileHandleForReadingFromURL:url error:nil];
        fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:url.path error:nil] fileSize];

        AudioFileTypeID fileType = [AudioUtil fileTypeForUrl:url];
        AudioFileOpenWithCallbacks((__bridge void *)self, ReadDataCallback, nil, GetSizeCallback, nil, fileType, &audioFile);

        [self readFileInfo];
    }
    return self;
}

- (void)dealloc {
    AudioFileClose(audioFile);
    [fileHandle closeAndReturnError:nil];
}

- (void)readPacketsFromCurrent:(UInt32)currentPacket
                    numPackets:(UInt32 &)numPackets
            packetDescriptions:(AudioStreamPacketDescription *)packetDescriptions
                     outBuffer:(void *)outBuffer
                      numBytes:(UInt32 &)numBytes {
    UInt32 numOfPackets = numPackets;
    UInt32 numOfBytes = numBytes;
    AudioFileReadPacketData(audioFile, false, &numOfBytes, packetDescriptions, currentPacket, &numOfPackets, outBuffer);
    numPackets = numOfPackets;
    numBytes = numOfBytes;
}
#pragma mark -
- (void)readFileInfo {
    UInt32 size;
    AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyDataFormat, &size, 0);
    AudioFileGetProperty(audioFile, kAudioFilePropertyDataFormat, &size, dataFormat);

    AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyAudioDataByteCount, &size, 0);
    AudioFileGetProperty(audioFile, kAudioFilePropertyAudioDataByteCount, &size, &audioDataByteCount);

    AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyAudioDataPacketCount, &size, 0);
    AudioFileGetProperty(audioFile, kAudioFilePropertyAudioDataPacketCount, &size, &audioDataPacketCount);

    AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyDataOffset, &size, 0);
    AudioFileGetProperty(audioFile, kAudioFilePropertyDataOffset, &size, &audioDataOffset);

    AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyMaximumPacketSize, &size, 0);
    AudioFileGetProperty(audioFile, kAudioFilePropertyMaximumPacketSize, &size, &maxPacketSize);

    AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyBitRate, &size, 0);
    AudioFileGetProperty(audioFile, kAudioFilePropertyBitRate, &size, &bitRate);

    duration = audioDataByteCount * 8000 / bitRate;
    if (maxPacketSize == 0) {
        maxPacketSize = audioDataByteCount / audioDataPacketCount;
    }
}

- (OSStatus)handleReadDataFrom:(SInt64)position count:(UInt32)requestCount toBuffer:(void *)buffer actualCount:(UInt32 *)actualCount {
    [fileHandle seekToFileOffset:position];
    NSData *data = [fileHandle readDataOfLength:requestCount];

    memcpy(buffer, data.bytes, data.length);
    *actualCount = (UInt32)data.length;

    return noErr;
}

- (UInt64)handleGetFileSize {
    return fileSize;
}
@end
