//
//  SecViewController.m
//  Mask
//
//  Created by janezhuang on 2022/6/26.
//

#import "MaskSecViewController.h"

@interface MaskSecViewController ()
@property (nonatomic) UIColor *color;
@end

@implementation MaskSecViewController

- (instancetype)initWithColor:(UIColor *)color {
    self = [super init];
    if (self) {
        self.color = color;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    if (self.color == UIColor.redColor) {
        imageView.image = [UIImage imageNamed:@"red"];
    } else if (self.color == UIColor.greenColor) {
        imageView.image = [UIImage imageNamed:@"green"];
    } else if (self.color == UIColor.blueColor) {
        imageView.image = [UIImage imageNamed:@"blue"];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(150, 560, 100, 60);
    button.backgroundColor = UIColor.lightGrayColor;
    button.layer.cornerRadius = 30;
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)click {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
