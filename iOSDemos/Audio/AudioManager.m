//
//  AudioManager.m
//  Audio
//
//  Created by janezhuang on 2022/2/15.
//

#import "AudioManager.h"

@implementation AudioManager

+ (instancetype)manager {
    static AudioManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AudioManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *playerName = [[NSUserDefaults standardUserDefaults] stringForKey:@"playerName"];
        _currentPlayerName = playerName.length > 0 ? playerName : @"AudioPlayer";

        NSString *decoderName = [[NSUserDefaults standardUserDefaults] stringForKey:@"decoderName"];
        _currentDecoderName = decoderName.length > 0 ? decoderName : @"AudioFileDecoder";

        NSString *recorderName = [[NSUserDefaults standardUserDefaults] stringForKey:@"recorderName"];
        _currentRecorderName = recorderName.length > 0 ? recorderName : @"AudioRecorder";

        NSString *encoderName = [[NSUserDefaults standardUserDefaults] stringForKey:@"encoderName"];
        _currentEncoderName = encoderName.length > 0 ? encoderName : @"mp3";
    }
    return self;
}

- (void)setCurrentPlayerName:(NSString *)playerName {
    _currentPlayerName = playerName;
    [[NSUserDefaults standardUserDefaults] setObject:playerName forKey:@"playerName"];

    self.currentPlayer = nil;
    self.currentPlayPath = nil;
}

- (void)setCurrentDecoderName:(NSString *)currentDecoderName {
    _currentDecoderName = currentDecoderName;
    [[NSUserDefaults standardUserDefaults] setObject:currentDecoderName forKey:@"decoderName"];

    self.currentPlayer = nil;
    self.currentPlayPath = nil;
}

- (void)setCurrentRecorderName:(NSString *)currentRecorderName {
    _currentRecorderName = currentRecorderName;
    [[NSUserDefaults standardUserDefaults] setObject:currentRecorderName forKey:@"recorderName"];

    self.currentRecorder = nil;
    self.currentRecordPath = nil;
}

- (void)setCurrentEncoderName:(NSString *)currentEncoderName {
    _currentEncoderName = currentEncoderName;
    [[NSUserDefaults standardUserDefaults] setObject:currentEncoderName forKey:@"encoderName"];

    self.currentRecorder = nil;
    self.currentRecordPath = nil;
}
@end
