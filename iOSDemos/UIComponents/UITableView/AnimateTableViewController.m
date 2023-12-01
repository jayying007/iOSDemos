//
//  AnimateTableViewController.m
//  iOSDemos
//
//  Created by janezhuang on 2023/12/1.
//

#import "AnimateTableViewController.h"
#import "AnimateTableViewCell.h"

#define INFO_CELL @"INFO_CELL"

@interface AnimateTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AnimateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.datasArray = [NSMutableArray array];
    [self.datasArray addObject:[Model ModelWithNormalHeight:50.f expendHeight:100.f expend:NO]];
    [self.datasArray addObject:[Model ModelWithNormalHeight:50.f expendHeight:200.f expend:NO]];
    [self.datasArray addObject:[Model ModelWithNormalHeight:50.f expendHeight:100.f expend:YES]];
    [self.datasArray addObject:[Model ModelWithNormalHeight:50.f expendHeight:100.f expend:NO]];
    [self.datasArray addObject:[Model ModelWithNormalHeight:50.f expendHeight:200.f expend:NO]];
    [self.datasArray addObject:[Model ModelWithNormalHeight:50.f expendHeight:100.f expend:NO]];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AnimateTableViewCell class] forCellReuseIdentifier:INFO_CELL];
    [self.view addSubview:self.tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AnimateTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell buttonEvent];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnimateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:INFO_CELL];
    cell.indexPath = indexPath;
    cell.tableView = tableView;
    [cell loadData:_datasArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Model *model = _datasArray[indexPath.row];
    if (model.expend) {
        return model.expendHeight;
    } else {
        return model.normalHeight;
    }
}

@end
