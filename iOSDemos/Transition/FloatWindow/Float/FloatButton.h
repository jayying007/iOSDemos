//
//  FloatButton.h
//  FloatWindow
//
//  Created by janezhuang on 2022/5/21.
//

#import <UIKit/UIKit.h>

@protocol FloatButtonDelegate <NSObject>
- (void)handleTapFloatButton;
@end

@interface FloatButton : UIView
@property (nonatomic) id<FloatButtonDelegate> delegate;
@end
