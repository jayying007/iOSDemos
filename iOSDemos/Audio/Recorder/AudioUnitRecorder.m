//
//  AudioUnitRecorder.m
//  Audio
//
//  Created by janezhuang on 2022/10/16.
//

#import "AudioUnitRecorder.h"
#import "AudioEncoder.h"
#import <DevelopKit/FileUtil.h>

#define kInputBus 1
#define kOutputBus 0

@interface AudioUnitRecorder (Private)
- (OSStatus)handleRenderCallback:(AudioUnitRenderActionFlags *)actionFlags
                       timeStamp:(const AudioTimeStamp *)timeStamp
                       busNumber:(UInt32)busNumber
                    numberFrames:(UInt32)numberFrames
                            data:(AudioBufferList *)data;
@end

static OSStatus RenderCallback(void *inRefCon,
                               AudioUnitRenderActionFlags *ioActionFlags,
                               const AudioTimeStamp *inTimeStamp,
                               UInt32 inBusNumber,
                               UInt32 inNumberFrames,
                               AudioBufferList *__nullable ioData) {
    AudioUnitRecorder *recorder = (__bridge AudioUnitRecorder *)inRefCon;
    return [recorder handleRenderCallback:ioActionFlags timeStamp:inTimeStamp busNumber:inBusNumber numberFrames:inNumberFrames data:ioData];
}

@interface AudioUnitRecorder () {
    AudioUnit ioUnit;
    UInt64 currentFrame;
    AudioStreamBasicDescription dataFormat;
}
@property (nonatomic) NSFileHandle *pcmFileHandle;
@property (nonatomic) AudioEncoder *encoder;
@end

@implementation AudioUnitRecorder

@synthesize filePath = _filePath;

- (instancetype)initWithFilePath:(NSString *)filePath fileType:(AudioFileTypeID)fileType {
    self = [super init];
    if (self) {
        _filePath = filePath;
        NSString *pcmPath = [[_filePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"pcm"];
        [FileUtil createFile:pcmPath];
        _pcmFileHandle = [NSFileHandle fileHandleForWritingAtPath:pcmPath];

        _encoder = [[AudioEncoder alloc] initWithFileType:fileType];
        [self initAudioUnit];
    }
    return self;
}

- (void)record {
    AudioOutputUnitStart(ioUnit);
}

- (void)stop {
    AudioOutputUnitStop(ioUnit);

    [_pcmFileHandle closeFile];
    NSString *pcmPath = [[_filePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"pcm"];
    [_encoder encodePCMFileFromPath:pcmPath withFormat:&dataFormat toPath:_filePath];
}

- (UInt32)currentTime {
    return currentFrame * 1000 / dataFormat.mSampleRate;
}

- (BOOL)isRecording {
    UInt32 size;
    AudioUnitGetPropertyInfo(ioUnit, kAudioOutputUnitProperty_IsRunning, kAudioUnitScope_Global, kOutputBus, &size, nil);
    UInt32 isRunning = 0;
    AudioUnitGetProperty(ioUnit, kAudioOutputUnitProperty_IsRunning, kAudioUnitScope_Global, kOutputBus, &isRunning, &size);

    return isRunning > 0;
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
    AudioUnitSetProperty(ioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, kInputBus, &flag, sizeof(flag));

    [self initDataFormat];
    AudioUnitSetProperty(ioUnit,
                         kAudioUnitProperty_StreamFormat,
                         kAudioUnitScope_Output,
                         kInputBus,
                         &dataFormat,
                         sizeof(AudioStreamBasicDescription));

    AURenderCallbackStruct renderCallback;
    renderCallback.inputProc = RenderCallback;
    renderCallback.inputProcRefCon = (__bridge void *)self;
    AudioUnitSetProperty(ioUnit,
                         kAudioOutputUnitProperty_SetInputCallback,
                         kAudioUnitScope_Global,
                         kInputBus,
                         &renderCallback,
                         sizeof(renderCallback));

    AudioUnitInitialize(ioUnit);
}

- (void)initDataFormat {
    dataFormat.mFormatID = kAudioFormatLinearPCM;
    dataFormat.mSampleRate = 44100;
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
    AudioBufferList *bufferList = (AudioBufferList *)malloc(sizeof(AudioBufferList));
    bufferList->mNumberBuffers = 1;
    bufferList->mBuffers[0].mNumberChannels = dataFormat.mChannelsPerFrame;
    bufferList->mBuffers[0].mDataByteSize = numberFrames * dataFormat.mBytesPerFrame;
    bufferList->mBuffers[0].mData = malloc(bufferList->mBuffers[0].mDataByteSize);

    AudioUnitRender(ioUnit, actionFlags, timeStamp, busNumber, numberFrames, bufferList);

    NSData *pcmData = [NSData dataWithBytes:bufferList->mBuffers[0].mData length:bufferList->mBuffers[0].mDataByteSize];
    [_pcmFileHandle writeData:pcmData];
    currentFrame += numberFrames;

    return noErr;
}
@end
