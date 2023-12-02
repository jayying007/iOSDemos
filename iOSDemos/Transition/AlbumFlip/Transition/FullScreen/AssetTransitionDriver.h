//
//  AssetTransitionDriver.h
//  Album_StyleB
//
//  Created by janezhuang on 2022/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetTransitionDriver : NSObject
- (instancetype)initWithOperation:(UINavigationControllerOperation)operation
                          context:(id<UIViewControllerContextTransitioning>)context
                       panGesture:(UIPanGestureRecognizer *)panGesture;
- (BOOL)isInteractive;

@property (nonatomic) UIViewPropertyAnimator *transitionAnimator;
@end

NS_ASSUME_NONNULL_END
