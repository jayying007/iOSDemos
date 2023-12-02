//
//  AssetTransitioning.h
//  Album_StyleB
//
//  Created by janezhuang on 2022/5/22.
//

#import <UIKit/UIKit.h>
#import "FullScreenTransitionItem.h"

@protocol FullScreenTransitioning <NSObject>
- (NSArray<FullScreenTransitionItem *> *)itemsForTransition:(id<UIViewControllerContextTransitioning>)context;
- (CGRect)targetFrameForItem:(FullScreenTransitionItem *)item;
@end
