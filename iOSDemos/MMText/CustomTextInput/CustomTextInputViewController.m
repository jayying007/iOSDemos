//
//  CustomTextInputViewController.m
//  iOSDemos
//
//  Created by janezhuang on 2023/12/3.
//

#import "CustomTextInputViewController.h"
#import "EditableCoreTextView.h"

@interface CustomTextInputViewController ()

@property (nonatomic) EditableCoreTextView *textView;

@end

@implementation CustomTextInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView = [[EditableCoreTextView alloc] initWithFrame:CGRectMake(60, 120, 200, 200)];
    self.textView.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:self.textView];
}

@end
