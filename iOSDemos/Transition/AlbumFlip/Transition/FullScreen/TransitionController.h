//
//  TransitionController.h
//  Album_StyleB
//
//  Created by janezhuang on 2022/5/22.
//

#import <UIKit/UIKit.h>
#import "MMUIViewControllerTransitioning.h"

@interface TransitionController
: NSObject <UINavigationControllerDelegate, MMUIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>
- (instancetype)initWithNavController:(UINavigationController *)navController;

@property (nonatomic) UINavigationControllerOperation operation;

@end
