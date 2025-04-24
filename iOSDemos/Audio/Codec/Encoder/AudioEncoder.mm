//
//  AudioEncoder.m
//  Audio
//
//  Created by janezhuang on 2022/10/13.
//

#import "AudioEncoder.h"
#import "MP3AudioEncoder.h"
#import "WAVAudioEncoder.h"
#import "AACAudioEncoder.h"

@implementation AudioEncoder
- (instancetype)initWithFileType:(AudioFileTypeID)fileType {
    if (fileType == kAudioFileMP3Type) {
        return [[MP3AudioEncoder alloc] init];
    }
    if (fileType == kAudioFileWAVEType) {
        return [[WAVAudioEncoder alloc] init];
    }
    if (fileType == kAudioFileAAC_ADTSType) {
        return [[AACAudioEncoder alloc] init];
    }
    return nil;
}

- (void)encodePCMFileFromPath:(NSString *)fromPath withFormat:(const AudioStreamBasicDescription *)format toPath:(NSString *)toPath {
    assert(0);
}
@end
