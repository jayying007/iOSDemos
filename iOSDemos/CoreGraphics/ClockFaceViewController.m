//
//  ClockFaceViewController.m
//  iOSDemos
//
//  Created by janezhuang on 2023/12/24.
//

#import "ClockFaceViewController.h"
#import "ClockFace.h"

@interface ClockFaceViewController ()

@end

@implementation ClockFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    let clock = [[ClockFace alloc] initWithFrame:CGRectMake(60, 180, 200, 200)];
    [self.view addSubview:clock];

    [[NSTimer scheduledTimerWithTimeInterval:1
                                     repeats:YES
                                       block:^(NSTimer *_Nonnull timer) {
                                           [clock setTime:NSDate.date];
                                       }] fire];
}

@end
