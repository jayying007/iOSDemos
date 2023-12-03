//
//  PushPopAnimationController.m
//  Album_StyleA
//
//  Created by janezhuang on 2022/5/20.
//

#import "FlipPushAnimationController.h"

@interface FlipPushAnimationController ()
@property (nonatomic) NSMutableArray *originFrames;
@end

@implementation FlipPushAnimationController
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    CGFloat duration = [self transitionDuration:transitionContext];

    //用来生成visibleCell
    [toView layoutIfNeeded];
    [containerView addSubview:toView];

    UIView *coverView = [self.coverView snapshotViewAfterScreenUpdates:YES];
    coverView.layer.anchorPoint = CGPointMake(0, 0.5);
    coverView.frame = self.originFrame;
    [containerView addSubview:coverView];

    [self setupVisibleCellsBeforePushToVC:(UICollectionViewController *)toVC];

    [UIView animateKeyframesWithDuration:duration
    delay:0
    options:0
    animations:^{
        [self addKeyFrameAnimationForFakeCoverView:coverView];
        [self addKeyFrameAnimationOnVisibleCellsToVC:(UICollectionViewController *)toVC];
    }
    completion:^(BOOL finished) {
        [coverView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

- (void)setupVisibleCellsBeforePushToVC:(UICollectionViewController *)toVC {
    CGRect areaRect = self.originFrame;
    CGFloat widthScale = areaRect.size.width / toVC.collectionView.width;
    CGFloat heightScale = areaRect.size.height / toVC.collectionView.height;

    self.originFrames = [NSMutableArray array];
    for (UICollectionViewCell *cell in toVC.collectionView.visibleCells) {
        [self.originFrames addObject:[NSValue valueWithCGPoint:cell.origin]];
        cell.transform = CGAffineTransformMakeScale(widthScale, heightScale);
        cell.origin = CGPointMake(cell.x * widthScale + areaRect.origin.x, cell.y * heightScale + areaRect.origin.y - 91);
    }
}

- (void)addKeyFrameAnimationOnVisibleCellsToVC:(UICollectionViewController *)toVC {
    int i = 0;
    for (UICollectionViewCell *cell in toVC.collectionView.visibleCells) {
        [UIView addKeyframeWithRelativeStartTime:0.5
                                relativeDuration:0.5
                                      animations:^{
                                          cell.transform = CGAffineTransformMakeScale(1, 1);
                                      }];
        [UIView addKeyframeWithRelativeStartTime:0.5
                                relativeDuration:0.5
                                      animations:^{
                                          CGPoint point = [self.originFrames[i] CGPointValue];
                                          cell.origin = point;
                                      }];
        i++;
    }
}

- (void)addKeyFrameAnimationForFakeCoverView:(UIView *)coverView {
    [UIView addKeyframeWithRelativeStartTime:0
                            relativeDuration:0.5
                                  animations:^{
                                      CATransform3D flipLeftTransform = CATransform3DIdentity;
                                      flipLeftTransform.m34 = -1.0 / 500;
                                      flipLeftTransform = CATransform3DRotate(flipLeftTransform, -M_PI, 0, 1, 0);
                                      coverView.layer.transform = flipLeftTransform;
                                  }];
    [UIView addKeyframeWithRelativeStartTime:0.2
                            relativeDuration:0.5
                                  animations:^{
                                      coverView.alpha = 0;
                                  }];
}
@end
