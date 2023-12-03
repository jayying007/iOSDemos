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
#import "MMUIViewControllerTransitioning.h"

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

    if (operation == UINavigationControllerOperationPush && [fromVC respondsToSelector:transitionSelector]) {
        return [(id<MMUINavigationControllerDelegate>)fromVC mmNavigationController:navigationController
                                                    animationControllerForOperation:operation
                                                                 fromViewController:fromVC
                                                                   toViewController:toVC];
    }

    if (operation == UINavigationControllerOperationPop && [toVC respondsToSelector:transitionSelector]) {
        return [(id<MMUINavigationControllerDelegate>)toVC mmNavigationController:navigationController
                                                  animationControllerForOperation:operation
                                                               fromViewController:fromVC
                                                                 toViewController:toVC];
    }

    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController conformsToProtocol:@protocol(MMUIViewControllerAnimatedTransitioning)]) {
        let fromVC = [(id<MMUIViewControllerAnimatedTransitioning>)animationController fromVC];
        SEL transitionSelector = @selector(mmNavigationController:interactionControllerForAnimationController:);
        if ([fromVC respondsToSelector:transitionSelector]) {
            return [(id<MMUINavigationControllerDelegate>)fromVC mmNavigationController:navigationController
                                            interactionControllerForAnimationController:animationController];
        }
    }

    return nil;
}

@end
