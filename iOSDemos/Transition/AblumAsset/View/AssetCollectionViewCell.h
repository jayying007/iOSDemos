//
//  AssetCollectionViewCell.h
//  Album_StyleC
//
//  Created by janezhuang on 2022/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetCollectionViewCell : UICollectionViewCell
@property (nonatomic) BOOL bInSelectMode;
@property (nonatomic) BOOL bSelected;

@property (nonatomic) UIImage *data;

@property (nonatomic, readonly) UIImage *thumbImage;

// private
- (void)initContentView;
- (void)layoutContentView:(CGRect)rect;
@end

NS_ASSUME_NONNULL_END
