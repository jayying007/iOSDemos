//
//  UIToolbarViewController.m
//  iOSDemos
//
//  Created by janezhuang on 2023/11/30.
//

#import "UIToolbarViewController.h"
#import "DemoHeaderViews.h"

@interface UIToolbarViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic) UISegmentedControl *headerControl;

@property (nonatomic) UITableView *tableView;

@property (nonatomic) UIImageView *imageView;

@end

@implementation UIToolbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Toolbar";

    [self customConfig];

    _headerControl = [[UISegmentedControl alloc] initWithItems:@[ @"None", @"Label", @"Search" ]];
    _headerControl.origin = CGPointMake(80, 256);
    _headerControl.selectedSegmentIndex = 0;
    [_headerControl addTarget:self action:@selector(changeContainerTitleType:) forControlEvents:UIControlEventValueChanged];
    [self.view insertSubview:_headerControl belowSubview:self.containerView];

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = CLR_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.containerView addSubview:_tableView];

    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.image = [UIImage imageNamed:@"Hey"];
    _imageView.contentMode = SCREEN_PORTRAIT ? UIViewContentModeScaleAspectFill : UIViewContentModeScaleAspectFit;
    [self.bottomView addSubview:_imageView];
}

- (void)customConfig {
    // This parameter for changing the rounding corner radius of the Container
    self.containerCornerRadius = 15;

    // This parameter to add a blur to the background of the Container
    self.containerStyle = ContainerStyleLight;

    // This parameter adds 3 position (move to the middle). Default there are 2 positions
    self.containerAllowMiddlePosition = YES;

    // This parameter allows you to zoom in on the screen under Container
    self.containerZoom = YES;

    // This parameter sets the shadow under Container
    self.containerShadowView = YES;

    // This parameter sets the shadow in Container
    self.containerShadow = YES;

    // This parameter indicates whether to add a button when the container is at the bottom to move the container to the top
    self.containerBottomButtonToMoveTop = YES;

    self.delegate = self;
}

- (void)changeContainerTitleType:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.headerView = nil;
            break;
        case 1: {
            HeaderLabel *label = [DemoHeaderViews createHeaderLabel];
            [DemoHeaderViews changeColorsHeaderView:label forStyle:self.containerStyle];
            self.headerView = label;
        } break;
        case 2: {
            HeaderSearch *search = [DemoHeaderViews createHeaderSearch];
            search.searchBar.delegate = self;
            [DemoHeaderViews changeColorsHeaderView:search forStyle:self.containerStyle];
            self.headerView = search;
        } break;
        default:
            break;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if (self.containerPosition != ContainerMoveTypeTop)
        [self containerMove:ContainerMoveTypeTop];
    GCD_ASYNC_GLOBAL_BEGIN(0) {
        GCD_ASYNC_MAIN_BEGIN { [searchBar becomeFirstResponder]; });
    });
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TableCell"];
        cell.backgroundColor = CLR_COLOR;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);

    cell.textLabel.text = (indexPath.row) ? (indexPath.row == 1) ? @"mapView" : SFMT(@"photo %d", (int)indexPath.row) : @"settings";
    cell.detailTextLabel.text = @"Subtitle";
    cell.textLabel.textColor = (self.containerStyle == ContainerStyleDark) ? WHITE_COLOR : BLACK_COLOR;

    return cell;
}

@end
