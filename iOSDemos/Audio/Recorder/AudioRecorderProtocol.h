//
//  AudioRecorderProtocol.h
//  Audio
//
//  Created by janezhuang on 2022/2/15.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AudioRecorderProtocol <NSObject>

- (instancetype)initWithFilePath:(NSString *)filePath fileType:(AudioFileTypeID)fileType;
@property (nonatomic, readonly) NSString *filePath;

- (void)record;

- (void)stop;

/// 录音时长，单位ms
- (UInt32)currentTime;

- (BOOL)isRecording;

@end

NS_ASSUME_NONNULL_END
