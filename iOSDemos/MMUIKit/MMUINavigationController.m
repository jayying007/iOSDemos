//
//  MMUINavigationController.m
//  Album_StyleA
//
//  Created by janezhuang on 2022/5/20.
//

#import "MMUINavigationController.h"

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
    SEL transitionSelector = @selector(navigationController:animationControllerForOperation:fromViewController:toViewController:);

    if ([fromVC respondsToSelector:transitionSelector]) {
        return [(id<UINavigationControllerDelegate>)fromVC navigationController:navigationController
                                                animationControllerForOperation:operation
                                                             fromViewController:fromVC
                                                               toViewController:toVC];
    }

    return nil;
}

@end
