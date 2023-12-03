//
//  UIDrawerController.m
//  UIDrawerControllerDemo
//
//  Created by janezhuang on 2022/5/21.
//

#import "UIDrawerController.h"
#import "UIView+Frame.h"

@implementation UIViewController (UIDrawerController)
- (UIDrawerController *)drawerController {
    UIViewController *vc = self;
    while (vc && ![vc isKindOfClass:UIDrawerController.class]) {
        vc = vc.parentViewController;
    }
    return (UIDrawerController *)vc;
}
@end

const CGFloat kAnimateDuration = 0.4;

@interface UIDrawerController ()
@property (nonatomic) UIViewController *rootViewController;
@property (nonatomic) UIScreenEdgePanGestureRecognizer *leftEdgePanGesture; // for rootViewController
@property (nonatomic) UIScreenEdgePanGestureRecognizer *rightEdgePanGesture; // for leftViewController
@property (nonatomic) BOOL leftControllerDirty;
@end

@implementation UIDrawerController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super init];
    if (self) {
        self.rootViewController = rootViewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //Init rootViewController
    [self addChildViewController:self.rootViewController];
    self.rootViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.rootViewController.view];
    [self.rootViewController didMoveToParentViewController:self];
}

- (void)setLeftViewController:(UIViewController *)leftViewController {
    if (_leftViewController != nil) {
        [_leftViewController willMoveToParentViewController:nil];
        [_leftViewController.view removeFromSuperview];
        [_leftViewController removeFromParentViewController];
    }
    _leftViewController = leftViewController;

    if (leftViewController == nil) {
        [self.rootViewController.view removeGestureRecognizer:self.leftEdgePanGesture];
        return;
    }
    self.leftControllerDirty = YES;
    //install gesture
    [self.rootViewController.view addGestureRecognizer:self.leftEdgePanGesture];
}

- (UIScreenEdgePanGestureRecognizer *)leftEdgePanGesture {
    if (_leftEdgePanGesture == nil) {
        _leftEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgePan:)];
        _leftEdgePanGesture.edges = UIRectEdgeLeft;
    }
    return _leftEdgePanGesture;
}

- (UIScreenEdgePanGestureRecognizer *)rightEdgePanGesture {
    if (_rightEdgePanGesture == nil) {
        _rightEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightEdgePan:)];
        _rightEdgePanGesture.edges = UIRectEdgeRight;
    }
    return _rightEdgePanGesture;
}

- (void)handleLeftEdgePan:(UIScreenEdgePanGestureRecognizer *)edgePanGesture {
    [self __initLeftViewControllerIfNeed];

    CGPoint offset = [edgePanGesture translationInView:self.rootViewController.view];
    if (edgePanGesture.state == UIGestureRecognizerStateChanged) {
        self.leftViewController.view.x = offset.x - self.leftViewController.view.width;
    } else if (edgePanGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [edgePanGesture velocityInView:self.rootViewController.view];
        if (velocity.x < 0) {
            [self __animateHideLeftViewController];
            return;
        }

        if (fabs(offset.x) >= self.rootViewController.view.width / 2) {
            [self __animateShowLeftViewController];
        } else {
            [self __animateHideLeftViewController];
        }
    } else {
        [self __animateHideLeftViewController];
    }
}

- (void)handleRightEdgePan:(UIScreenEdgePanGestureRecognizer *)edgePanGesture {
    CGPoint offset = [edgePanGesture translationInView:self.rootViewController.view];
    if (edgePanGesture.state == UIGestureRecognizerStateChanged) {
        self.leftViewController.view.x = offset.x;
    } else if (edgePanGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [edgePanGesture velocityInView:self.rootViewController.view];
        if (velocity.x > 0) {
            [self __animateShowLeftViewController];
            return;
        }

        if (fabs(offset.x) < self.rootViewController.view.width / 2) {
            [self __animateShowLeftViewController];
        } else {
            [self __animateHideLeftViewController];
        }
    }
}

- (void)showLeftViewController {
    if (self.leftViewController == nil) {
        return;
    }

    [self __initLeftViewControllerIfNeed];
    [self __animateShowLeftViewController];
}

- (void)__initLeftViewControllerIfNeed {
    if (self.leftControllerDirty == NO) {
        return;
    }

    if (self.leftViewController == nil) {
        return;
    }

    [self addChildViewController:self.leftViewController];
    self.leftViewController.view.frame = CGRectMake(0, 0, self.rootViewController.view.width, self.rootViewController.view.height);
    self.leftViewController.view.right = self.rootViewController.view.left;
    [self.view addSubview:self.leftViewController.view];
    [self.leftViewController didMoveToParentViewController:self];

    self.leftControllerDirty = NO;
}

- (void)__animateShowLeftViewController {
    CGFloat duration = kAnimateDuration * (-self.leftViewController.view.x / self.leftViewController.view.width);

    [UIView animateWithDuration:duration
    animations:^{
        self.leftViewController.view.x = 0;
    }
    completion:^(BOOL finished) {
        [self.leftViewController.view addGestureRecognizer:self.rightEdgePanGesture];
    }];
}

- (void)__animateHideLeftViewController {
    CGFloat duration = kAnimateDuration * (self.leftViewController.view.x / self.leftViewController.view.width + 1);

    [UIView animateWithDuration:duration
    animations:^{
        self.leftViewController.view.right = 0;
    }
    completion:^(BOOL finished) {
        [self.leftViewController.view removeGestureRecognizer:self.rightEdgePanGesture];
    }];
}
@end
