//
//  PlayListViewController.m
//  Audio
//
//  Created by janezhuang on 2022/2/14.
//

#import "PlayListViewController.h"
#import "AudioPlayerProtocol.h"
#import "AudioManager.h"

@interface PlayListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *musicList;

@end

@implementation PlayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMusicList];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)loadMusicList {
    NSMutableArray *array = @[].mutableCopy;
    //测试文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *testList = [fileManager contentsOfDirectoryAtPath:[NSBundle mainBundle].bundlePath error:nil];
    for (NSString *fileName in testList) {
        if ([fileName.pathExtension isEqualToString:@"mp3"] || [fileName.pathExtension isEqualToString:@"wav"] ||
            [fileName.pathExtension isEqualToString:@"aac"]) {
            [array addObject:[[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:fileName]];
        }
    }
    //录音文件
    NSArray *documentsArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = documentsArr.firstObject;
    NSString *folderPath = [documentPath stringByAppendingPathComponent:@"Audio"];
    NSArray *audioList = [fileManager contentsOfDirectoryAtPath:folderPath error:nil];
    for (NSString *fileName in audioList) {
        [array addObject:[folderPath stringByAppendingPathComponent:fileName]];
    }
    self.musicList = [array mutableCopy];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [self.musicList[indexPath.row] lastPathComponent];
    cell.textLabel.textColor = UIColor.blackColor;

    NSString *currentPlayPath = [[AudioManager manager] currentPlayPath];
    if ([cell.textLabel.text isEqualToString:[currentPlayPath lastPathComponent]]) {
        cell.textLabel.textColor = UIColor.redColor;
    }

    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSURL *url = [NSURL fileURLWithPath:self.musicList[indexPath.row]];
    Class cls = NSClassFromString([[AudioManager manager] currentPlayerName]);
    id<AudioPlayerProtocol> player = [[cls alloc] initWithURL:url];
    [[AudioManager manager] setCurrentPlayer:player];
    [[AudioManager manager] setCurrentPlayPath:self.musicList[indexPath.row]];

    [self.tableView reloadData];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [player play];
    });
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *filePath = self.musicList[indexPath.row];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];

        [self.musicList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
@end
