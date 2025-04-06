//
//  UITextView+TextKit.h
//  DevelopKit
//
//  Created by janezhuang on 2025/4/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (TextKit)

// 最后一个字符的位置
- (CGPoint)lastCharacterPosition;

- (NSInteger)numberOfLines;

- (NSArray *)linesInfo;

@end

NS_ASSUME_NONNULL_END
