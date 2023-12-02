//
//  TransitionMgr.m
//  Album_StyleA
//
//  Created by janezhuang on 2022/5/22.
//

#import "TransitionMgr.h"

@implementation TransitionMgr
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static TransitionMgr *instance;
    dispatch_once(&onceToken, ^{
        instance = [[TransitionMgr alloc] init];
    });
    return instance;
}
@end
