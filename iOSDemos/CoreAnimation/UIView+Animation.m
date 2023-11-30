//
//  UIView+Animation.m
//  Animation
//
//  Created by janezhuang on 2023/1/11.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)
- (void)shake {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[ @0, @10, @-10, @10, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    animation.duration = 0.4;
    animation.additive = YES; // 在原来的基础上，增加value

    [self.layer addAnimation:animation forKey:@"shake"];
}
@end
