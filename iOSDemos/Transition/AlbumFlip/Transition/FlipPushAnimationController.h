//
//  PushPopAnimationController.h
//  Album_StyleA
//
//  Created by janezhuang on 2022/5/20.
//

#import <UIKit/UIKit.h>

@interface FlipPushAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) UIView *coverView;
@property (nonatomic) CGRect originFrame;

@end
