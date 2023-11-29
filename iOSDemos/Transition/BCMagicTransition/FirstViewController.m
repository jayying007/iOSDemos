//
//  FirstViewController.m
//  MagicTransition
//
//  Created by Boyce on 10/31/14.
//  Copyright (c) 2014 Boyce. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "UIView+Frame.h"

@interface FirstViewController ()

@property (nonatomic) UILabel *label1;
@property (nonatomic) UIImageView *imageView1;
@property (nonatomic) UIImageView *imageView2;

@property (nonatomic) UIButton *pushButton;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"First VC";
    // Do any additional setup after loading the view from its nib.
    _label1 = [[UILabel alloc] init];
    _label1.text = @"Test Magic Move";
    _label1.font = [UIFont systemFontOfSize:17];
    _label1.textColor = UIColor.blackColor;
    _label1.origin = CGPointMake(32, 128);
    [_label1 sizeToFit];
    [self.view addSubview:_label1];
    
    _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(32, _label1.bottom + 32, 80, 80)];
    _imageView1.image = [UIImage imageNamed:@"1"];
    [self.view addSubview:_imageView1];
    
    _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(32, _imageView1.bottom + 32, 80, 80)];
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
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    // preload views to the memory
    [secondVC loadViewIfNeeded];
    
    [self pushViewController:secondVC
                   fromViews:@[self.imageView1, self.imageView2, self.label1]
                     toViews:@[secondVC.imageView1, secondVC.imageView2, secondVC.label1]
                    duration:0.5];
}

@end
