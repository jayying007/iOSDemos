//
//  ViewController.m
//  iOSDemos
//
//  Created by janezhuang on 2023/11/27.
//

#import "RootViewController.h"
#import "UITableViewInfo.h"
#import "YYViewHierarchy3D.h"
#import "GalleryViewController.h"
#import "DrawerViewController.h"
#import "UIDrawerController.h"
#import "DrawerListViewController.h"
#import "CircleTextViewController.h"
#import "ExcludePathViewController.h"
#import "ColorTextViewController.h"

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UITableViewInfo *tableViewInfo;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"iOS Demos";

    weakify(self);
    _tableViewInfo = [[UITableViewInfo alloc] init];
    [_tableViewInfo addSectionInfo:^(UITableViewSectionInfo *sectionInfo) {
        sectionInfo.title = @"UI组件";
        sectionInfo.addRow.c_title(@"UIStackView").c_className(@"UIStackViewController");
        sectionInfo.addRow.c_title(@"UIToolbar").c_detail(@"可以上下拖动的Toolbar容器").c_className(@"UIToolbarViewController");
        sectionInfo.addRow.c_title(@"UICollectionView").c_handler(^{
            strongify(self);
            CollectionEntryViewController *vc = [[CollectionEntryViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        });
        sectionInfo.addRow.c_title(@"Animate UITableView").c_className(@"AnimateTableViewController");
        sectionInfo.addRow.c_title(@"容器ViewController").c_detail(@"右滑可拉出一个列表").c_handler(^{
            strongify(self);
            DrawerViewController *vc = [[DrawerViewController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
            UIDrawerController *drawerController = [[UIDrawerController alloc] initWithRootViewController:navController];
            drawerController.leftViewController = [[DrawerListViewController alloc] init];

            drawerController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:drawerController animated:YES completion:nil];
        });
        sectionInfo.addRow.c_title(@"动图").c_className(@"AnimateImageViewController");
    }];
    [_tableViewInfo addSectionInfo:^(UITableViewSectionInfo *sectionInfo) {
        sectionInfo.title = @"文本相关";
        sectionInfo.addRow.c_title(@"TQCoreText排版").c_className(@"TQCoreTextViewController");
        sectionInfo.addRow.c_title(@"文本实现遮罩").c_className(@"TextMaskViewController");
        sectionInfo.addRow.c_title(@"文本列布局").c_className(@"ColumnarLayoutViewController");
        sectionInfo.addRow.c_title(@"自己实现UITextView").c_className(@"CustomTextInputViewController");
        sectionInfo.addRow.c_title(@"富文本编辑器").c_detail(@"MMTextView").c_className(@"MMTextViewViewController");
        [sectionInfo addRowInfo:^(UITableViewRowInfo *rowInfo) {
            rowInfo.title = @"TextKit Demo";
            rowInfo.handler = ^{
                strongify(self);
                CircleTextViewController *vc1 = [[CircleTextViewController alloc] init];
                vc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"CircleText" image:[UIImage systemImageNamed:@"link"] tag:0];

                ExcludePathViewController *vc2 = [[ExcludePathViewController alloc] init];
                vc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"ExcludePath" image:[UIImage systemImageNamed:@"link"] tag:0];

                ColorTextViewController *vc3 = [[ColorTextViewController alloc] init];
                vc3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"ColorText" image:[UIImage systemImageNamed:@"link"] tag:0];

                UITabBarController *tabBarController = [[UITabBarController alloc] init];
                [tabBarController setViewControllers:@[ vc1, vc2, vc3 ]];
                [tabBarController setSelectedIndex:0];

                [self.navigationController pushViewController:tabBarController animated:YES];
            };
        }];
        sectionInfo.addRow.c_title(@"文字变换动效").c_className(@"AnimateTextViewController");
        sectionInfo.addRow.c_title(@"🧟‍♂️杂志").c_handler(^{
            strongify(self);
            MagazineViewController *vc = [[MagazineViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        });
    }];
    [_tableViewInfo addSectionInfo:^(UITableViewSectionInfo *sectionInfo) {
        sectionInfo.title = @"Core Graphics";
        [sectionInfo addRowInfo:^(UITableViewRowInfo *rowInfo) {
            rowInfo.title = @"苹果官方QuartzDemo";
            rowInfo.handler = ^{
                strongify(self);
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Quartz" bundle:nil];
                MasterViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Master"];
                [self.navigationController pushViewController:vc animated:YES];
            };
        }];
    }];
    [_tableViewInfo addSectionInfo:^(UITableViewSectionInfo *sectionInfo) {
        sectionInfo.title = @"Core Animation";
        sectionInfo.addRow.c_title(@"Shake Animation").c_detail(@"会震动的密码框").c_className(@"ShakeViewController");
        sectionInfo.addRow.c_title(@"Animated Pen").c_detail(@"神笔马良").c_className(@"AnimatePanViewController");
    }];
    [_tableViewInfo addSectionInfo:^(UITableViewSectionInfo *sectionInfo) {
        sectionInfo.title = @"转场";
        [sectionInfo addRowInfo:^(UITableViewRowInfo *rowInfo) {
            rowInfo.title = @"BCMagicTransition";
            rowInfo.className = @"FirstViewController";
        }];
        [sectionInfo addRowInfo:^(UITableViewRowInfo *rowInfo) {
            rowInfo.title = @"相册翻转";
            rowInfo.handler = ^{
                strongify(self);
                UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
                flowLayout.itemSize = CGSizeMake(150, 150);
                flowLayout.minimumLineSpacing = 40;
                GalleryViewController *vc = [[GalleryViewController alloc] initWithCollectionViewLayout:flowLayout];
                [self.navigationController pushViewController:vc animated:YES];
            };
        }];
        sectionInfo.addRow.c_title(@"相册合集").c_className(@"AssetViewController");
        sectionInfo.addRow.c_title(@"浮窗").c_className(@"FloatViewController");
        sectionInfo.addRow.c_title(@"Mask遮罩").c_className(@"MaskViewController");
    }];
    [_tableViewInfo addSectionInfo:^(UITableViewSectionInfo *sectionInfo) {
        sectionInfo.title = @"前端";
        sectionInfo.addRow.c_title(@"WebView 同层渲染").c_className(@"NativeRenderWebViewController");
    }];
    [_tableViewInfo addSectionInfo:^(UITableViewSectionInfo *sectionInfo) {
        sectionInfo.title = @"其他";
        sectionInfo.addRow.c_title(@"HealthKit").c_className(@"HealthViewController");
        [sectionInfo addRowInfo:^(UITableViewRowInfo *rowInfo) {
            rowInfo.title = @"打开ViewHierarchy3D";
            rowInfo.handler = ^{
                [YYViewHierarchy3D show];
            };
        }];
    }];

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tableViewInfo.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    UITableViewSectionInfo *sectionInfo = _tableViewInfo.sections[section];
    return sectionInfo.title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    UITableViewSectionInfo *sectionInfo = _tableViewInfo.sections[section];
    return sectionInfo.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewSectionInfo *sectionInfo = _tableViewInfo.sections[indexPath.section];
    UITableViewRowInfo *rowInfo = sectionInfo.rows[indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = rowInfo.title;
    cell.detailTextLabel.text = rowInfo.detail;
    cell.detailTextLabel.textColor = UIColor.lightGrayColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewSectionInfo *sectionInfo = _tableViewInfo.sections[indexPath.section];
    UITableViewRowInfo *rowInfo = sectionInfo.rows[indexPath.row];
    if (rowInfo.className.length > 0) {
        UIViewController *vc = [[NSClassFromString(rowInfo.className) alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (rowInfo.handler) {
        rowInfo.handler();
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
