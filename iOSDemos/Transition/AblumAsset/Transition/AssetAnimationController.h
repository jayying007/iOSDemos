//
//  AssetAnimationController.h
//  Album_StyleC
//
//  Created by janezhuang on 2022/11/15.
//

#import <UIKit/UIKit.h>
#import "AssetTransitionItem.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AssetTransitioning <NSObject>
@optional
- (NSArray<AssetTransitionItem *> *)itemsForAssetTransition:(id<UIViewControllerContextTransitioning>)context;

- (UICollectionView *)collectionView;
@end

@interface AssetAnimationController : NSObject <UIViewControllerTransitioningDelegate>

@end

NS_ASSUME_NONNULL_END
