//
//  AnimateImageView.m
//  iOSDemos
//
//  Created by janezhuang on 2023/12/24.
//

#import "AnimateImageView.h"
#import <ImageIO/CGImageAnimation.h>

/**
 可以用来显示Gif，APng这类动态图；
 限制：IOS13.0及以上
 */
@interface AnimateImageView ()
@property (nonatomic, strong) UIImage *firstFrameImage;
@property (nonatomic, strong) NSData *data;

@property (nonatomic) NSUInteger beginningFrameIndex; //从哪一帧开始
@property (nonatomic) CGFloat delayPerFrame; //每一帧播放时长
@property (nonatomic) NSUInteger loopCount; //循环次数
@property (nonatomic) BOOL stopPlayback; //是否停止播放
@end

@implementation AnimateImageView

- (instancetype)initWithData:(NSData *)data {
    if ([super init]) {
        self.firstFrameImage = [UIImage imageWithData:data];
        self.data = data;

        self.beginningFrameIndex = 0;
        self.delayPerFrame = 0.04f;
        self.loopCount = 0;
        self.stopPlayback = NO;

        self.image = self.firstFrameImage;
    }
    return self;
}

- (void)startPlay {
    self.stopPlayback = NO;
    [self startAnimateImage];
}

- (void)stopPlay {
    self.stopPlayback = YES;
}

#pragma mark - Private
- (void)startAnimateImage {
    __weak typeof(self) weakSelf = self;
    NSDictionary *options = [self animationOptionsDictionary];
    if (@available(iOS 13.0, *)) {
        CGAnimateImageDataWithBlock((CFDataRef)self.data, (CFDictionaryRef)options, ^(size_t index, CGImageRef _Nonnull image, bool *_Nonnull stop) {
            *stop = weakSelf.stopPlayback;
            if (weakSelf.stopPlayback) {
                weakSelf.image = weakSelf.firstFrameImage;
            } else {
                weakSelf.image = [UIImage imageWithCGImage:image];
            }
        });
    }
}

- (NSDictionary *)animationOptionsDictionary {
    NSMutableDictionary<NSString *, NSNumber *> *options = [NSMutableDictionary new];
    if (@available(iOS 13.0, *)) {
        [options addEntriesFromDictionary:@{
            (NSString *)kCGImageAnimationStartIndex : @(self.beginningFrameIndex),
            (NSString *)kCGImageAnimationDelayTime : @(self.delayPerFrame)
        }];
        if (self.loopCount > 0) {
            options[(NSString *)kCGImageAnimationLoopCount] = @(self.loopCount);
        }
    }
    return [options copy];
}

@end
