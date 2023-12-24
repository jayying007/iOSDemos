//
//  AnimateImageView.h
//  iOSDemos
//
//  Created by janezhuang on 2023/12/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnimateImageView : UIImageView

- (instancetype)initWithData:(NSData *)data;
- (void)startPlay;
//回到第一帧
- (void)stopPlay;

@end

NS_ASSUME_NONNULL_END
