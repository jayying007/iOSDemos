//
//  AudioViewController.m
//  iOSDemos
//
//  Created by janezhuang on 2025/4/24.
//

#import "AudioViewController.h"
#import "AudioManager.h"

@interface CellViewModel : NSObject
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *viewControllerName;
@end

@implementation CellViewModel
@end

@interface AudioViewController ()

@property (nonatomic) NSMutableArray *cellInfos;

@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cellInfos = [NSMutableArray array];
    CellViewModel *viewModel = [[CellViewModel alloc] init];
    viewModel.title = @"播放音频";
    viewModel.viewControllerName = @"PlayerViewController";
    [self.cellInfos addObject:viewModel];

    viewModel = [[CellViewModel alloc] init];
    viewModel.title = @"录制音频";
    viewModel.viewControllerName = @"RecorderViewController";
    [self.cellInfos addObject:viewModel];

    viewModel = [[CellViewModel alloc] init];
    viewModel.title = @"设置";
    viewModel.viewControllerName = @"SettingViewController";
    [self.cellInfos addObject:viewModel];

    [[NSNotificationCenter defaultCenter]
    addObserverForName:AVAudioSessionInterruptionNotification
                object:nil
                 queue:[NSOperationQueue mainQueue]
            usingBlock:^(NSNotification *_Nonnull note) {
                NSDictionary *userInfo = note.userInfo;
                if ([userInfo[AVAudioSessionInterruptionTypeKey] intValue] == AVAudioSessionInterruptionTypeBegan) {
                    NSLog(@"restart after 3 seconds");
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        NSLog(@"restart now");
                        [[AVAudioSession sharedInstance] setActive:YES error:nil];
                        [[AudioManager manager].currentPlayer play];
                    });
                }
            }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    CellViewModel *viewModel = self.cellInfos[indexPath.row];
    cell.textLabel.text = viewModel.title;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CellViewModel *viewModel = self.cellInfos[indexPath.row];
    Class cls = NSClassFromString(viewModel.viewControllerName);

    UIViewController *vc = [[cls alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
