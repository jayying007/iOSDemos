//
//  ImgFullScreenViewController.h
//  Album_StyleB
//
//  Created by janezhuang on 2022/5/20.
//

#import <UIKit/UIKit.h>

@interface ImgFullScreenViewController : UIViewController
- (instancetype)initWithImage:(NSString *)imageName;
@property (nonatomic) NSIndexPath *indexPath;
@end
