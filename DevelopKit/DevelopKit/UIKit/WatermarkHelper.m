//
//  WatermarkHelper.m
//  DevelopKit
//
//  Created by janezhuang on 2025/4/6.
//

#import "WatermarkHelper.h"

@implementation WatermarkHelper

+ (NSDictionary *)defaultWatermarkAttribute {
    return @{
        NSFontAttributeName : [UIFont systemFontOfSize:12],
        NSForegroundColorAttributeName : [UIColor colorWithRed:8 * 16 / 255.0 green:8 * 16 / 255.0 blue:8 * 16 / 255.0 alpha:0.06],
        //        NSStrokeWidthAttributeName : @(0.5),
        NSStrokeColorAttributeName : [UIColor colorWithWhite:1 alpha:0.05],
    };
}
// Todo：也可以用pattern实现
+ (UIImage *)genWatermarkImage:(NSString *)text size:(CGSize)size backgroundColor:(UIColor *)backgroundColor {
    NSDictionary *attributes = [self defaultWatermarkAttribute];
    CGSize fontSize = [text sizeWithAttributes:attributes];
    NSAttributedString *attributeText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    /**
     绕着左上角，顺时针旋转了30度
     */
    CGFloat yOffset = 1.0 / 2 * size.width;
    CGFloat wrapRectWidth = sqrt(3) / 2 * size.width + 1.0 / 2 * size.height;
    CGFloat wrapRectHeight = 1.0 / 2 * size.width + sqrt(3) / 2 * size.height;
    CGFloat itemWidth = fontSize.width + 32;
    CGFloat itemHeight = fontSize.height + 32;
    int xNum = wrapRectWidth / itemWidth + 3;
    int yNum = wrapRectHeight / itemHeight + 3;

    CGRect rect = CGRectMake(0, 0, wrapRectWidth, wrapRectHeight);

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);

    [backgroundColor setFill];
    UIBezierPath *bkgPath = [UIBezierPath bezierPathWithRect:rect];
    [bkgPath fill];

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSaveGState(context);
    CGContextRotateCTM(context, M_PI / 6);
    CGContextTranslateCTM(context, 0, -yOffset);
    for (int i = 0; i < yNum; i++) {
        CGContextSaveGState(context);
        for (int j = 0; j < xNum; j++) {
            [attributeText drawAtPoint:CGPointMake(16, 16)];
            CGContextTranslateCTM(context, itemWidth, 0);
        }
        CGContextRestoreGState(context);
        CGContextTranslateCTM(context, 0, itemHeight);
    }
    CGContextRestoreGState(context);

    UIImage *targetImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return targetImage;
}

@end
