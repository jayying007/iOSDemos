//
//  AudioQueuePlayer.m
//  Audio
//
//  Created by janezhuang on 2022/2/16.
//

#import "AudioQueuePlayer.h"
#import "AudioDataProvider.h"

#define kNumberBuffers 3
#define kBufferDuration 0.05

typedef struct AudioQueuePlayerState {
    AudioQueueRef mQueue;
    AudioQueueBufferRef mBuffers[kNumberBuffers];
    UInt32 mBufferSize;
    UInt64 mCurrentPacket;
    UInt32 mNumPacketsToRead;
    AudioStreamPacketDescription *mPacketDescs;

    BOOL mIsRunning;
} AudioQueuePlayerState;

@interface AudioQueuePlayer (Private)
- (void)handleOutputBuffer:(AudioQueueBufferRef)buffer;
@end

static void HandleOutputBuffer(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer) {
    AudioQueuePlayer *player = (__bridge AudioQueuePlayer *)inUserData;
    [player handleOutputBuffer:inBuffer];
}

static void
DeriveBufferSize(AudioStreamBasicDescription *dataFormat, UInt32 maxPacketSize, Float64 seconds, UInt32 *outBufferSize, UInt32 *outNumPacketsToRead) {
    static const int maxBufferSize = 0x50000;
    static const int minBufferSize = 0x4000;

    if (dataFormat->mFramesPerPacket != 0) {
        Float64 numPacketsForTime = dataFormat->mSampleRate / dataFormat->mFramesPerPacket * seconds;
        *outBufferSize = numPacketsForTime * maxPacketSize;
    } else {
        *outBufferSize = maxBufferSize > maxPacketSize ? maxBufferSize : maxPacketSize;
    }

    if (*outBufferSize > maxBufferSize && *outBufferSize > maxPacketSize) {
        *outBufferSize = maxBufferSize;
    } else if (*outBufferSize < minBufferSize) {
        *outBufferSize = minBufferSize;
    }

    *outNumPacketsToRead = *outBufferSize / maxPacketSize;
}

@interface AudioQueuePlayer () {
    AudioQueuePlayerState *mAqData;
    NSRecursiveLock *dataLock;
}
@property (nonatomic) AudioDataProvider *dataProvider;
@end

@implementation AudioQueuePlayer

@synthesize rate;

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        mAqData = (AudioQueuePlayerState *)malloc(sizeof(AudioQueuePlayerState));
        memset(mAqData, 0, sizeof(AudioQueuePlayerState));
        dataLock = [[NSRecursiveLock alloc] init];

        _dataProvider = [[AudioDataProvider alloc] initWithURL:url];
        [self initAudioQueue];
        AudioInfo(@"%s init success", __func__);
    }
    return self;
}

- (void)dealloc {
    if (mAqData->mQueue) {
        AudioQueueStop(mAqData->mQueue, true);
        AudioQueueDispose(mAqData->mQueue, true);
        mAqData->mQueue = NULL;
    }
    free(mAqData);
}

- (BOOL)play {
    OSStatus status = AudioQueueStart(mAqData->mQueue, 0);
    mAqData->mIsRunning = YES;
    return status == noErr;
}

- (void)pause {
    AudioQueuePause(mAqData->mQueue);
    mAqData->mIsRunning = NO;
}

- (void)resume {
    AudioQueueStart(mAqData->mQueue, 0);
    mAqData->mIsRunning = YES;
}

- (void)seekToTime:(UInt32)time {
    AudioQueueStop(mAqData->mQueue, true);
    //会有一点精度丢失（假如SampleRate不是1000的倍数）
    AudioStreamBasicDescription *dataFormat = _dataProvider.dataFormat;
    mAqData->mCurrentPacket = time * dataFormat->mSampleRate / 1000 / dataFormat->mFramesPerPacket;
    AudioInfo(@"seek packet:%llu", mAqData->mCurrentPacket);
    AudioQueueReset(mAqData->mQueue);
    for (int i = 0; i < kNumberBuffers; ++i) {
        [self handleOutputBuffer:mAqData->mBuffers[i]];
    }
    AudioQueueStart(mAqData->mQueue, 0);
}

- (void)stop {
    AudioQueueStop(mAqData->mQueue, false);
    mAqData->mCurrentPacket = 0;
    mAqData->mIsRunning = NO;
}

- (UInt32)currentTime {
    AudioStreamBasicDescription *dataFormat = _dataProvider.dataFormat;
    return mAqData->mCurrentPacket * dataFormat->mFramesPerPacket * 1000 / dataFormat->mSampleRate;
}

- (UInt32)duration {
    return _dataProvider.duration;
}

- (BOOL)isPlaying {
    return mAqData->mIsRunning;
}

- (void)setRate:(CGFloat)rate {
    AudioQueueSetParameter(mAqData->mQueue, kAudioQueueParam_PlayRate, rate);
}
#pragma mark -
- (void)initAudioQueue {
    AudioQueueNewOutput(_dataProvider.dataFormat, HandleOutputBuffer, (__bridge void *)self, nil, kCFRunLoopCommonModes, 0, &mAqData->mQueue);

    UInt32 bufferSize;
    UInt32 numPacketsToRead;
    DeriveBufferSize(_dataProvider.dataFormat, _dataProvider.maxPacketSize, kBufferDuration, &bufferSize, &numPacketsToRead);
    mAqData->mBufferSize = bufferSize;
    mAqData->mNumPacketsToRead = numPacketsToRead;
    mAqData->mPacketDescs = (AudioStreamPacketDescription *)calloc(numPacketsToRead, sizeof(AudioStreamPacketDescription));

    for (int i = 0; i < kNumberBuffers; ++i) {
        AudioQueueAllocateBuffer(mAqData->mQueue, mAqData->mBufferSize, &mAqData->mBuffers[i]);
        [self handleOutputBuffer:mAqData->mBuffers[i]];
    }

    UInt32 value = 1;
    AudioQueueSetProperty(mAqData->mQueue, kAudioQueueProperty_EnableTimePitch, &value, sizeof(UInt32));
}

- (void)handleOutputBuffer:(AudioQueueBufferRef)buffer {
    if (mAqData->mQueue == NULL) {
        return;
    }

    UInt32 numBytes = mAqData->mBufferSize;
    UInt32 numPackets = mAqData->mNumPacketsToRead;

    [_dataProvider readPacketsFromCurrent:mAqData->mCurrentPacket
                               numPackets:numPackets
                       packetDescriptions:mAqData->mPacketDescs
                                outBuffer:buffer->mAudioData
                                 numBytes:numBytes];

    if (numPackets > 0) {
        buffer->mAudioDataByteSize = numBytes;
        AudioQueueEnqueueBuffer(mAqData->mQueue, buffer, numPackets, mAqData->mPacketDescs);

        mAqData->mCurrentPacket += numPackets;
    } else {
        [self stop];
    }
}
@end
