//
//  WebViewController.m
//  FloatWindow
//
//  Created by janezhuang on 2022/5/21.
//

#import "FloatDetailViewController.h"
#import "UIViewController+Minimize.h"

@interface FloatDetailViewController ()
@property (nonatomic) NSString *text;
@end

@implementation FloatDetailViewController
- (instancetype)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        self.text = text;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;

    UILabel *label = [[UILabel alloc] init];
    label.text = self.text;
    label.font = [UIFont systemFontOfSize:24];
    [label sizeToFit];
    label.center = self.view.center;
    [self.view addSubview:label];
    //一行代码接入浮窗
    [self installMinimize:self.text];
}

@end
