//
//  PopAnimation.m
//  FloatWindow
//
//  Created by janezhuang on 2022/5/21.
//

#import "PopAnimation.h"

@implementation PopAnimation
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];

    //将toView加到fromView的下面，非常重要！！！
    [[transitionContext containerView] insertSubview:toView belowSubview:fromView];

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    fromView.frame = CGRectMake(0, 0, width, height);
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
    animations:^{
        fromView.frame = CGRectMake(width, 0, width, height);
    }
    completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}
@end
