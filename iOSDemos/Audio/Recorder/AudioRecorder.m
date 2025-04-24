//
//  AudioRecorder.m
//  Audio
//
//  Created by janezhuang on 2022/2/15.
//

#import "AudioRecorder.h"
#import "AudioEncoder.h"

@interface AudioRecorder ()

@property (nonatomic) AVAudioRecorder *recorder;
@property (nonatomic) AudioEncoder *encoder;

@end

@implementation AudioRecorder

@synthesize filePath = _filePath;

- (instancetype)initWithFilePath:(NSString *)filePath fileType:(AudioFileTypeID)fileType {
    self = [super init];
    if (self) {
        _filePath = filePath;
        _encoder = [[AudioEncoder alloc] initWithFileType:fileType];
        NSString *pcmPath = [[filePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"pcm"];
        NSURL *url = [NSURL fileURLWithPath:pcmPath];

        AudioStreamBasicDescription asbd;
        asbd.mFormatID = kAudioFormatLinearPCM;
        asbd.mSampleRate = 44100.0;
        asbd.mChannelsPerFrame = 1;
        asbd.mBitsPerChannel = 16;
        asbd.mBytesPerPacket = asbd.mBytesPerFrame = asbd.mChannelsPerFrame * sizeof(SInt16);
        asbd.mFramesPerPacket = 1;
        asbd.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
        AVAudioFormat *format = [[AVAudioFormat alloc] initWithStreamDescription:&asbd];

        NSError *error;
        self.recorder = [[AVAudioRecorder alloc] initWithURL:url format:format error:&error];
        AudioInfo(@"init recorder, error:%@", error);
    }
    return self;
}

- (BOOL)isRecording {
    return self.recorder.isRecording;
}

- (UInt32)currentTime {
    return [self.recorder currentTime] * 1000;
}

- (void)record {
    [self.recorder record];
}

- (void)stop {
    [self.recorder stop];

    NSString *pcmPath = [[_filePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"pcm"];
    const AudioStreamBasicDescription *format = self.recorder.format.streamDescription;
    [_encoder encodePCMFileFromPath:pcmPath withFormat:format toPath:_filePath];
}

@end
