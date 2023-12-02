//
//  MMUINavigationController.m
//  Album_StyleA
//
//  Created by janezhuang on 2022/5/20.
//

#import "MMUINavigationController.h"
#import "TransitionController.h"
#import "FloatTransitionMgr.h"
#import "PopAnimation.h"

@interface MMUINavigationController () <UINavigationControllerDelegate>

@end

@implementation MMUINavigationController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    self.delegate = self;
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    SEL transitionSelector = @selector(mmNavigationController:animationControllerForOperation:fromViewController:toViewController:);

    if ([fromVC respondsToSelector:transitionSelector] && operation == UINavigationControllerOperationPush) {
        return [(id<MMUINavigationControllerDelegate>)fromVC mmNavigationController:navigationController
                                                    animationControllerForOperation:operation
                                                                 fromViewController:fromVC
                                                                   toViewController:toVC];
    }

    if ([toVC respondsToSelector:transitionSelector] && operation == UINavigationControllerOperationPop) {
        return [(id<MMUINavigationControllerDelegate>)toVC mmNavigationController:navigationController
                                                  animationControllerForOperation:operation
                                                               fromViewController:fromVC
                                                                 toViewController:toVC];
    }

    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController isKindOfClass:TransitionController.class]) {
        return animationController;
    }
    if ([animationController isKindOfClass:PopAnimation.class]) {
        return [(id<UINavigationControllerDelegate>)Service(FloatTransitionMgr) navigationController:navigationController
                                                         interactionControllerForAnimationController:animationController];
    }
    return nil;
}

@end
