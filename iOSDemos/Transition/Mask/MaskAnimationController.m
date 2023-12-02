//
//  MaskAnimationController.m
//  Mask
//
//  Created by janezhuang on 2022/6/26.
//

#import "MaskAnimationController.h"

@interface MaskAnimationController () <CAAnimationDelegate>
@end

@implementation MaskAnimationController
#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];

    UIView *targetView;
    UIBezierPath *startPath;
    UIBezierPath *endPath;
    if (self.type == MaskTransitionTypePresent) {
        targetView = toView;
        startPath = [UIBezierPath bezierPathWithRect:self.originFrame];
        endPath = [UIBezierPath bezierPathWithRect:[transitionContext finalFrameForViewController:toVC]];

        [containerView addSubview:toView];
    } else if (self.type == MaskTransitionTypeDismiss) {
        targetView = fromView;
        startPath = [UIBezierPath bezierPathWithRect:[transitionContext initialFrameForViewController:fromVC]];
        endPath = [UIBezierPath bezierPathWithRect:self.originFrame];
    }

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endPath.CGPath;
    targetView.layer.mask = maskLayer;
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(startPath.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endPath.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
    if (self.type == MaskTransitionTypePresent) {
        [transitionContext viewForKey:UITransitionContextToViewKey].layer.mask = nil;
    } else if (self.type == MaskTransitionTypeDismiss) {
        [transitionContext viewForKey:UITransitionContextFromViewKey].layer.mask = nil;
    }
    [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
}
@end
