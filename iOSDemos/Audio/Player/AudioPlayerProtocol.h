//
//  AudioPlayerProtocol.h
//  Audio
//
//  Created by janezhuang on 2022/2/14.
//

#import <AVFoundation/AVFoundation.h>

@protocol AudioPlayerProtocol <NSObject>

/// - Parameter url: 可以接受一个http链接，不过目前只有SystemAudioPlayer支持
- (instancetype)initWithURL:(NSURL *)url;

/// 从头播放
- (BOOL)play;

/// 暂停播放
- (void)pause;

/// 从暂停位置继续播放
- (void)resume;

/// 调整播放进度
/// @param time 对应开始播放位置，单位ms
- (void)seekToTime:(UInt32)time;

/// 停止播放
- (void)stop;

/// 当前播放位置，单位ms
- (UInt32)currentTime;

/// 总时长，单位ms
- (UInt32)duration;

/// @return 是否正在播放
- (BOOL)isPlaying;

/// 0.5x 1x 2x
@property (nonatomic) CGFloat rate;

@end
