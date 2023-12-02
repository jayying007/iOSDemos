//
//  TransitionController.m
//  Album_StyleB
//
//  Created by janezhuang on 2022/5/22.
//

#import "TransitionController.h"
#import "AssetTransitionDriver.h"

@interface TransitionController () <UIGestureRecognizerDelegate>
@property (nonatomic, weak) UINavigationController *navController;
@property (nonatomic) UIPanGestureRecognizer *panGesture;
@property (nonatomic) BOOL initiallyInteractive;
@property (nonatomic) AssetTransitionDriver *transitionDriver;

@end

@implementation TransitionController
- (instancetype)initWithNavController:(UINavigationController *)navController {
    self = [super init];
    if (self) {
        self.navController = navController;

        [self configGesture];
    }
    return self;
}
#pragma mark - Gesture
- (void)configGesture {
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGesture.delegate = self;
    [self.navController.view addGestureRecognizer:self.panGesture];

    [self.panGesture requireGestureRecognizerToFail:self.navController.interactivePopGestureRecognizer];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.transitionDriver) {
        return [self.transitionDriver isInteractive];
    }

    CGPoint translation = [self.panGesture translationInView:self.panGesture.view];
    BOOL translationVertical = translation.y > 0 && (fabs(translation.y) > fabs(translation.x));
    return translationVertical && self.navController.viewControllers.count > 1;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        self.initiallyInteractive = YES;
        [self.navController popViewControllerAnimated:YES];
    }
}
#pragma mark -
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    self.operation = operation;
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self;
}
#pragma mark -
- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionDriver = [[AssetTransitionDriver alloc] initWithOperation:self.operation context:transitionContext panGesture:self.panGesture];
}

- (BOOL)wantsInteractiveStart {
    return self.initiallyInteractive;
}
#pragma mark -
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.8;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSLog(@"这是一个空实现");
}

- (void)animationEnded:(BOOL)transitionCompleted {
    self.transitionDriver = nil;
    self.initiallyInteractive = NO;
    self.operation = UINavigationControllerOperationNone;
}

- (id<UIViewImplicitlyAnimating>)interruptibleAnimatorForTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionDriver.transitionAnimator;
}
@end
