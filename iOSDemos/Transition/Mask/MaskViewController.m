//
//  ViewController.m
//  Mask
//
//  Created by janezhuang on 2022/6/26.
//

#import "MaskViewController.h"
#import "MaskSecViewController.h"
#import "MaskAnimationController.h"

@interface MaskViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic) UIButton *redBtn;
@property (nonatomic) UIButton *greenBtn;
@property (nonatomic) UIButton *blueBtn;

@property (nonatomic) MaskAnimationController *animator;
@end

@implementation MaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.redBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.redBtn.frame = CGRectMake(60, 240, 80, 80);
    [self.redBtn setTitle:@"red" forState:UIControlStateNormal];
    [self.redBtn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [self.redBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.redBtn.layer.borderWidth = 1;
    [self.view addSubview:self.redBtn];

    self.greenBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.greenBtn.frame = CGRectMake(160, 240, 80, 80);
    [self.greenBtn setTitle:@"green" forState:UIControlStateNormal];
    [self.greenBtn setTitleColor:UIColor.greenColor forState:UIControlStateNormal];
    [self.greenBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.greenBtn.layer.borderWidth = 1;
    [self.view addSubview:self.greenBtn];

    self.blueBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.blueBtn.frame = CGRectMake(260, 240, 80, 80);
    [self.blueBtn setTitle:@"blue" forState:UIControlStateNormal];
    [self.blueBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [self.blueBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    self.blueBtn.layer.borderWidth = 1;
    [self.view addSubview:self.blueBtn];

    self.animator = [MaskAnimationController new];
}

- (void)click:(UIButton *)button {
    UIColor *color = button.currentTitleColor;
    MaskSecViewController *vc = [[MaskSecViewController alloc] initWithColor:color];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;

    self.animator.originFrame = [button convertRect:button.bounds toView:self.view.window];
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    self.animator.type = MaskTransitionTypePresent;
    return self.animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.animator.type = MaskTransitionTypeDismiss;
    return self.animator;
}
@end
