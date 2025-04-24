//
//  SettingViewController.m
//  Audio
//
//  Created by janezhuang on 2022/10/7.
//

#import "SettingViewController.h"
#import "AudioManager.h"

@interface SettingCellViewModel : NSObject
@property (nonatomic) NSString *title;
@property (nonatomic) NSArray *selectArray;
@property (nonatomic) NSString *tips;
@end

@implementation SettingCellViewModel
@end

@interface SettingViewController ()
@property (nonatomic) NSMutableArray<SettingCellViewModel *> *cellInfos;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cellInfos = [NSMutableArray array];
    SettingCellViewModel *viewModel = [[SettingCellViewModel alloc] init];
    viewModel.title = @"选择Player";
    viewModel.selectArray = @[ @"AudioPlayer", @"SystemAudioPlayer", @"AudioQueuePlayer", @"AudioUnitPlayer" ];
    [self.cellInfos addObject:viewModel];

    viewModel = [[SettingCellViewModel alloc] init];
    viewModel.title = @"选择Decoder";
    viewModel.selectArray = @[ @"AudioFileDecoder", @"AudioStreamDecoder" ];
    viewModel.tips = @"Player为AudioQueue、AudioUnit时有效";
    [self.cellInfos addObject:viewModel];

    viewModel = [[SettingCellViewModel alloc] init];
    viewModel.title = @"选择Recorder";
    viewModel.selectArray = @[ @"AudioRecorder", @"AudioQueueRecorder", @"AudioUnitRecorder" ];
    [self.cellInfos addObject:viewModel];

    viewModel = [[SettingCellViewModel alloc] init];
    viewModel.title = @"选择Encoder";
    viewModel.selectArray = @[ @"mp3", @"wav", @"aac" ];
    viewModel.tips = @"录音时为PCM，只是输出文件时做了转换";
    [self.cellInfos addObject:viewModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [@"text" sizeWithAttributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:16] }].height + 16;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    label.text = self.cellInfos[section].title;
    label.font = [UIFont boldSystemFontOfSize:16];
    [label sizeToFit];

    [view addSubview:label];
    view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    view.frame = CGRectMake(0, 0, self.tableView.width, label.height + 16);
    label.origin = CGPointMake(16, 8);
    return view;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return self.cellInfos[section].tips;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellInfos[section].selectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    SettingCellViewModel *viewModel = self.cellInfos[indexPath.section];
    cell.textLabel.text = viewModel.selectArray[indexPath.row];
    cell.textLabel.textColor = UIColor.blackColor;

    if (indexPath.section == 0) {
        if ([cell.textLabel.text isEqualToString:[[AudioManager manager] currentPlayerName]]) {
            cell.textLabel.textColor = UIColor.redColor;
        }
    } else if (indexPath.section == 1) {
        if ([cell.textLabel.text isEqualToString:[[AudioManager manager] currentDecoderName]]) {
            cell.textLabel.textColor = UIColor.redColor;
        }
    } else if (indexPath.section == 2) {
        if ([cell.textLabel.text isEqualToString:[[AudioManager manager] currentRecorderName]]) {
            cell.textLabel.textColor = UIColor.redColor;
        }
    } else if (indexPath.section == 3) {
        if ([cell.textLabel.text isEqualToString:[[AudioManager manager] currentEncoderName]]) {
            cell.textLabel.textColor = UIColor.redColor;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingCellViewModel *viewModel = self.cellInfos[indexPath.section];
    if (indexPath.section == 0) {
        NSString *playerName = viewModel.selectArray[indexPath.row];
        [[AudioManager manager] setCurrentPlayerName:playerName];
    } else if (indexPath.section == 1) {
        NSString *decoderName = viewModel.selectArray[indexPath.row];
        [[AudioManager manager] setCurrentDecoderName:decoderName];
    } else if (indexPath.section == 2) {
        NSString *recorderName = viewModel.selectArray[indexPath.row];
        [[AudioManager manager] setCurrentRecorderName:recorderName];
    } else if (indexPath.section == 3) {
        NSString *encoderName = viewModel.selectArray[indexPath.row];
        [[AudioManager manager] setCurrentEncoderName:encoderName];
    }

    [tableView reloadData];
}
@end
