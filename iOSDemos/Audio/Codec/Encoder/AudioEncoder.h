//
//  AudioEncoder.h
//  Audio
//
//  Created by janezhuang on 2022/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioEncoder : NSObject

- (instancetype)initWithFileType:(AudioFileTypeID)fileType;

- (void)encodePCMFileFromPath:(NSString *)fromPath withFormat:(const AudioStreamBasicDescription *)format toPath:(NSString *)toPath;

@end

NS_ASSUME_NONNULL_END
