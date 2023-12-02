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
        [sectionInfo addRowInfo:^(UITableViewRowInfo *rowInfo) {
            rowInfo.title = @"UIStackView";
            rowInfo.className = @"UIStackViewController";
        }];
        [sectionInfo addRowInfo:^(UITableViewRowInfo *rowInfo) {
            rowInfo.title = @"UIToolbar";
            rowInfo.detail = @"可以上下拖动的Toolbar容器";
            rowInfo.className = @"UIToolbarViewController";
        }];
        [sectionInfo addRowInfo:^(UITableViewRowInfo *rowInfo) {
            rowInfo.title = @"UICollectionView";
            rowInfo.handler = ^{
                strongify(self);
                CollectionEntryViewController *vc = [[CollectionEntryViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            };
        }];
        [sectionInfo addRowInfo:^(UITableViewRowInfo *rowInfo) {
            rowInfo.title = @"Animate UITableView";
            rowInfo.className = @"AnimateTableViewController";
        }];
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
        [sectionInfo addRowInfo:^(UITableViewRowInfo *rowInfo) {
            rowInfo.title = @"Shake Animation";
            rowInfo.detail = @"会震动的密码框";
            rowInfo.className = @"ShakeViewController";
        }];
        [sectionInfo addRowInfo:^(UITableViewRowInfo *rowInfo) {
            rowInfo.title = @"Animated Pen";
            rowInfo.detail = @"神笔马良";
            rowInfo.className = @"AnimatePanViewController";
        }];
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
        [sectionInfo addRowInfo:^(UITableViewRowInfo *rowInfo) {
            rowInfo.title = @"相册合集";
            rowInfo.className = @"AssetViewController";
        }];
        [sectionInfo addRowInfo:^(UITableViewRowInfo *rowInfo) {
            rowInfo.title = @"浮窗";
            rowInfo.className = @"FloatViewController";
        }];
    }];
    [_tableViewInfo addSectionInfo:^(UITableViewSectionInfo *sectionInfo) {
        sectionInfo.title = @"前端";
        [sectionInfo addRowInfo:^(UITableViewRowInfo *rowInfo) {
            rowInfo.title = @"WebView 同层渲染";
            rowInfo.className = @"NativeRenderWebViewController";
        }];
    }];
    [_tableViewInfo addSectionInfo:^(UITableViewSectionInfo *sectionInfo) {
        sectionInfo.title = @"其他";
        [sectionInfo addRowInfo:^(UITableViewRowInfo *rowInfo) {
            rowInfo.title = @"HealthKit";
            rowInfo.className = @"HealthViewController";
        }];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
}

@end
