//
//  FloatFan.h
//  FloatWindow
//
//  Created by janezhuang on 2022/5/21.
//

#import <UIKit/UIKit.h>

@protocol FloatFanDelegate <NSObject>
/// 焦点变化时回调
/// @param focus 触控点是否在该View上
- (void)onFocusChange:(BOOL)focus;
@end

@interface FloatFan : UIView
@property (nonatomic) id<FloatFanDelegate> delegate;
@end
