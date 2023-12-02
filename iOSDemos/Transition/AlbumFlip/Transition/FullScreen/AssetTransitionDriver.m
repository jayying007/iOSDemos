//
//  AssetTransitionDriver.m
//  Album_StyleB
//
//  Created by janezhuang on 2022/5/22.
//

#import "AssetTransitionDriver.h"
#import "AssetTransitioning.h"

#define CGVectorZero CGVectorMake(0, 0)

@interface AssetTransitionDriver ()
@property (nonatomic) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic) UINavigationControllerOperation operation;
@property (nonatomic) UIPanGestureRecognizer *panGesture;
@property (nonatomic) NSArray<FullScreenTransitionItem *> *items;
@property (nonatomic) UIViewPropertyAnimator *itemFrameAnimator;
@end

@implementation AssetTransitionDriver
- (instancetype)initWithOperation:(UINavigationControllerOperation)operation
                          context:(id<UIViewControllerContextTransitioning>)transitionContext
                       panGesture:(UIPanGestureRecognizer *)panGesture {
    self = [super init];
    if (self) {
        self.operation = operation;
        self.transitionContext = transitionContext;
        self.panGesture = panGesture;

        // Setup the transition "chrome"
        UIView *containerView = [transitionContext containerView];
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        id<FullScreenTransitioning> fromAssetTransitioning = nil;
        if ([fromVC conformsToProtocol:@protocol(FullScreenTransitioning)]) {
            fromAssetTransitioning = (id<FullScreenTransitioning>)fromVC;
        }
        id<FullScreenTransitioning> toAssetTransitioning = nil;
        if ([toVC conformsToProtocol:@protocol(FullScreenTransitioning)]) {
            toAssetTransitioning = (id<FullScreenTransitioning>)toVC;
        }
        // Add ourselves as a target of the pan gesture
        [self.panGesture addTarget:self action:@selector(updateInteraction:)];

        if (operation == UINavigationControllerOperationPop) {
        }
        // Ensure the toView has the correct size and position
        toView.frame = [transitionContext finalFrameForViewController:toVC];

        UIVisualEffect *effect = (operation == UINavigationControllerOperationPop) ? [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight] : nil;
        UIVisualEffect *targetEffect =
        (operation == UINavigationControllerOperationPop) ? nil : [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        visualEffectView.frame = containerView.bounds;
        [containerView addSubview:visualEffectView];

        if (operation == UINavigationControllerOperationPush) {
            toView.alpha = 0;
            [containerView addSubview:toView];
        } else {
            fromView.alpha = 0;
            [containerView insertSubview:toView atIndex:0];
        }

        self.items = [fromAssetTransitioning itemsForTransition:transitionContext];
        for (FullScreenTransitionItem *item in self.items) {
            CGRect frame = [toAssetTransitioning targetFrameForItem:item];
            item.targetFrame = [containerView convertRect:frame fromView:toView];

            UIImageView *imageView = [[UIImageView alloc] initWithFrame:[containerView convertRect:item.initialFrame fromView:nil]];
            imageView.image = item.image;
            imageView.backgroundColor = UIColor.whiteColor;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.userInteractionEnabled = YES;
            [containerView addSubview:imageView];
            item.imageView = imageView;
        }

        NSTimeInterval transitionDuration = [AssetTransitionDriver animationDuration];
        self.transitionAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:transitionDuration
                                                                             curve:UIViewAnimationCurveEaseOut
                                                                        animations:^{
                                                                            visualEffectView.effect = targetEffect;
                                                                        }];
        [self.transitionAnimator addCompletion:^(UIViewAnimatingPosition finalPosition) {
            for (FullScreenTransitionItem *item in self.items) {
                [item.imageView removeFromSuperview];
            }
            [visualEffectView removeFromSuperview];
            toView.alpha = 1;
            fromView.alpha = 1;

            BOOL complete = (finalPosition == UIViewAnimatingPositionEnd);
            [self.transitionContext completeTransition:complete];
        }];

        if (transitionContext.isInteractive) {
            // If the transition is initially interactive, ensure we know what item is being manipulated
            [self updateInteractiveItem:[panGesture locationInView:containerView]];
        } else {
            [self animate:UIViewAnimatingPositionEnd];
        }
    }
    return self;
}

- (BOOL)isInteractive {
    return self.transitionContext.isInteractive;
}

- (FullScreenTransitionItem *)itemAtPoint:(CGPoint)point {
    UIView *view = [self.transitionContext.containerView hitTest:point withEvent:nil];
    for (FullScreenTransitionItem *item in self.items) {
        if (item.imageView == view) {
            return item;
        }
    }
    return nil;
}

- (void)updateInteractiveItem:(CGPoint)locationInContainer {
    FullScreenTransitionItem *item = [self itemAtPoint:locationInContainer];
    item.touchOffset = CGPointMake(locationInContainer.x - item.imageView.center.x, locationInContainer.y - item.imageView.center.y);
}

- (CGFloat)progressStep:(CGPoint)translation {
    return (self.operation == UINavigationControllerOperationPush ? -1.0 : 1.0) * translation.y
           / CGRectGetMidY(self.transitionContext.containerView.bounds);
}

- (void)updateInteraction:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [panGesture translationInView:self.transitionContext.containerView];
            CGFloat percentComplete = self.transitionAnimator.fractionComplete + [self progressStep:translation];

            self.transitionAnimator.fractionComplete = percentComplete;
            [self.transitionContext updateInteractiveTransition:percentComplete];

            [self updateItemsForInteractive:translation];

            [panGesture setTranslation:CGPointZero inView:self.transitionContext.containerView];

            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            [self endInteraction];
            break;
        default:
            break;
    }
}

- (void)updateItemsForInteractive:(CGPoint)translation {
    CGFloat progressStep = [self progressStep:translation];

    for (FullScreenTransitionItem *item in self.items) {
        CGSize initialSize = item.initialFrame.size;
        CGSize finalSize = item.targetFrame.size;

        UIImageView *imageView = item.imageView;
        CGSize currentSize = imageView.frame.size;

        CGFloat itemPercentComplete =
        MAX(-0.05, MIN(1.05, (currentSize.width - initialSize.width) / (finalSize.width - initialSize.width) + progressStep));

        CGFloat itemWidth = initialSize.width + (finalSize.width - initialSize.width) * itemPercentComplete;
        CGFloat itemHeight = initialSize.height + (finalSize.height - initialSize.height) * itemPercentComplete;

        CGAffineTransform transform = CGAffineTransformMakeScale(itemWidth / currentSize.width, itemHeight / currentSize.height);
        CGPoint scaledOffset = CGPointApplyAffineTransform(item.touchOffset, transform);

        imageView.center = CGPointMake(imageView.center.x + (translation.x + item.touchOffset.x - scaledOffset.x),
                                       imageView.center.y + (translation.y + item.touchOffset.y - scaledOffset.y));
        imageView.bounds = CGRectMake(0, 0, itemWidth, itemHeight);
        item.touchOffset = scaledOffset;
    }
}

- (UIViewAnimatingPosition)completionPosition {
    CGFloat completionThreshold = 0.33;
    CGFloat flickMagnitude = 1200;
    CGPoint velocity = [self.panGesture velocityInView:self.transitionContext.containerView];
    CGVector velocityVector = CGVectorMake(velocity.x, velocity.y);
    BOOL isFlick = (velocityVector.dx * velocityVector.dx + velocityVector.dy * velocityVector.dy) > flickMagnitude;
    BOOL isFlickDown = isFlick && velocity.y > 0;
    BOOL isFlickUp = isFlick && velocity.y < 0;

    if (self.operation == UINavigationControllerOperationPush) {
        if (isFlickUp)
            return UIViewAnimatingPositionEnd;
        if (isFlickDown)
            return UIViewAnimatingPositionStart;
    } else if (self.operation == UINavigationControllerOperationPop) {
        if (isFlickDown)
            return UIViewAnimatingPositionEnd;
        if (isFlickUp)
            return UIViewAnimatingPositionStart;
    } else if (self.transitionAnimator.fractionComplete > completionThreshold) {
        return UIViewAnimatingPositionEnd;
    } else {
        return UIViewAnimatingPositionStart;
    }
    return UIViewAnimatingPositionStart;
}

- (void)endInteraction {
    if (!self.transitionContext.isInteractive) {
        return;
    }

    UIViewAnimatingPosition position = [self completionPosition];
    if (position == UIViewAnimatingPositionEnd) {
        [self.transitionContext finishInteractiveTransition];
    } else {
        [self.transitionContext cancelInteractiveTransition];
    }
    [self animate:position];
}

- (void)animate:(UIViewAnimatingPosition)position {
    UIViewPropertyAnimator *itemFrameAnimator = [AssetTransitionDriver propertyAnimator:CGVectorZero];
    [itemFrameAnimator addAnimations:^{
        for (FullScreenTransitionItem *item in self.items) {
            item.imageView.frame = (position == UIViewAnimatingPositionEnd) ? item.targetFrame : item.initialFrame;
        }
    }];

    [itemFrameAnimator startAnimation];
    self.itemFrameAnimator = itemFrameAnimator;

    self.transitionAnimator.reversed = (position == UIViewAnimatingPositionStart);
    if (self.transitionAnimator.state == UIViewAnimatingStateInactive) {
        [self.transitionAnimator startAnimation];
    } else {
        CGFloat duration = itemFrameAnimator.duration / self.transitionAnimator.duration;
        [self.transitionAnimator continueAnimationWithTimingParameters:nil durationFactor:duration];
    }
}

- (CGVector)convertVelocity:(CGPoint)velocity forItem:(FullScreenTransitionItem *)item {
    CGRect currentFrame = item.imageView.frame;
    CGRect targetFrame = item.targetFrame;

    CGFloat dx = fabs(CGRectGetMidX(targetFrame) - CGRectGetMidX(currentFrame));
    CGFloat dy = fabs(CGRectGetMidY(targetFrame) - CGRectGetMidY(currentFrame));
    if (dx == 0 || dy == 0) {
        return CGVectorZero;
    }

    CGFloat range = 35;
    CGFloat clippedVx = MAX(-range, MIN(range, velocity.x / dx));
    CGFloat clippedVy = MAX(-range, MIN(range, velocity.y / dy));
    return CGVectorMake(clippedVx, clippedVy);
}

+ (NSTimeInterval)animationDuration {
    return [self propertyAnimator:CGVectorMake(0, 0)].duration;
}

+ (UIViewPropertyAnimator *)propertyAnimator:(CGVector)initialVelocity {
    UISpringTimingParameters *timingParameters = [[UISpringTimingParameters alloc] initWithMass:4.5
                                                                                      stiffness:800
                                                                                        damping:95
                                                                                initialVelocity:initialVelocity];
    return [[UIViewPropertyAnimator alloc] initWithDuration:0.8 timingParameters:timingParameters];
}
@end
