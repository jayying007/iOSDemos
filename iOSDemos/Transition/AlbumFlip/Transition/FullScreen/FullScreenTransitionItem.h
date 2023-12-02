//
//  AssetTransitionItem.h
//  Album_StyleB
//
//  Created by janezhuang on 2022/5/22.
//

#import <UIKit/UIKit.h>

@interface FullScreenTransitionItem : NSObject
@property (nonatomic) CGRect initialFrame;
@property (nonatomic) CGRect targetFrame;
@property (nonatomic) UIImage *image;
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) CGPoint touchOffset;
@end
