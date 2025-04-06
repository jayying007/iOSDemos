//
//  UIView+ScreenShot.h
//  DevelopKit
//
//  Created by janezhuang on 2025/4/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ScreenShot)

/// ⚠️⚠️⚠️Note: if will change the view's superview, please ensure the view's layout is right.  if this feature doesn't meet your need, consider using ScreenShotSecureView instead.
/// - Parameter flag: if YES, auto hide the view when take screenShot
- (void)setForbidScreenShot:(BOOL)flag;

@end

NS_ASSUME_NONNULL_END
