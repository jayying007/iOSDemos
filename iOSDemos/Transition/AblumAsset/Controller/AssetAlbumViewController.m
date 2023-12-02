//
//  AlbumViewController.m
//  Album_StyleC
//
//  Created by janezhuang on 2022/11/14.
//

#import "AssetAlbumViewController.h"
#import "UIView+Frame.h"
#import "AssetCollectionViewCell.h"
#import "AssetAnimationController.h"

#define COLUMN_COUNT 3
static NSString *const reuseIdentifier = @"Cell";

@interface AssetAlbumViewController () <UICollectionViewDelegate, UICollectionViewDataSource, AssetTransitioning>
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSArray *images;
// 导航栏
@property (nonatomic) UIView *navigationContainerView;
@property (nonatomic) UIButton *closeButton;

@end

@implementation AssetAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    [self initSubviews];

    self.images = @[
        [UIImage imageNamed:@"1"],  [UIImage imageNamed:@"2"],  [UIImage imageNamed:@"3"],  [UIImage imageNamed:@"4"],  [UIImage imageNamed:@"5"],
        [UIImage imageNamed:@"6"],  [UIImage imageNamed:@"7"],  [UIImage imageNamed:@"8"],  [UIImage imageNamed:@"9"],  [UIImage imageNamed:@"10"],
        [UIImage imageNamed:@"11"], [UIImage imageNamed:@"12"], [UIImage imageNamed:@"13"], [UIImage imageNamed:@"14"], [UIImage imageNamed:@"15"],
        [UIImage imageNamed:@"16"], [UIImage imageNamed:@"17"], [UIImage imageNamed:@"18"], [UIImage imageNamed:@"19"], [UIImage imageNamed:@"20"],
        [UIImage imageNamed:@"21"], [UIImage imageNamed:@"22"], [UIImage imageNamed:@"23"], [UIImage imageNamed:@"24"], [UIImage imageNamed:@"25"],
        [UIImage imageNamed:@"26"]
    ];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    _navigationContainerView.frame = CGRectMake(0, 0, self.view.width, 88);
    _closeButton.origin = CGPointMake(16, 44 + 10);
}

- (void)initSubviews {
    [self initCollectionView];
    [self initNavigationView];
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 4;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize =
    CGSizeMake((self.view.width - 4 * (COLUMN_COUNT - 1)) / COLUMN_COUNT, (self.view.width - 4 * (COLUMN_COUNT - 1)) / COLUMN_COUNT);

    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _collectionView.contentInset = UIEdgeInsetsMake(88, 0, 0, 0);
    [_collectionView registerClass:[AssetCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];

    [self.view addSubview:_collectionView];
}

- (void)initNavigationView {
    _navigationContainerView = [[UIView alloc] init];
    //    _navigationContainerView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    [self.view addSubview:_navigationContainerView];

    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setTitle:@"退出" forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(onExitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton sizeToFit];
    [_navigationContainerView addSubview:_closeButton];
}

- (void)onExitButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    UIImage *image = self.images[indexPath.item];
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    //    imageView.frame = cell.bounds;
    //    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //    [cell.contentView addSubview:imageView];
    [cell setData:image];

    return cell;
}
#pragma mark - AssetTransitioning
- (UICollectionView *)collectionView {
    return _collectionView;
}
@end
