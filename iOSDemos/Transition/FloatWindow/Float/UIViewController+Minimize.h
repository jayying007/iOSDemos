//
//  UIViewController+Minimize.h
//  FloatWindow
//
//  Created by janezhuang on 2022/5/22.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Minimize)
// 实际开发中，一般为MinimizeData数据结构，这里只是演示，所以就用最简单的text
- (void)installMinimize:(NSString *)text;
@end
