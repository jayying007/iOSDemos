//
//  HealthViewController.m
//  iOSDemos
//
//  Created by janezhuang on 2023/12/2.
//

#import "HealthViewController.h"
#import "StepCountViewController.h"
#import "ActivitySummaryViewController.h"
#import "CustomRingViewController.h"

@interface HealthViewController ()
@property (nonatomic) UIButton *stepCountBtn;
@property (nonatomic) UIButton *activitySummaryBtn;
@property (nonatomic) UIButton *customRingBtn;
@end

@implementation HealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.stepCountBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 120, 60)];
    self.stepCountBtn.backgroundColor = UIColor.lightGrayColor;
    [self.stepCountBtn setTitle:@"步数" forState:UIControlStateNormal];
    [self.stepCountBtn addTarget:self action:@selector(jumpToStepCount) forControlEvents:UIControlEventTouchUpInside];

    self.activitySummaryBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 350, 120, 60)];
    self.activitySummaryBtn.backgroundColor = UIColor.lightGrayColor;
    [self.activitySummaryBtn setTitle:@"运动环" forState:UIControlStateNormal];
    [self.activitySummaryBtn addTarget:self action:@selector(jumpToActivitySummary) forControlEvents:UIControlEventTouchUpInside];

    self.customRingBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 450, 120, 60)];
    self.customRingBtn.backgroundColor = UIColor.lightGrayColor;
    [self.customRingBtn setTitle:@"自定义环" forState:UIControlStateNormal];
    [self.customRingBtn addTarget:self action:@selector(jumpToCustomRing) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.stepCountBtn];
    [self.view addSubview:self.activitySummaryBtn];
    [self.view addSubview:self.customRingBtn];
}

- (void)jumpToStepCount {
    StepCountViewController *vc = [[StepCountViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)jumpToActivitySummary {
    ActivitySummaryViewController *vc = [[ActivitySummaryViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)jumpToCustomRing {
    CustomRingViewController *vc = [[CustomRingViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
