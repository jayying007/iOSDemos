//
//  MaskAnimationController.h
//  Mask
//
//  Created by janezhuang on 2022/6/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(uint8_t, MaskTransitionType) {
    MaskTransitionTypePresent = 1,
    MaskTransitionTypeDismiss = 2,
};

@interface MaskAnimationController : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic) CGRect originFrame;
@property (nonatomic) MaskTransitionType type;
@end

NS_ASSUME_NONNULL_END
