//
//  WatermarkHelper.h
//  DevelopKit
//
//  Created by janezhuang on 2025/4/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WatermarkHelper : NSObject

+ (UIImage *)genWatermarkImage:(NSString *)text size:(CGSize)size backgroundColor:(UIColor *)backgroundColor;

@end

NS_ASSUME_NONNULL_END
