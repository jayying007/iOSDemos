//
//  ViewController.m
//  Animation
//
//  Created by janezhuang on 2023/1/11.
//

#import "ShakeViewController.h"
#import "UIView+Animation.h"

@interface ShakeViewController ()
@property (nonatomic) UITextField *textField;
@end

@implementation ShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    leftView.backgroundColor = UIColor.lightGrayColor;

    _textField = [[UITextField alloc] initWithFrame:CGRectMake(60, 180, 240, 40)];
    _textField.leftView = leftView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.secureTextEntry = YES;
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_textField];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(60, 480, 60, 60)];
    [button setTitle:@"验证" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.systemBlueColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)click {
    [_textField shake];
}
@end
