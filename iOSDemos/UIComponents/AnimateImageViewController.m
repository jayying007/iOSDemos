//
//  AnimateImageViewController.m
//  iOSDemos
//
//  Created by janezhuang on 2023/12/24.
//

#import "AnimateImageViewController.h"
#import "AnimateImageView.h"

@interface AnimateImageViewController ()

@end

@implementation AnimateImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    let imagePath = [[NSBundle mainBundle] pathForResource:@"1.gif" ofType:nil];

    let imageView = [[AnimateImageView alloc] initWithData:[NSData dataWithContentsOfFile:imagePath]];
    imageView.frame = CGRectMake(0, 180, imageView.image.size.width, imageView.image.size.height);
    [imageView startPlay];
    [self.view addSubview:imageView];
}

@end
