//
//  ThirdViewController.m
//  Demo
//
//  Created by Boyce on 4/8/15.
//  Copyright (c) 2015 Boyce. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Third VC";
    // Do any additional setup after loading the view from its nib.
    _label1 = [[UILabel alloc] init];
    _label1.text = @"Test Magic Move";
    _label1.font = [UIFont systemFontOfSize:17];
    _label1.textColor = UIColor.blackColor;
    _label1.right = self.view.right - 160;
    _label1.bottom = self.view.bottom - 256;
    [_label1 sizeToFit];
    [self.view addSubview:_label1];

    _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(64, 108, 256, 256)];
    _imageView1.image = [UIImage imageNamed:@"1"];
    [self.view addSubview:_imageView1];

    _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(64, self.view.bottom - 256, 80, 80)];
    _imageView2.image = [UIImage imageNamed:@"2"];
    [self.view addSubview:_imageView2];
}

@end
