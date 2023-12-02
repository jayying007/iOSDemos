//
//  TransitionMgr.h
//  FloatWindow
//
//  Created by janezhuang on 2022/5/22.
//

#import <UIKit/UIKit.h>

@interface FloatTransitionMgr : NSObject <UINavigationControllerDelegate>
+ (instancetype)sharedInstance;

- (void)handleEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePanGesture;

@property (nonatomic) BOOL useInteraction;
@end
