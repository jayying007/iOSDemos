//
//  ViewController.m
//  Album_StyleA
//
//  Created by janezhuang on 2022/5/19.
//

#import "AlbumViewController.h"

@interface AlbumViewController ()
@property (nonatomic) NSArray *imageNames;

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

@end
