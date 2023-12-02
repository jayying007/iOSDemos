//
//  PopInteraction.m
//  FloatWindow
//
//  Created by janezhuang on 2022/5/21.
//

#import "PopInteraction.h"

@implementation PopInteraction
- (void)handleEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePanGesture {
    UIView *referenceView = edgePanGesture.view;
    CGPoint velocity = [edgePanGesture velocityInView:referenceView];
    CGPoint transition = [edgePanGesture translationInView:referenceView];
    CGPoint touchPoint = [edgePanGesture locationInView:WINDOW];

    CGFloat percent = transition.x / referenceView.bounds.size.width;

    if (edgePanGesture.state == UIGestureRecognizerStateChanged) {
        [self updateInteractiveTransition:percent];
        [self notifyGestureChangePercent:percent];
        [self notifyGestureChangeTouchPoint:touchPoint];
    } else if (edgePanGesture.state == UIGestureRecognizerStateEnded || edgePanGesture.state == UIGestureRecognizerStateCancelled
               || edgePanGesture.state == UIGestureRecognizerStateFailed) {
        if (percent > 0.5 || velocity.x > 10) {
            [self finishInteractiveTransition];
            [self notifyFinishInteraction];
        } else {
            [self cancelInteractiveTransition];
        }
        [self notifyGestureEnd];
    }
}

- (void)notifyGestureChangePercent:(CGFloat)percent {
    [[NSNotificationCenter defaultCenter] postNotificationName:kGestureChangePercent
                                                        object:nil
                                                      userInfo:@{ @"percent" : [NSNumber numberWithDouble:percent] }];
}

- (void)notifyGestureChangeTouchPoint:(CGPoint)touchPoint {
    [[NSNotificationCenter defaultCenter] postNotificationName:kGestureChangeTouchPoint
                                                        object:nil
                                                      userInfo:@{ @"touchPoint" : [NSValue valueWithCGPoint:touchPoint] }];
}

- (void)notifyFinishInteraction {
    [[NSNotificationCenter defaultCenter] postNotificationName:kFinishInteraction object:nil];
}

- (void)notifyGestureEnd {
    [[NSNotificationCenter defaultCenter] postNotificationName:kGestureEnd object:nil];
}
@end
