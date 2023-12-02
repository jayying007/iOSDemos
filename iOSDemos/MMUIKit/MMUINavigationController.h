//
//  MMUINavigationController.h
//  Album_StyleA
//
//  Created by janezhuang on 2022/5/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MMUINavigationControllerDelegate <NSObject>

@optional

- (nullable id<UIViewControllerInteractiveTransitioning>)mmNavigationController:(UINavigationController *)navigationController
                                    interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController;

- (nullable id<UIViewControllerAnimatedTransitioning>)mmNavigationController:(UINavigationController *)navigationController
                                             animationControllerForOperation:(UINavigationControllerOperation)operation
                                                          fromViewController:(UIViewController *)fromVC
                                                            toViewController:(UIViewController *)toVC;

@end

NS_ASSUME_NONNULL_END

@interface MMUINavigationController : UINavigationController

@end
