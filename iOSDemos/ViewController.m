//
//  ViewController.m
//  iOSDemos
//
//  Created by janezhuang on 2023/11/27.
//

#import "ViewController.h"
#import "UITableViewInfo.h"
#import "UIStackViewController.h"
#import "FirstViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UITableViewInfo *tableViewInfo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableViewInfo = [[UITableViewInfo alloc] init];
    [_tableViewInfo addSectionInfo:^(UITableViewSectionInfo *sectionInfo) {
        sectionInfo.title = @"UI组件";
        [sectionInfo addRowInfo:^(UITableViewRowInfo *rowInfo) {
            rowInfo.title = @"UIStackView";
            rowInfo.handler = ^{
                UIStackViewController *vc = [[UIStackViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            };
        }];
    }];
    [_tableViewInfo addSectionInfo:^(UITableViewSectionInfo *sectionInfo) {
        sectionInfo.title = @"转场";
        [sectionInfo addRowInfo:^(UITableViewRowInfo *rowInfo) {
            rowInfo.title = @"BCMagicTransition";
            rowInfo.handler = ^{
                FirstViewController *vc = [FirstViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            };
        }];
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
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
    cell.textLabel.text = rowInfo.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewSectionInfo *sectionInfo = _tableViewInfo.sections[indexPath.section];
    UITableViewRowInfo *rowInfo = sectionInfo.rows[indexPath.row];
    rowInfo.handler();
}

@end
