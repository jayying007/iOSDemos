//
//  FloatFan.m
//  FloatWindow
//
//  Created by janezhuang on 2022/5/21.
//

#import "FloatFan.h"

@interface FloatFan ()
@property (nonatomic) BOOL hit;
@property (nonatomic) UIVisualEffectView *effectView;
@end

@implementation FloatFan
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        self.effectView.frame = self.bounds;
        self.effectView.layer.cornerRadius = frame.size.width;
        self.effectView.layer.maskedCorners = kCALayerMinXMinYCorner;
        self.effectView.layer.masksToBounds = YES;
        [self addSubview:self.effectView];

        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.text = @"生成浮窗";
        [titleLabel sizeToFit];
        titleLabel.center = self.effectView.center;
        [self addSubview:titleLabel];

        [[NSNotificationCenter defaultCenter] addObserverForName:kGestureChangeTouchPoint
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *_Nonnull note) {
                                                          NSValue *value = note.userInfo[@"touchPoint"];
                                                          CGPoint touchPoint = [value CGPointValue];
                                                          CGFloat distance =
                                                          sqrt(pow(WINDOW.width - touchPoint.x, 2) + pow(WINDOW.height - touchPoint.y, 2));
                                                          [self updateDistance:distance];
                                                      }];
    }
    return self;
}

- (void)updateDistance:(CGFloat)distance {
    BOOL hit = distance < self.width;
    if (_hit == hit) {
        return;
    }
    _hit = hit;

    if (_hit) {
        UIImpactFeedbackGenerator *impactFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [impactFeedback impactOccurred];

        self.effectView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1);
    } else {
        self.effectView.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }

    if ([self.delegate respondsToSelector:@selector(onFocusChange:)]) {
        [self.delegate onFocusChange:_hit];
    }
}
@end
