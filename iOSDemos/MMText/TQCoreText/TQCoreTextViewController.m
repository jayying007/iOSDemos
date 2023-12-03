//
//  TQCoreTextViewController.m
//  iOSDemos
//
//  Created by janezhuang on 2023/12/3.
//

#import "TQCoreTextViewController.h"
#import "CTDisplayView.h"
#import "CTFrameParserConfig.h"
#import "CTFrameParser.h"

@interface TQCoreTextViewController ()

@property (nonatomic) CTDisplayView *displayView;

@end

@implementation TQCoreTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.displayView = [[CTDisplayView alloc] initWithFrame:CGRectMake(40, 160, 320, 320)];
    self.displayView.backgroundColor = UIColor.whiteColor;
    self.displayView.layer.borderWidth = 1;
    [self.view addSubview:self.displayView];

    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.textColor = [UIColor systemGrayColor];
    config.width = self.displayView.width;

    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"json"];
    CoreTextData *data = [CTFrameParser parseTemplateFile:path config:config];
    self.displayView.data = data;
    self.displayView.height = data.height;
}

@end
