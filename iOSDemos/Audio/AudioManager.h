//
//  AudioManager.h
//  Audio
//
//  Created by janezhuang on 2022/2/15.
//

#import "AudioPlayerProtocol.h"
#import "AudioRecorderProtocol.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioManager : NSObject

+ (instancetype)manager;

@property (nonatomic, nullable) id<AudioPlayerProtocol> currentPlayer;
@property (nonatomic, nullable) NSString *currentPlayPath;

@property (nonatomic, nullable) id<AudioRecorderProtocol> currentRecorder;
@property (nonatomic, nullable) NSString *currentRecordPath;

@property (nonatomic) NSString *currentPlayerName;
@property (nonatomic) NSString *currentDecoderName;

@property (nonatomic) NSString *currentRecorderName;
@property (nonatomic) NSString *currentEncoderName;

@end

NS_ASSUME_NONNULL_END
