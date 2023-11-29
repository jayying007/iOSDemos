//
//  ThirdViewController.h
//  Demo
//
//  Created by Boyce on 4/8/15.
//  Copyright (c) 2015 Boyce. All rights reserved.
//

#import "MMUIViewController.h"
#import "UIViewController+BCMagicTransition.h"

@interface ThirdViewController : MMUIViewController <BCMagicTransitionProtocol>

@property (nonatomic) UILabel *label1;
@property (nonatomic) UIImageView *imageView1;
@property (nonatomic) UIImageView *imageView2;

@end
