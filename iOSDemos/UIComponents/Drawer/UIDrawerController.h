//
//  UIDrawerController.h
//  UIDrawerController
//
//  Created by janezhuang on 2022/5/21.
//

#import <UIKit/UIKit.h>

// In this header, you should import all the public headers of your framework using statements like #import <UIDrawerController/PublicHeader.h>
@class UIDrawerController;

@interface UIViewController (UIDrawerController)
// If the view controller has a drawer controller as its ancestor, return it. Returns nil otherwise.
@property (nonatomic, readonly) UIDrawerController *drawerController;
@end

@interface UIDrawerController : UIViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;

@property (nonatomic) UIViewController *leftViewController;
- (void)showLeftViewController;

@end
