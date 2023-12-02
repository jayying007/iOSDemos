//
//  FloatButton.m
//  FloatWindow
//
//  Created by janezhuang on 2022/5/21.
//

#import "FloatButton.h"

@interface FloatButton () {
    CGFloat originX;
    CGFloat originY;
}
@end

@implementation FloatButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 16;
        self.layer.masksToBounds = YES;
        self.backgroundColor = UIColor.lightGrayColor;

        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"square.and.arrow.up"]];
        imageView.frame = CGRectMake(16, 16, 32, 32);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];

        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapGesture];

        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture {
    if ([self.delegate respondsToSelector:@selector(handleTapFloatButton)]) {
        [self.delegate handleTapFloatButton];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [panGesture translationInView:self];

    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            originX = self.x;
            originY = self.y;
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat x = originX + translation.x;
            CGFloat y = originY + translation.y;
            x = MIN(MAX(8, x), self.superview.width - self.width - 8);
            y = MIN(MAX(8, y), self.superview.height - self.height - 8);
            self.origin = CGPointMake(x, y);
            break;
        }
        default:
            //松开时自动吸到左边或者右边，可忽略
            break;
    }
}
@end
