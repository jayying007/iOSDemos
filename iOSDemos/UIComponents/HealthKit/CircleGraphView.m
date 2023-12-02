//
//  CircleGraphView.m
//  healthkit
//
//  Created by janezhuang on 2021/11/13.
//

#import "CircleGraphView.h"

@interface CircleGraphView ()
@property (nonatomic) CGFloat arcWidth;
@property (nonatomic) UIColor *arcBackgroundColor;
@end

@implementation CircleGraphView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.endArc = 0;
        self.arcWidth = 30;
        self.arcColor = UIColor.yellowColor;
        self.arcBackgroundColor = UIColor.blackColor;
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    const CGFloat fullCircle = 2.0 * M_PI;
    const CGFloat start = -0.25 * fullCircle;
    const CGFloat end = self.endArc * fullCircle + start;

    CGPoint centerPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = 0;
    if (CGRectGetWidth(rect) < CGRectGetHeight(rect)) {
        radius = (CGRectGetWidth(rect) - self.arcWidth) / 2.0;
    } else {
        radius = (CGRectGetHeight(rect) - self.arcWidth) / 2.0;
    }

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGContextSetLineWidth(context, self.arcWidth);
    CGContextSetLineCap(context, kCGLineCapRound);

    //make the circle background
    CGContextSetStrokeColorWithColor(context, self.arcBackgroundColor.CGColor);
    CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, 0, fullCircle, 0);
    CGContextStrokePath(context);

    CGContextSetLineWidth(context, self.arcWidth * 0.9); //使得周围露出黑边
    CGContextSetStrokeColorWithColor(context, self.arcColor.CGColor);
    CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start, end, 0);
    CGContextStrokePath(context);
}
@end
