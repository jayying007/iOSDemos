//
//  PlayerViewController.m
//  Audio
//
//  Created by janezhuang on 2022/2/14.
//

#import "PlayerViewController.h"
#import "AudioPlayerProtocol.h"
#import "PlayListViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AudioManager.h"

@interface PlayerViewController ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UISlider *progressSlider;
@property (nonatomic) UIButton *rateBtn;
@property (nonatomic) UIButton *startBtn;
@property (nonatomic) UIButton *pauseBtn;
@property (nonatomic) UIButton *playListBtn;

@end

@implementation PlayerViewController

- (void)loadView {
    [super loadView];

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.width - 200) / 2, 120, 200, 60)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];

    self.progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, self.titleLabel.bottom + 60, self.view.width - 40, 60)];
    [self.view addSubview:self.progressSlider];

    self.startBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width - 80) / 2, self.view.bottom - 160, 80, 80)];
    [self.startBtn setBackgroundImage:[UIImage imageNamed:@"playImg"] forState:UIControlStateNormal];
    [self.view addSubview:self.startBtn];

    self.pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width - 80) / 2, self.view.bottom - 160, 80, 80)];
    [self.pauseBtn setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [self.view addSubview:self.pauseBtn];

    self.rateBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 40, 40)];
    self.rateBtn.centerY = self.startBtn.centerY;
    [self.rateBtn setTitle:@"1x" forState:UIControlStateNormal];
    [self.rateBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    self.rateBtn.layer.borderWidth = 1;
    self.rateBtn.layer.cornerRadius = 8;
    [self.view addSubview:self.rateBtn];

    self.playListBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 80, self.rateBtn.y, 40, 40)];
    [self.playListBtn setBackgroundImage:[UIImage imageNamed:@"playList"] forState:UIControlStateNormal];
    [self.view addSubview:self.playListBtn];

    self.progressSlider.bottom = self.startBtn.top - 60;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;

    [self.startBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.pauseBtn addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [self.rateBtn addTarget:self action:@selector(rate) forControlEvents:UIControlEventTouchUpInside];
    [self.playListBtn addTarget:self action:@selector(jumpToPlayList) forControlEvents:UIControlEventTouchUpInside];
    [self.progressSlider addTarget:self action:@selector(progressChange) forControlEvents:UIControlEventTouchUpInside];

    weakify(self);
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                    repeats:YES
                                      block:^(NSTimer *_Nonnull timer) {
                                          strongify(self);
                                          if (self == nil) {
                                              [timer invalidate];
                                              return;
                                          }
                                          [self updateUI];
                                      }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI {
    AudioManager *manager = [AudioManager manager];

    NSString *filePath = manager.currentPlayPath;
    self.titleLabel.text = filePath.lastPathComponent;

    id<AudioPlayerProtocol> player = manager.currentPlayer;
    if (player.isPlaying) {
        self.startBtn.hidden = YES;
        self.pauseBtn.hidden = NO;
    } else {
        self.startBtn.hidden = NO;
        self.pauseBtn.hidden = YES;
    }

    if (!self.progressSlider.tracking) {
        self.progressSlider.value = (Float32)[player currentTime] / [player duration];
    }
}

- (void)play {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];

    id<AudioPlayerProtocol> player = [[AudioManager manager] currentPlayer];
    [player play];

    NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
    songInfo[MPMediaItemPropertyTitle] = @"你的我的";
    songInfo[MPMediaItemPropertyArtist] = @"梁博";
    songInfo[MPMediaItemPropertyAlbumTitle] = @"歌手";
    songInfo[MPMediaItemPropertyPlaybackDuration] = @(120);
    songInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(0);
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeMake(48, 48)
                                                                  requestHandler:^UIImage *_Nonnull(CGSize size) {
                                                                      return [UIImage imageNamed:@"zoo"];
                                                                  }];
    songInfo[MPMediaItemPropertyArtwork] = artwork;
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
}

- (void)pause {
    id<AudioPlayerProtocol> player = [[AudioManager manager] currentPlayer];
    [player pause];

    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
}

- (void)rate {
    id<AudioPlayerProtocol> player = [[AudioManager manager] currentPlayer];
    if ([self.rateBtn.currentTitle isEqualToString:@"1x"]) {
        [self.rateBtn setTitle:@"2x" forState:UIControlStateNormal];
        player.rate = 2;
    } else if ([self.rateBtn.currentTitle isEqualToString:@"2x"]) {
        [self.rateBtn setTitle:@"0.5x" forState:UIControlStateNormal];
        player.rate = 0.5;
    } else {
        [self.rateBtn setTitle:@"1x" forState:UIControlStateNormal];
        player.rate = 1;
    }
}

- (void)progressChange {
    id<AudioPlayerProtocol> player = [[AudioManager manager] currentPlayer];
    [player seekToTime:self.progressSlider.value * player.duration];
}

- (void)jumpToPlayList {
    PlayListViewController *vc = [[PlayListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.rateBtn setTitle:@"1x" forState:UIControlStateNormal];
}
@end
