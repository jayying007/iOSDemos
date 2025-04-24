//
//  AudioQueueRecorder.m
//  Audio
//
//  Created by janezhuang on 2022/2/16.
//

#import "AudioQueueRecorder.h"
#import "AudioEncoder.h"
#import <DevelopKit/FileUtil.h>

#define kNumberBuffers 3
#define kBufferDuration 0.5

typedef struct AudioQueuePlayerState {
    AudioQueueRef mQueue;
    AudioQueueBufferRef mBuffers[kNumberBuffers];
    UInt32 mBufferSize;
    UInt64 mCurrentFrame;
    AudioStreamBasicDescription format;
} AudioQueueRecorderState;

@interface AudioQueueRecorder (Private)
- (void)handleInputBuffer:(AudioQueueBufferRef)buffer;
@end

static void HandleInputBuffer(void *aqData,
                              AudioQueueRef inAQ,
                              AudioQueueBufferRef inBuffer,
                              const AudioTimeStamp *inStartTime,
                              UInt32 inNumPackets,
                              const AudioStreamPacketDescription *inPacketDesc) {
    AudioQueueRecorder *recorder = (__bridge AudioQueueRecorder *)aqData;
    [recorder handleInputBuffer:inBuffer];
}

@interface AudioQueueRecorder () {
    AudioQueueRecorderState *mAqData;
}
@property (nonatomic) NSFileHandle *pcmFileHandle;
@property (nonatomic) AudioEncoder *encoder;
@end

@implementation AudioQueueRecorder

@synthesize filePath = _filePath;

- (instancetype)initWithFilePath:(NSString *)filePath fileType:(AudioFileTypeID)fileType {
    self = [super init];
    if (self) {
        mAqData = (AudioQueueRecorderState *)malloc(sizeof(AudioQueueRecorderState));
        memset(mAqData, 0, sizeof(AudioQueueRecorderState));

        _filePath = filePath;
        _encoder = [[AudioEncoder alloc] initWithFileType:fileType];
        [self prepareRecord];
    }
    return self;
}

- (BOOL)isRecording {
    UInt32 outDataSize;
    AudioQueueGetPropertySize(mAqData->mQueue, kAudioQueueProperty_IsRunning, &outDataSize);

    UInt32 outData;
    AudioQueueGetProperty(mAqData->mQueue, kAudioQueueProperty_IsRunning, &outData, &outDataSize);

    return outData != 0;
}

- (void)record {
    AudioQueueStart(mAqData->mQueue, 0);
}

- (void)stop {
    AudioQueueStop(mAqData->mQueue, YES);

    [_pcmFileHandle closeFile];
    NSString *pcmPath = [[_filePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"pcm"];
    [_encoder encodePCMFileFromPath:pcmPath withFormat:&mAqData->format toPath:_filePath];
}

- (UInt32)currentTime {
    return mAqData->mCurrentFrame * 1000 / mAqData->format.mSampleRate;
}
#pragma mark -
- (void)prepareRecord {
    AudioStreamBasicDescription asbd;
    asbd.mFormatID = kAudioFormatLinearPCM;
    asbd.mSampleRate = 44100.0;
    asbd.mChannelsPerFrame = 1;
    asbd.mBitsPerChannel = 16;
    asbd.mBytesPerPacket = asbd.mBytesPerFrame = asbd.mChannelsPerFrame * sizeof(SInt16);
    asbd.mFramesPerPacket = 1;
    asbd.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    mAqData->format = asbd;

    NSString *pcmPath = [[_filePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"pcm"];
    [FileUtil createFile:pcmPath];
    _pcmFileHandle = [NSFileHandle fileHandleForWritingAtPath:pcmPath];

    AudioQueueNewInput(&asbd, HandleInputBuffer, (__bridge void *)self, CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &mAqData->mQueue);
    mAqData->mBufferSize = asbd.mSampleRate * kBufferDuration * asbd.mBytesPerFrame;
    for (int i = 0; i < kNumberBuffers; ++i) {
        AudioQueueAllocateBuffer(mAqData->mQueue, mAqData->mBufferSize, &mAqData->mBuffers[i]);
        AudioQueueEnqueueBuffer(mAqData->mQueue, mAqData->mBuffers[i], 0, 0);
    }
}

- (void)handleInputBuffer:(AudioQueueBufferRef)buffer {
    if (buffer->mAudioDataByteSize > 0) {
        NSData *pcmData = [NSData dataWithBytes:buffer->mAudioData length:buffer->mAudioDataByteSize];
        [_pcmFileHandle writeData:pcmData];
        mAqData->mCurrentFrame += buffer->mAudioDataByteSize / mAqData->format.mBytesPerFrame;
    }
    AudioQueueEnqueueBuffer(mAqData->mQueue, buffer, 0, 0);
}
@end
