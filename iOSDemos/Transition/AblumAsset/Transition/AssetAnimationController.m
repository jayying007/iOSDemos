//
//  AssetAnimationController.m
//  Album_StyleC
//
//  Created by janezhuang on 2022/11/15.
//

#import "AssetAnimationController.h"

@interface AssetAnimationController () <UIViewControllerAnimatedTransitioning>
@property (nonatomic) int type;
@property (nonatomic) NSArray *transitionItems;
@end

@implementation AssetAnimationController
#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    self.type = 1;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.type = 2;
    return self;
}
#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.type == 1) {
        [self animatePresent:transitionContext];
    } else {
        [self animateDismiss:transitionContext];
    }
}

- (void)animatePresent:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    UIView *containerView = [transitionContext containerView];
    UIViewController<AssetTransitioning> *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UINavigationController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController<AssetTransitioning> *presentingVC = (UIViewController<AssetTransitioning> *)[fromVC topViewController];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UICollectionView *collectionView = toVC.collectionView;
    //用来生成visibleCell
    [toView layoutIfNeeded];
    [containerView addSubview:fromView];
    [containerView addSubview:toView];

    self.transitionItems = [presentingVC itemsForAssetTransition:transitionContext];
    for (AssetTransitionItem *item in self.transitionItems) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:item.indexPath];
        item.finalFrame = cell.frame;
    }

    [UIView animateKeyframesWithDuration:duration
    delay:0
    options:0
    animations:^{
        NSArray *visibleIndexPaths = collectionView.indexPathsForVisibleItems;
        visibleIndexPaths = [visibleIndexPaths sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *obj1, NSIndexPath *obj2) {
            if (obj1.item > obj2.item) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }];
        CGFloat timeOffset = 0;
        for (NSIndexPath *indexPath in visibleIndexPaths) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            AssetTransitionItem *item = [self findTransitionItemFrom:self.transitionItems withIndexPath:indexPath];
            if (item) {
                CGRect rect = [collectionView convertRect:item.initialFrame fromView:fromView];
                cell.frame = rect;
                [UIView addKeyframeWithRelativeStartTime:timeOffset
                                        relativeDuration:0.5
                                              animations:^{
                                                  cell.frame = item.finalFrame;
                                              }];
                timeOffset += 0.05;
            } else {
                cell.alpha = 0;
                [UIView addKeyframeWithRelativeStartTime:0
                                        relativeDuration:1
                                              animations:^{
                                                  cell.alpha = 1;
                                              }];
            }
        }

        for (AssetTransitionItem *item in self.transitionItems) {
            item.originView.hidden = YES;
        }

        toView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [UIView addKeyframeWithRelativeStartTime:0
                                relativeDuration:1
                                      animations:^{
                                          toView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
                                      }];
    }
    completion:^(BOOL finished) {
        for (AssetTransitionItem *item in self.transitionItems) {
            item.originView.hidden = NO;
        }
        [transitionContext completeTransition:YES];
    }];
}

- (void)animateDismiss:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    UIView *containerView = [transitionContext containerView];
    //    UIViewController<AssetTransitioning> *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController<AssetTransitioning, UICollectionViewDataSource> *fromVC =
    [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UICollectionView *collectionView = fromVC.collectionView;

    [containerView addSubview:fromView];
    [containerView addSubview:toView];

    for (AssetTransitionItem *item in self.transitionItems) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:item.indexPath];
        item.finalFrame = cell.frame;
    }

    int visibleItemCount = 0;
    NSArray *visibleIndexPaths = collectionView.indexPathsForVisibleItems;
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        AssetTransitionItem *item = [self findTransitionItemFrom:self.transitionItems withIndexPath:indexPath];
        if (item) {
            visibleItemCount++;
        }
    }
    BOOL allItemVisible = (visibleItemCount == self.transitionItems.count);

    [UIView animateKeyframesWithDuration:duration
    delay:0
    options:0
    animations:^{
        if (allItemVisible) {
            CGAffineTransform transform = CGAffineTransformIdentity;
            for (UICollectionViewCell *cell in collectionView.visibleCells) {
                AssetTransitionItem *item = [self findTransitionItemFrom:self.transitionItems forCell:cell collectionView:collectionView];
                if (item) {
                    [UIView addKeyframeWithRelativeStartTime:0
                                            relativeDuration:1
                                                  animations:^{
                                                      CGRect rect = [collectionView convertRect:item.initialFrame fromView:toView];
                                                      cell.frame = rect;
                                                  }];
                    transform = CGAffineTransformMakeScale(CGRectGetWidth(item.initialFrame) / CGRectGetWidth(cell.frame),
                                                           CGRectGetHeight(item.initialFrame) / CGRectGetHeight(cell.frame));
                } else {
                    [UIView addKeyframeWithRelativeStartTime:0
                                            relativeDuration:1
                                                  animations:^{
                                                      cell.alpha = 0;
                                                  }];
                    //同步缩小
                    [UIView addKeyframeWithRelativeStartTime:0
                                            relativeDuration:1
                                                  animations:^{
                                                      cell.transform = transform;
                                                  }];
                }
            }
            //        for (AssetTransitionItem *item in self.transitionItems) {
            //            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
            //                UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:item.indexPath];
            //                CGRect rect = [collectionView convertRect:item.initialFrame fromView:toView];
            //                cell.frame = rect;
            //            }];
            //        }
            for (AssetTransitionItem *item in self.transitionItems) {
                item.originView.hidden = YES;
            }
        } else {
            for (AssetTransitionItem *item in self.transitionItems) {
                item.originView.hidden = NO;
                item.originView.alpha = 0;
                [UIView addKeyframeWithRelativeStartTime:0
                                        relativeDuration:1
                                              animations:^{
                                                  item.originView.alpha = 1;
                                              }];
            }
            for (UICollectionViewCell *cell in collectionView.visibleCells) {
                [UIView addKeyframeWithRelativeStartTime:0
                                        relativeDuration:1
                                              animations:^{
                                                  cell.alpha = 0;
                                              }];
            }
        }

        [UIView addKeyframeWithRelativeStartTime:0
                                relativeDuration:1
                                      animations:^{
                                          fromView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
                                      }];
    }
    completion:^(BOOL finished) {
        if (allItemVisible) {
            for (AssetTransitionItem *item in self.transitionItems) {
                item.originView.hidden = NO;
            }
        }
        [transitionContext completeTransition:YES];
    }];
}

- (AssetTransitionItem *)findTransitionItemFrom:(NSArray *)transitionItems
                                        forCell:(UICollectionViewCell *)cell
                                 collectionView:(UICollectionView *)collectionView {
    NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
    for (AssetTransitionItem *item in transitionItems) {
        if ([item.indexPath isEqual:indexPath]) {
            return item;
        }
    }
    return nil;
}

- (AssetTransitionItem *)findTransitionItemFrom:(NSArray *)transitionItems withIndexPath:(NSIndexPath *)indexPath {
    for (AssetTransitionItem *item in transitionItems) {
        if ([item.indexPath isEqual:indexPath]) {
            return item;
        }
    }
    return nil;
}

@end
