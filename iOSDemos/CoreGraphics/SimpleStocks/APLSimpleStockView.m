//
//  APLSimpleStockView.m
//  iOSDemos
//
//  Created by janezhuang on 2024/7/13.
//

#import "APLSimpleStockView.h"
#import "APLDailyTradeInfo.h"

@interface APLSimpleStockView () {
    CGGradientRef _backgroundGradient;
    CGGradientRef _blueBlendGradient;
    CGPoint _initialDataPoint;
}
@property (nonatomic) NSNumberFormatter *numberFormatter;

@end

@implementation APLSimpleStockView

/*
 * The instigating method for drawing the graph clips to the rounded rect draws the components.
 */
- (void)drawRect:(CGRect)rect {
    CGRect dataRect = [self closingDataRect];
    CGRect volumeRect = [self volumeDataRect];

    // clip to the rounded rect
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               byRoundingCorners:UIRectCornerAllCorners
                                                     cornerRadii:CGSizeMake(16.0, 16.0)];
    [path addClip];
    [self drawBackgroundGradient];
    [self drawVerticalGridInRect:dataRect volumeGraphHeight:CGRectGetHeight(volumeRect) priceLabelWidth:[self priceLabelWidth]];
    [self drawHorizontalGridInRect:dataRect clip:YES];
    [self drawPatternUnderClosingData:dataRect clip:YES];
    [self drawLinePatternUnderClosingData:dataRect clip:YES];
    [self drawVolumeDataInRect:volumeRect];
    [self drawClosingDataInRect:dataRect];
    [self drawMonthNamesTextUnderDataRect:dataRect volumeGraphHeight:[self volumeGraphHeight]];
    [self drawBeachUnderDataInRect:dataRect];
}

- (NSNumberFormatter *)numberFormatter {
    if (_numberFormatter == nil) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
    }
    return _numberFormatter;
}

#pragma mark - extra

/*
 * call this method after drawVolumeDataInRect: in the drawRect: method
 * and see what exciting drawing results.
 */
- (void)drawBeachUnderDataInRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    UIBezierPath *clipPath = [self bottomClipPathFromDataInRect:rect];
    [clipPath addClip];
    UIImage *image = [UIImage imageNamed:@"Beach.png"];
    [image drawInRect:rect];
}

#pragma mark - Layout Calculations

- (CGFloat)priceLabelWidth {
    // Tweaked till it looked good.
    CGFloat minimum = 32.0;
    CGFloat maximum = 54.0;
    NSNumber *number = [NSNumber numberWithDouble:[self.dataSource graphViewMaxClosingPrice:self]];
    CGSize size = [[self.numberFormatter stringFromNumber:number] sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14] }];
    CGFloat width = minimum;
    if (size.width < maximum && size.width > minimum) {
        width = size.width;
    }
    return width;
}

- (CGFloat)volumeGraphHeight {
    // Tweaked till it looked good, should be doing something a bit more scientific.
    return 37.0;
}

- (CGRect)closingDataRect {
    CGFloat top = 57.0; // => text height + button height
    CGFloat textHeight = 25.0;
    CGFloat bottom = [self bounds].size.height - (textHeight + [self volumeGraphHeight]);

    CGFloat left = 0.0;
    CGFloat right = CGRectGetWidth(self.bounds) - [self priceLabelWidth];

    return CGRectMake(left, top, right, bottom - top);
}

- (CGRect)volumeDataRect {
    CGFloat textHeight = 25.0;
    CGFloat bottom = [self bounds].size.height - (textHeight + [self volumeGraphHeight]);

    CGFloat left = 0.0;
    CGFloat right = CGRectGetWidth(self.bounds) - [self priceLabelWidth];

    return CGRectMake(left, bottom, right, [self volumeGraphHeight]);
}

#pragma mark -
#pragma mark Clipping Paths

/*
 * Creates and returns a path that can be used to clip drawing to the top of the data graph.
 */
- (UIBezierPath *)topClipPathFromDataInRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path appendPath:[self pathFromDataInRect:rect]];
    CGPoint currentPoint = [path currentPoint];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), currentPoint.y)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(rect), _initialDataPoint.y)];
    [path addLineToPoint:CGPointMake(_initialDataPoint.x, _initialDataPoint.y)];
    [path closePath];
    return path;
}

/*
 * Creates and returns a path that can be used to clip drawing to the bottom of the data graph.
 */
- (UIBezierPath *)bottomClipPathFromDataInRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path appendPath:[self pathFromDataInRect:rect]];
    CGPoint currentPoint = [path currentPoint];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), currentPoint.y)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(rect), _initialDataPoint.y)];
    [path addLineToPoint:CGPointMake(_initialDataPoint.x, _initialDataPoint.y)];
    [path closePath];
    return path;
}

/*
 * The path for the closing data, this is used to draw the graph, and as part of the top and bottom clip paths.
 */
- (UIBezierPath *)pathFromDataInRect:(CGRect)rect {
    NSUInteger tradingDays = [self.dataSource graphViewDailyTradeInfoCount:self];
    CGFloat maxClose = [self.dataSource graphViewMaxClosingPrice:self];
    CGFloat minClose = [self.dataSource graphViewMinClosingPrice:self];
    NSArray *dailyTradeInfos = [self.dataSource graphViewDailyTradeInfos:self];

    UIBezierPath *path = [UIBezierPath bezierPath];
    /*
     Even though this lineWidth is odd, we don't do any offset because it will never line up with any pixels, just think geometrically.
    */
    CGFloat lineWidth = 5.0;
    [path setLineWidth:lineWidth];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineCapStyle:kCGLineCapRound];
    // Inset so the path does not ever go beyond the frame of the graph.
    rect = CGRectInset(rect, lineWidth / 2.0, lineWidth);
    CGFloat horizontalSpacing = CGRectGetWidth(rect) / (CGFloat)tradingDays;
    CGFloat verticalScale = CGRectGetHeight(rect) / (maxClose - minClose);
    CGFloat closingPrice = [[[dailyTradeInfos objectAtIndex:0] closingPrice] doubleValue];
    _initialDataPoint = CGPointMake(lineWidth / 2.0, (closingPrice - minClose) * verticalScale);
    [path moveToPoint:_initialDataPoint];

    for (NSUInteger i = 1; i < tradingDays - 1; i++) {
        closingPrice = [[[dailyTradeInfos objectAtIndex:i] closingPrice] doubleValue];
        [path addLineToPoint:CGPointMake((i + 1) * horizontalSpacing, CGRectGetMinY(rect) + (closingPrice - minClose) * verticalScale)];
    }
    closingPrice = [[[dailyTradeInfos lastObject] closingPrice] doubleValue];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect) + (closingPrice - minClose) * verticalScale)];
    return path;
}

#pragma mark - Background Gradient

/*
 * Creates the blue background gradient
 */
- (CGGradientRef)backgroundGradient {
    if (NULL == _backgroundGradient) {
        // Lazily create the gradient, then reuse it.
        CGFloat colors[16] = { 48.0 / 255.0, 61.0 / 255.0, 114.0 / 255.0, 1.0, 33.0 / 255.0, 47.0 / 255.0, 113.0 / 255.0, 1.0,
                               20.0 / 255.0, 33.0 / 255.0, 104.0 / 255.0, 1.0, 20.0 / 255.0, 33.0 / 255.0, 104.0 / 255.0, 1.0 };
        CGFloat colorStops[4] = { 0.0, 0.5, 0.5, 1.0 };
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        _backgroundGradient = CGGradientCreateWithColorComponents(colorSpace, colors, colorStops, 4);
        CGColorSpaceRelease(colorSpace);
    }
    return _backgroundGradient;
}

/*
 Draws the blue background gradient.
 */
- (void)drawBackgroundGradient {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGPoint startPoint = { 0.0, 0.0 };
    CGPoint endPoint = { 0.0, self.bounds.size.height };
    CGContextDrawLinearGradient(ctx, [self backgroundGradient], startPoint, endPoint, 0);
}

#pragma mark - Draw Vertical Grid

/*
 * Draws the vertical grid that sits behind the data
 * makes sure not to step into the space needed by the
 * volume graph and the price labels
 */
- (void)drawVerticalGridInRect:(CGRect)dataRect volumeGraphHeight:(CGFloat)volumeGraphHeight priceLabelWidth:(CGFloat)priceLabelWidth {
    UIColor *gridColor = [UIColor colorWithRed:74.0 / 255.0 green:86.0 / 255.0 blue:126.0 / 266.0 alpha:1.0];
    [gridColor setStroke];

    NSInteger dataCount = [self.dataSource graphViewDailyTradeInfoCount:self];
    NSArray *sortedMonths = [self.dataSource graphViewSortedMonths:self];

    UIBezierPath *gridLinePath = [UIBezierPath bezierPath];
    [gridLinePath moveToPoint:CGPointMake(rint(CGRectGetMinX(dataRect)), CGRectGetMinY(dataRect))];
    [gridLinePath addLineToPoint:CGPointMake(rint(CGRectGetMinX(dataRect)), CGRectGetMaxY(dataRect) + volumeGraphHeight)];
    [gridLinePath setLineWidth:2.0];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    // round to an integer point
    CGFloat tradingDayLineSpacing = rint(CGRectGetWidth(dataRect) / (CGFloat)dataCount);

    for (NSDateComponents *month in sortedMonths) {
        CGFloat linePosition = tradingDayLineSpacing * [self.dataSource graphView:self tradeCountForMonth:month];
        CGContextTranslateCTM(ctx, rint(linePosition), 0.0);
        [gridLinePath stroke];
    }

    CGContextRestoreGState(ctx);
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, rint(CGRectGetMaxX(dataRect)), 0.0);
    [gridLinePath stroke];
    CGContextRestoreGState(ctx);

    UIBezierPath *horizontalLine = [UIBezierPath bezierPath];
    [horizontalLine moveToPoint:CGPointMake(rint(CGRectGetMinX(dataRect)), rint(CGRectGetMaxY(dataRect)))];
    [horizontalLine addLineToPoint:CGPointMake(rint(CGRectGetMaxX(dataRect) + priceLabelWidth), rint(CGRectGetMaxY(dataRect)))];
    [horizontalLine setLineWidth:2.0];
    [horizontalLine stroke];
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0.0, rint(volumeGraphHeight));
    [horizontalLine stroke];
    CGContextRestoreGState(ctx);
}

#pragma mark - Draw Horizontal Grid

/*
 * draws the horizontal lines that make up the grid
 * if shouldClip then it will clip to the data
 * if not then it won't
 * shouldClip is a debugging tool, pass YES most of the time
 */
- (void)drawHorizontalGridInRect:(CGRect)dataRect clip:(BOOL)shouldClip {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (shouldClip) {
        CGContextSaveGState(ctx);
        UIBezierPath *clipPath = [self topClipPathFromDataInRect:dataRect];
        [clipPath addClip];
    }

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:1.0];
    [path moveToPoint:CGPointMake(rint(CGRectGetMinX(dataRect)), rint(CGRectGetMinY(dataRect)) + 0.5)];
    [path addLineToPoint:CGPointMake(rint(CGRectGetMaxX(dataRect)), rint(CGRectGetMinY(dataRect)) + 0.5)];
    CGFloat dashPatern[2] = { 1.0, 1.0 };
    [path setLineDash:dashPatern count:2 phase:0.0];
    UIColor *gridColor = [UIColor colorWithRed:74.0 / 255.0 green:86.0 / 255.0 blue:126.0 / 266.0 alpha:1.0];
    [gridColor setStroke];

    CGContextSaveGState(ctx);
    [path stroke];
    for (int i = 0; i < 5; i++) {
        CGContextTranslateCTM(ctx, 0.0, rint(CGRectGetHeight(dataRect) / 5.0));
        [path stroke];
    }
    CGContextRestoreGState(ctx);
    if (shouldClip) {
        CGContextRestoreGState(ctx);
    }
}

#pragma mark - Pattern Drawing Methods

/*
 * This method creates the blue gradient used behind the 'programmer art' pattern
 */
- (CGGradientRef)blueBlendGradient {
    if (NULL == _blueBlendGradient) {
        CGFloat colors[8] = { 0.0, 80.0 / 255.0, 89.0 / 255.0, 1.0, 0.0, 50.0f / 255.0, 64.0 / 255.0, 1.0 };
        CGFloat locations[2] = { 0.0, 0.90 };
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        _blueBlendGradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, 2);
        CGColorSpaceRelease(colorSpace);
    }
    return _blueBlendGradient;
}

/*
 * This method draws the line used behind the 'programmer art' pattern
 */
- (void)drawLineFromPoint:(CGPoint)start toPoint:(CGPoint)end {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:2.0];
    [path moveToPoint:start];
    [path addLineToPoint:end];
    [path stroke];
}

/*
 * This method draws the blue gradient used behind the 'programmer art' pattern
 */
- (void)drawRadialGradientInSize:(CGSize)size centeredAt:(CGPoint)center {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat startRadius = 0.0;
    CGFloat endRadius = 0.85 * pow(floor(size.width / 2.0) * floor(size.width / 2.0) + floor(size.height / 2.0) * floor(size.height / 2.0), 0.5);
    CGContextDrawRadialGradient(ctx, [self blueBlendGradient], center, startRadius, center, endRadius, kCGGradientDrawsAfterEndLocation);
}

/*
 * This method creates a UIImage from the 'programmer art' pattern
 */
- (UIImage *)patternImageOfSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);

    CGPoint center = CGPointMake(floor(size.width / 2.0), floor(size.height / 2.0));
    [self drawRadialGradientInSize:size centeredAt:center];
    UIColor *lineColor = [UIColor colorWithRed:211.0 / 255.0 green:218.0 / 255.0 blue:182.0 / 255.0 alpha:1.0];
    [lineColor setStroke];

    CGPoint start = CGPointMake(0.0, 0.0);
    CGPoint end = CGPointMake(floor(size.width), floor(size.height));
    [self drawLineFromPoint:start toPoint:end];

    start = CGPointMake(0.0, floor(size.height));
    end = CGPointMake(floor(size.width), 0.0);
    [self drawLineFromPoint:start toPoint:end];

    UIImage *patternImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return patternImage;
}

/*
 * draws the 'programmer art' pattern under the closing data graph
 */
- (void)drawPatternUnderClosingData:(CGRect)rect clip:(BOOL)shouldClip {
    [[UIColor colorWithPatternImage:[self patternImageOfSize:CGSizeMake(32.0, 32.0)]] setFill];
    if (shouldClip) {
        UIBezierPath *path = [self bottomClipPathFromDataInRect:rect];
        [path fill];
    } else {
        UIRectFill(rect);
    }
}

#pragma mark - Draw Line Pattern

/*
 * Draws the line pattern, slowly changing the alpha of the stroke color
 * from 0.8 to 0.2.
 */
- (void)drawLinePatternUnderClosingData:(CGRect)rect clip:(BOOL)shouldClip {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (shouldClip) {
        CGContextSaveGState(ctx);
        UIBezierPath *clipPath = [self bottomClipPathFromDataInRect:rect];
        [clipPath addClip];
    }

    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat lineWidth = 1.0;
    [path setLineWidth:lineWidth];
    // because the line width is odd, offset the horizontal lines by 0.5 points
    [path moveToPoint:CGPointMake(0.0, rint(CGRectGetMinY(rect)) + 0.5)];
    [path addLineToPoint:CGPointMake(rint(CGRectGetMaxX(rect)), rint(CGRectGetMinY(rect)) + 0.5)];
    CGFloat alpha = 0.8;
    UIColor *startColor = [UIColor colorWithWhite:1.0 alpha:alpha];
    [startColor setStroke];
    CGFloat step = 4.0;
    CGFloat stepCount = CGRectGetHeight(rect) / step;
    // alpha starts at 0.8, ends at 0.2
    CGFloat alphaStep = (0.8 - 0.2) / stepCount;
    CGContextSaveGState(ctx);
    CGFloat translation = CGRectGetMinY(rect);
    while (translation < CGRectGetMaxY(rect)) {
        [path stroke];
        CGContextTranslateCTM(ctx, 0.0, lineWidth * step);
        translation += lineWidth * step;
        alpha -= alphaStep;
        startColor = [startColor colorWithAlphaComponent:alpha];
        [startColor setStroke];
    }
    CGContextRestoreGState(ctx);
    if (shouldClip) {
        CGContextRestoreGState(ctx);
    }
}

#pragma mark - Draw Volume Data

/*
 * Draws the vertical lines for the volume data set.
 */
- (void)drawVolumeDataInRect:(CGRect)volumeGraphRect {
    CGFloat maxVolume = [self.dataSource graphViewMaxTradingVolume:self];
    CGFloat minVolume = [self.dataSource graphViewMinTradingVolume:self];
    CGFloat verticalScale = CGRectGetHeight(volumeGraphRect) / (maxVolume - minVolume);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGFloat tradingDayLineSpacing = rint(CGRectGetWidth(volumeGraphRect) / (CGFloat)[self.dataSource graphViewDailyTradeInfoCount:self]);
    CGFloat counter = 0.0;
    CGFloat maxY = CGRectGetMaxY(volumeGraphRect);
    [[UIColor whiteColor] setStroke];

    NSArray *dailyTradeInfos = [self.dataSource graphViewDailyTradeInfos:self];
    for (DailyTradeInfo *dailyTradeInfo in dailyTradeInfos) {
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path setLineWidth:2.0];
        CGFloat tradingVolume = [[dailyTradeInfo tradingVolume] doubleValue];
        [path moveToPoint:CGPointMake(rint(counter * tradingDayLineSpacing), maxY)];
        [path addLineToPoint:CGPointMake(rint(counter * tradingDayLineSpacing), maxY - (tradingVolume - minVolume) * verticalScale)];

        [path stroke];
        counter += 1.0;
    }
    CGContextRestoreGState(ctx);
}

#pragma mark - Draw Closing Data

/*
 * Draws the path for the closing price data set.
 */
- (void)drawClosingDataInRect:(CGRect)rect {
    [[UIColor whiteColor] setStroke];
    UIBezierPath *path = [self pathFromDataInRect:rect];
    [path stroke];
}

#pragma mark - Draw Month Names

/*
 * Draws the month names, reterived from the NSDateFormatter.
 */
- (void)drawMonthNamesTextUnderDataRect:(CGRect)dataRect volumeGraphHeight:(CGFloat)volumeGraphHeight {
    NSInteger dataCount = [self.dataSource graphViewDailyTradeInfoCount:self];
    NSArray *sortedMonths = [self.dataSource graphViewSortedMonths:self];

    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *format = [NSDateFormatter dateFormatFromTemplate:@"MMMM" options:0 locale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:format];

    [[UIColor whiteColor] setFill];
    UIFont *font = [UIFont boldSystemFontOfSize:16.0];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGFloat shadowHeight = 2.0;
    CGContextSetShadowWithColor(ctx, CGSizeMake(1.0, -shadowHeight), 0.0, [[UIColor darkGrayColor] CGColor]);
    CGFloat tradingDayLineSpacing = rint(CGRectGetWidth(dataRect) / (CGFloat)dataCount);
    for (int i = 0; i < ([sortedMonths count] - 1); i++) {
        CGFloat linePosition = tradingDayLineSpacing * [self.dataSource graphView:self tradeCountForMonth:[sortedMonths objectAtIndex:i]];
        CGContextTranslateCTM(ctx, linePosition, 0.0);
        NSDate *date = [calendar dateFromComponents:[sortedMonths objectAtIndex:i + 1]];
        NSString *monthName = [dateFormatter stringFromDate:date];
        CGSize monthSize = [monthName sizeWithAttributes:@{ NSFontAttributeName : font }];
        CGRect monthRect = CGRectMake(0.0, CGRectGetMaxY(dataRect) + volumeGraphHeight + shadowHeight, monthSize.width, monthSize.height);
        [monthName drawInRect:monthRect withAttributes:@{ NSFontAttributeName : font }];
    }
    CGContextRestoreGState(ctx);
}

@end
