//
//  ViewController.m
//  Album_StyleA
//
//  Created by janezhuang on 2022/5/19.
//

#import "AlbumViewController.h"
#import "ImgFullScreenViewController.h"
#import "FullScreenTransitioning.h"
#import "TransitionController.h"
#import "MMUINavigationController.h"

@interface AlbumViewController () <MMUINavigationControllerDelegate, FullScreenTransitioning>
@property (nonatomic) NSArray *imageNames;

@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic) TransitionController *transitionController;

@end

@implementation AlbumViewController

static NSString *const reuseIdentifier = @"Cell";

- (void)setType:(uint32_t)type {
    if (type == 1) {
        self.imageNames = @[ @"other2", @"other3" ];
    } else if (type == 2) {
        self.imageNames = @[ @"s_2", @"s_3", @"s_4", @"s_5", @"s_7", @"s_8", @"s_9", @"s_11", @"s_13" ];
    } else if (type == 3) {
        self.imageNames = @[ @"x_1", @"x_3", @"x_6", @"x_7", @"x_9", @"x_10", @"x_12" ];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.alwaysBounceVertical = YES;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    UIImage *image = [UIImage imageNamed:self.imageNames[indexPath.item]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = cell.bounds;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:imageView];
    //    cell.contentView.layer.borderWidth = 2;
    //    cell.contentView.layer.borderColor = UIColor.lightGrayColor.CGColor;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;

    ImgFullScreenViewController *vc = [[ImgFullScreenViewController alloc] initWithImage:self.imageNames[indexPath.row]];
    vc.indexPath = indexPath;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(32, 24, 0, 24);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 2) {
        return CGSizeMake(160, 160);
    }
    if (indexPath.item == 3) {
        return CGSizeMake(160, 160);
    }
    return CGSizeMake(80, 80);
}

#pragma mark - MMUINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)mmNavigationController:(UINavigationController *)navigationController
                                    animationControllerForOperation:(UINavigationControllerOperation)operation
                                                 fromViewController:(UIViewController *)fromVC
                                                   toViewController:(UIViewController *)toVC {
    if (_transitionController == nil) {
        _transitionController = [[TransitionController alloc] initWithNavController:navigationController];
        _transitionController.fromVC = self;
    }
    _transitionController.operation = operation;

    return _transitionController;
}

- (id<UIViewControllerInteractiveTransitioning>)mmNavigationController:(UINavigationController *)navigationController
                           interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return _transitionController;
}

#pragma mark - FullScreenTransitioning

- (NSArray<FullScreenTransitionItem *> *)itemsForTransition:(id<UIViewControllerContextTransitioning>)context {
    UICollectionViewCell *cell = [self collectionView:self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];

    FullScreenTransitionItem *item = [[FullScreenTransitionItem alloc] init];
    item.indexPath = self.selectedIndexPath;
    item.image = [UIImage imageNamed:self.imageNames[self.selectedIndexPath.row]];

    item.initialFrame = [cell convertRect:cell.bounds toView:self.collectionView.window];
    item.initialFrame = CGRectMake(item.initialFrame.origin.x,
                                   item.initialFrame.origin.y + self.collectionView.adjustedContentInset.top,
                                   item.initialFrame.size.width,
                                   item.initialFrame.size.height);

    return @[ item ];
}

- (CGRect)targetFrameForItem:(FullScreenTransitionItem *)item {
    UICollectionViewCell *cell = [self collectionView:self.collectionView cellForItemAtIndexPath:item.indexPath];
    CGRect rect = [cell convertRect:cell.bounds toView:self.collectionView.window];

    return (CGRect){ .size = rect.size,
                     .origin = {
                     .x = rect.origin.x,
                     .y = rect.origin.y - self.collectionView.contentOffset.y //为啥需要加这个偏移量？而且和上面的还不一样
                     } };
}

@end
