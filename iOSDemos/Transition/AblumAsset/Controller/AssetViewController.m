//
//  ViewController.m
//  Album_StyleC
//
//  Created by janezhuang on 2022/11/14.
//

#import "AssetViewController.h"
#import "GridImageView.h"
#import "AssetAlbumViewController.h"
#import "AssetAnimationController.h"

@interface AssetViewController () <AssetTransitioning>
@property (nonatomic) NSArray *images;
@property (nonatomic) GridImageView *imageView;
@end

@implementation AssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    // Do any additional setup after loading the view.
    self.images = @[
        [UIImage imageNamed:@"1"],
        [UIImage imageNamed:@"2"],
        [UIImage imageNamed:@"3"],
        [UIImage imageNamed:@"4"],
        [UIImage imageNamed:@"5"],
        [UIImage imageNamed:@"6"],
        [UIImage imageNamed:@"7"],
        [UIImage imageNamed:@"8"],
        [UIImage imageNamed:@"9"],
        [UIImage imageNamed:@"10"],
        [UIImage imageNamed:@"11"]
    ];

    self.imageView = [[GridImageView alloc] initWithImages:self.images];
    self.imageView.frame = CGRectMake(200, 480, 120, 120);
    self.imageView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [self.imageView addGestureRecognizer:tapGesture];
}

- (void)clickImage {
    AssetAlbumViewController *viewController = [[AssetAlbumViewController alloc] init];
    viewController.modalPresentationStyle = UIModalPresentationCustom;
    static AssetAnimationController *transition;
    transition = [[AssetAnimationController alloc] init];
    viewController.transitioningDelegate = transition;
    [self presentViewController:viewController animated:YES completion:nil];
}
#pragma mark - AssetTransitioning
- (NSArray<AssetTransitionItem *> *)itemsForAssetTransition:(id<UIViewControllerContextTransitioning>)context {
    NSMutableArray *transitionItems = [NSMutableArray array];
    NSArray *imagesRect = [self.imageView getImagesRect];
    for (int i = 0; i < 9 && i < self.images.count; i++) {
        AssetTransitionItem *item = [[AssetTransitionItem alloc] init];
        item.indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        item.originView = self.imageView;
        CGRect rect = [self.imageView convertRect:[imagesRect[i] CGRectValue] toView:self.view];
        item.initialFrame = rect;
        [transitionItems addObject:item];
    }
    return transitionItems;
}
@end
