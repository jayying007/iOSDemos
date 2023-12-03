//
//  MMUIViewControllerTransitioning.h
//  iOSDemos
//
//  Created by janezhuang on 2023/12/3.
//

#import <Foundation/Foundation.h>

@protocol MMUIViewControllerAnimatedTransitioning <UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak) UIViewController *fromVC;

@end
