//
//  ViewController.m
//  FloatWindow
//
//  Created by janezhuang on 2022/5/21.
//

#import "FloatViewController.h"
#import "FloatDetailViewController.h"
#import "MMUINavigationController.h"
#import "FloatTransitionMgr.h"

@interface FloatViewController () <UITableViewDelegate, UITableViewDataSource, MMUINavigationControllerDelegate>
@property (nonatomic) NSArray *texts;
@property (nonatomic) UITableView *tableView;
@end

@implementation FloatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"浮窗Demo";
    self.view.backgroundColor = UIColor.whiteColor;

    self.texts = @[
        @"冷咖啡离开了杯垫",
        @"我忍住的情绪在很后面",
        @"拼命想挽回的从前",
        @"在我脸上依旧清晰可见",
        @"最美的不是下雨天",
        @"是曾与你躲过雨的屋檐",
        @"回忆的画面",
        @"在荡着秋千 梦开始不甜",
        @"你说把爱渐渐 放下会走更远",
        @"又何必去改变 已错过的时间",
    ];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.texts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.texts[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FloatDetailViewController *vc = [[FloatDetailViewController alloc] initWithText:self.texts[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MMUINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)mmNavigationController:(UINavigationController *)navigationController
                                    animationControllerForOperation:(UINavigationControllerOperation)operation
                                                 fromViewController:(UIViewController *)fromVC
                                                   toViewController:(UIViewController *)toVC {
    return [(id<UINavigationControllerDelegate>)Service(FloatTransitionMgr) navigationController:navigationController
                                                                 animationControllerForOperation:operation
                                                                              fromViewController:fromVC
                                                                                toViewController:toVC];
}

@end
