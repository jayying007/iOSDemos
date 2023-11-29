//
//  SecondViewController.m
//  MagicTransition
//
//  Created by Boyce on 10/31/14.
//  Copyright (c) 2014 Boyce. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "UIView+Frame.h"

@interface SecondViewController ()

@property (nonatomic) UIButton *pushButton;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenTransition;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Second VC";
    
    _label1 = [[UILabel alloc] init];
    _label1.text = @"Test Magic Move";
    _label1.font = [UIFont systemFontOfSize:17];
    _label1.textColor = UIColor.blackColor;
    _label1.centerX = self.view.width / 2;
    _label1.y = 128;
    [_label1 sizeToFit];
    [self.view addSubview:_label1];
    
    _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(64, self.view.bottom - 256, 80, 80)];
    _imageView1.image = [UIImage imageNamed:@"1"];
    [self.view addSubview:_imageView1];
    
    _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.right - 144, self.view.bottom - 256, 80, 80)];
    _imageView2.image = [UIImage imageNamed:@"2"];
    [self.view addSubview:_imageView2];
    
    _pushButton = [[UIButton alloc] init];
    _pushButton.centerX = self.view.width / 2;
    _pushButton.bottom = self.view.bottom - 128;
    [_pushButton setTitle:@"Push" forState:UIControlStateNormal];
    [_pushButton setTitleColor:UIColor.linkColor forState:UIControlStateNormal];
    [_pushButton sizeToFit];
    [_pushButton addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pushButton];
}

- (void)push:(id)sender {
    ThirdViewController *thirdVC = [[ThirdViewController alloc] init];
    // preload views to the memory
    [thirdVC loadViewIfNeeded];
    
    // setup fromviews array and toviews array
    NSArray *fromViews = [NSArray arrayWithObjects:self.imageView1, self.imageView2, self.label1, nil];
    NSArray *toViews = [NSArray arrayWithObjects:thirdVC.imageView1, thirdVC.imageView2, thirdVC.label1, nil];
    
    [self pushViewController:thirdVC fromViews:fromViews toViews:toViews duration:1.0];
}

@end
