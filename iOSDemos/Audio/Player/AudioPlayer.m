//
//  AudioPlayer.m
//  Audio
//
//  Created by janezhuang on 2022/2/15.
//

#import "AudioPlayer.h"

@interface AudioPlayer ()

@property (nonatomic) AVAudioPlayer *player;

@end

@implementation AudioPlayer

@synthesize rate;

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        NSError *error;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        self.player.enableRate = YES;
        AudioInfo(@"%s error:%@", __func__, error);
    }
    return self;
}

- (BOOL)play {
    BOOL ret = [self.player play];

    return ret;
}

- (void)pause {
    [self.player pause];
}

- (void)resume {
    [self.player play];
}

- (void)seekToTime:(UInt32)time {
    [self.player setCurrentTime:time / 1000];
}

- (void)stop {
    [self.player stop];
}

- (UInt32)currentTime {
    return [self.player currentTime] * 1000;
}

- (UInt32)duration {
    return [self.player duration] * 1000;
}

- (BOOL)isPlaying {
    return [self.player isPlaying];
}

- (void)setRate:(CGFloat)rate {
    self.player.rate = rate;
}
@end
