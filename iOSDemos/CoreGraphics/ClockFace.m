//
//  ClockFace.m
//  iOSDemos
//
//  Created by janezhuang on 2023/12/24.
//

#import "ClockFace.h"

@interface ClockFace ()
@property (nonatomic, strong) CAShapeLayer *hourHand;
@property (nonatomic, strong) CAShapeLayer *minuteHand;
@property (nonatomic, strong) CAShapeLayer *secondHand;
@end

@implementation ClockFace

+ (Class)layerClass {
    return CAShapeLayer.class;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        let layer = (CAShapeLayer *)[self layer];
        layer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
        layer.fillColor = [UIColor whiteColor].CGColor;
        layer.strokeColor = [UIColor blackColor].CGColor;
        layer.lineWidth = 4;

        CGFloat hourLength = self.width / 4;
        CGFloat minuteLength = self.width / 3 + 10;
        CGFloat secondLength = self.width / 2 - 10;

        self.hourHand = [CAShapeLayer layer];
        self.hourHand.path = [UIBezierPath bezierPathWithRect:CGRectMake(-3, -hourLength, 6, hourLength)].CGPath;
        self.hourHand.fillColor = [UIColor yellowColor].CGColor;
        self.hourHand.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        [layer addSublayer:self.hourHand];

        self.minuteHand = [CAShapeLayer layer];
        self.minuteHand.path = [UIBezierPath bezierPathWithRect:CGRectMake(-2, -minuteLength, 4, minuteLength)].CGPath;
        self.minuteHand.fillColor = [UIColor blackColor].CGColor;
        self.minuteHand.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        [layer addSublayer:self.minuteHand];

        self.secondHand = [CAShapeLayer layer];
        self.secondHand.path = [UIBezierPath bezierPathWithRect:CGRectMake(-1, -secondLength, 2, secondLength)].CGPath;
        self.secondHand.fillColor = [UIColor redColor].CGColor;
        self.secondHand.position = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        [layer addSublayer:self.secondHand];
    }
    return self;
}

- (void)setTime:(NSDate *)time {
    _time = time;

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:time];
    self.hourHand.affineTransform = CGAffineTransformMakeRotation(components.hour / 12.0 * 2.0 * M_PI + components.minute / 360.0 * M_PI);
    self.minuteHand.affineTransform = CGAffineTransformMakeRotation(components.minute / 60.0 * 2.0 * M_PI);
    self.secondHand.affineTransform = CGAffineTransformMakeRotation(-components.second / 60.0 * 2.0 * M_PI);
}
@end
