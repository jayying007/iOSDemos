//
//  TransitionMgr.h
//  Album_StyleA
//
//  Created by janezhuang on 2022/5/22.
//

#import <UIKit/UIKit.h>

@interface TransitionMgr : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic) UIView *coverView;
@property (nonatomic) CGRect originFrame;
@end
