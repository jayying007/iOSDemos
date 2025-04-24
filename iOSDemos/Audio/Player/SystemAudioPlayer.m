//
//  SystemAudioPlayer.m
//  Audio
//
//  Created by janezhuang on 2022/9/27.
//

#import "SystemAudioPlayer.h"

@interface SystemAudioPlayer ()

@property (nonatomic) AVPlayer *player;

@end

@implementation SystemAudioPlayer

@synthesize rate;

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
        playerItem.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmSpectral;

        self.player = [AVPlayer playerWithPlayerItem:playerItem];
        self.player.currentItem.canUseNetworkResourcesForLiveStreamingWhilePaused = NO;
        AudioInfo(@"%s init success", __func__);
    }
    return self;
}

- (BOOL)play {
    [self.player play];

    return YES;
}

- (void)pause {
    [self.player pause];
}

- (void)resume {
    [self.player play];
}

- (void)seekToTime:(UInt32)time {
    CMTime cmTime = {};
    cmTime.value = time;
    cmTime.timescale = 1000;
    cmTime.flags = kCMTimeFlags_Valid;

    [self.player seekToTime:cmTime];
}

- (void)stop {
    [self.player pause];
}

- (UInt32)currentTime {
    CMTime cmTime = self.player.currentItem.currentTime;
    return 1000.0 * cmTime.value / cmTime.timescale;
}

- (UInt32)duration {
    CMTime cmTime = self.player.currentItem.duration;
    return 1000.0 * cmTime.value / cmTime.timescale;
}

- (BOOL)isPlaying {
    return self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying;
}

- (void)setRate:(CGFloat)rate {
    self.player.rate = rate;
}

@end
