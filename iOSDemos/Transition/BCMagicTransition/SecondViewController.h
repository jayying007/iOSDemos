//
//  SecondViewController.h
//  MagicTransition
//
//  Created by Boyce on 10/31/14.
//  Copyright (c) 2014 Boyce. All rights reserved.
//

#import "MMUIViewController.h"
#import "UIViewController+BCMagicTransition.h"

@interface SecondViewController : MMUIViewController <BCMagicTransitionProtocol>

@property (nonatomic) UILabel *label1;
@property (nonatomic) UIImageView *imageView1;
@property (nonatomic) UIImageView *imageView2;

@end
