//
//  AssetTransitionItem.h
//  Album_StyleC
//
//  Created by janezhuang on 2022/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetTransitionItem : NSObject
@property (nonatomic) UIView *originView;
@property (nonatomic) CGRect initialFrame;
@property (nonatomic) CGRect finalFrame;
@property (nonatomic) NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END
