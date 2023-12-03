//
//  DrawerViewController.m
//  iOSDemos
//
//  Created by janezhuang on 2023/12/3.
//

#import "DrawerViewController.h"
#import "UIDrawerController.h"

@interface DrawerViewController ()

@end

@implementation DrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"首页";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"square.and.arrow.up"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(showListViewController)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(dismiss)];

    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 300)];
    textView.text = @"你说把爱渐渐放下会走更远，又何必去改变已错过的时间";
    textView.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:textView];
}

- (void)showListViewController {
    [self.drawerController showLeftViewController];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
