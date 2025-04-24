//
//  RecorderViewController.m
//  Audio
//
//  Created by janezhuang on 2022/2/15.
//

#import "RecorderViewController.h"
#import "AudioRecorderProtocol.h"
#import "AudioManager.h"
#import <DevelopKit/AudioUtil.h>

@interface RecorderViewController ()

@property (nonatomic) UILabel *timeLabel;

@property (nonatomic) UIButton *startBtn;
@property (nonatomic) UIButton *stopBtn;

@property (nonatomic) id<AudioRecorderProtocol> recorder;
@property (nonatomic) NSString *tmpPath;

@end

@implementation RecorderViewController

- (void)loadView {
    [super loadView];

    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.width - 200) / 2, 120, 200, 60)];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.timeLabel];

    self.startBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width - 80) / 2, self.view.bottom - 160, 80, 80)];
    [self.startBtn setBackgroundImage:[UIImage imageNamed:@"playImg"] forState:UIControlStateNormal];
    [self.view addSubview:self.startBtn];

    self.stopBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width - 80) / 2, self.view.bottom - 160, 80, 80)];
    [self.stopBtn setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [self.view addSubview:self.stopBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"录制音频";
    self.view.backgroundColor = UIColor.whiteColor;

    [self.startBtn addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchUpInside];
    [self.stopBtn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];

    weakify(self);
    [[NSTimer scheduledTimerWithTimeInterval:0.5
                                     repeats:YES
                                       block:^(NSTimer *_Nonnull timer) {
                                           strongify(self);
                                           if (self == nil) {
                                               [timer invalidate];
                                               return;
                                           }
                                           [self updateUI];
                                       }] fire];
}

- (void)updateUI {
    self.timeLabel.text = @([self.recorder currentTime] / 1000).stringValue;
    if ([self.recorder isRecording]) {
        self.startBtn.hidden = YES;
        self.stopBtn.hidden = NO;
    } else {
        self.startBtn.hidden = NO;
        self.stopBtn.hidden = YES;
    }
}

- (void)record {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];

    NSString *encoderName = [[AudioManager manager] currentEncoderName];

    NSArray *documentsArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.tmpPath = [documentsArr.firstObject stringByAppendingPathComponent:[NSString stringWithFormat:@"record_tmp.%@", encoderName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.tmpPath]) {
        [fileManager removeItemAtPath:self.tmpPath error:nil];
    }

    Class cls = NSClassFromString([[AudioManager manager] currentRecorderName]);
    AudioFileTypeID fileType = [AudioUtil fileTypeForString:encoderName];
    self.recorder = [[cls alloc] initWithFilePath:self.tmpPath fileType:fileType];
    [self.recorder record];
    [[AudioManager manager] setCurrentRecorder:self.recorder];
}

- (void)stop {
    [self.recorder stop];

    __block UITextField *mTextField;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"录音保存路径"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        mTextField = textField;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *_Nonnull action) {
                                                             [self updateUI];
                                                         }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *_Nonnull action) {
                                                              [self saveAudio:mTextField.text];
                                                              [self updateUI];
                                                          }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)saveAudio:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *documentsArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = documentsArr.firstObject;
    NSString *folderPath = [documentPath stringByAppendingPathComponent:@"Audio"];
    if ([fileManager fileExistsAtPath:folderPath] == NO) {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString *audioPath =
    [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Audio/%@.%@", fileName, self.tmpPath.pathExtension]];

    NSError *error;
    [fileManager moveItemAtPath:self.tmpPath toPath:audioPath error:&error];
    AudioInfo(@"move from %@ to %@, %@", self.tmpPath, audioPath, error);
}
@end
