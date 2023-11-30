//
//  UIStackViewController.m
//  iOSDemos
//
//  Created by janezhuang on 2023/11/29.
//

#import "UIStackViewController.h"

@interface UIStackViewChildView : UIView
@end
@implementation UIStackViewChildView
- (CGSize)intrinsicContentSize {
    return self.bounds.size;
}
@end

@interface UIStackViewController ()
@property (nonatomic) UIStackViewChildView *middleView;
@property (nonatomic) BOOL switchValue;
@end

@implementation UIStackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    [self initView];
}

- (void)initView {
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [self test1];
    [self test2];
}

- (void)test1 {
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:CGRectMake(80, 120, 240, 250)];
    stackView.layer.borderWidth = 1;
    stackView.layer.borderColor = UIColor.redColor.CGColor;
    [self.view addSubview:stackView];

    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 10;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentTrailing;

    [stackView addArrangedSubview:[self viewWithColor:UIColor.greenColor]];
    [stackView addArrangedSubview:[self viewWithColor:UIColor.orangeColor]];
    _middleView = [self viewWithColor:UIColor.redColor];
    // (降低抗拉伸的优先级)空间充足时被拉伸
    [_middleView setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    // (降低抗压缩的优先级)空间不足时被压缩
    [_middleView setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    [stackView addArrangedSubview:_middleView];
    /*
    另一种方式是通过AutoLayout，代替抗压缩
     [stackView addConstraint:[_middleView.heightAnchor constraintGreaterThanOrEqualToConstant:1]];
     */
    [stackView addArrangedSubview:[self viewWithColor:UIColor.blueColor]];
    [stackView addArrangedSubview:[self viewWithColor:UIColor.grayColor]];
}

- (void)test2 {
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:CGRectMake(40, 460, 300, 80)];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.layer.borderWidth = 1;
    stackView.layer.borderColor = UIColor.redColor.CGColor;
    [self.view addSubview:stackView];

    UILabel *titleLabel = [self labelWithText:@"开关"];
    UILabel *subtitleLabel = [self subtitleLabelWithText:@"右侧开关用于修改View的高度，观察红色View的变化"];
    UIStackView *vStack = [[UIStackView alloc] init];
    vStack.axis = UILayoutConstraintAxisVertical;
    [vStack addArrangedSubview:titleLabel];
    [vStack setCustomSpacing:8 afterView:titleLabel];
    [vStack addArrangedSubview:subtitleLabel];
    [stackView addArrangedSubview:vStack];

    UISwitch *oSwitch = [[UISwitch alloc] init];
    oSwitch.on = _switchValue;
    [oSwitch addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventValueChanged];
    [stackView addArrangedSubview:oSwitch];
}

#pragma mark - UIEvent

- (void)onSwitch:(UISwitch *)oSwitch {
    _switchValue = oSwitch.on;
    if (_switchValue) {
        viewHeight = 30;
    } else {
        viewHeight = 50;
    }

    [self initView];
}

#pragma mark - Util

- (UILabel *)labelWithText:(NSString *)text {
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = [UIFont systemFontOfSize:17];
    textLabel.numberOfLines = 0;
    textLabel.text = text;
    return textLabel;
}

- (UILabel *)subtitleLabelWithText:(NSString *)subtitle {
    UILabel *textView = [[UILabel alloc] init];
    textView.font = [UIFont systemFontOfSize:14];
    textView.numberOfLines = 0;
    [textView setTextColor:UIColor.lightGrayColor];
    [textView setText:subtitle];
    return textView;
}

static CGFloat viewHeight = 50;
- (UIStackViewChildView *)viewWithColor:(UIColor *)color {
    UIStackViewChildView *view = [[UIStackViewChildView alloc] initWithFrame:CGRectMake(0, 0, 120 + arc4random_uniform(80), viewHeight)];
    view.backgroundColor = color;
    return view;
}

@end
