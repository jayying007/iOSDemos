//
//  ScreenShotSecureView.m
//  DevelopKit
//
//  Created by janezhuang on 2025/4/6.
//

#import "ScreenShotSecureView.h"

@interface ScreenShotSecureView ()

@property (nonatomic) UIView *secureView;

@end

@implementation ScreenShotSecureView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    UITextField *textField = [[UITextField alloc] init];
    textField.secureTextEntry = YES;
    _secureView = textField.subviews.firstObject;
    _secureView.frame = UIScreen.mainScreen.bounds;
    [self addSubview:_secureView];
}

- (void)setContentView:(UIView *)contentView {
    [_contentView removeFromSuperview];
    _contentView = contentView;
    [_secureView addSubview:_contentView];
}

@end
