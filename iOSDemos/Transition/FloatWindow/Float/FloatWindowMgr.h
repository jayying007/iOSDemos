//
//  FloatWindowMgr.h
//  FloatWindow
//
//  Created by janezhuang on 2022/5/21.
//

#import <UIKit/UIKit.h>

@interface FloatWindowMgr : UIView
+ (instancetype)sharedInstance;
/// 浮窗保存的文本
@property (nonatomic) NSString *text;
@end
