//
//  Mp3AudioEncoder.m
//  Audio
//
//  Created by janezhuang on 2022/10/13.
//

#import "MP3AudioEncoder.h"
#import "lame.h"
#import <DevelopKit/FileUtil.h>

@implementation MP3AudioEncoder
- (void)encodePCMFileFromPath:(NSString *)fromPath withFormat:(const AudioStreamBasicDescription *)format toPath:(NSString *)toPath {
    lame_t lame = lame_init();

    lame_set_in_samplerate(lame, format->mSampleRate);
    lame_set_out_samplerate(lame, 44100);
    lame_set_num_channels(lame, format->mChannelsPerFrame);
    lame_set_brate(lame, 128);
    lame_init_params(lame);

    [FileUtil createFile:toPath];
    NSFileHandle *pcmFileHandle = [NSFileHandle fileHandleForReadingAtPath:fromPath];
    NSFileHandle *mp3FileHandle = [NSFileHandle fileHandleForWritingAtPath:toPath];

    int bufferSize = 1024 * 64;
    unsigned char mp3Buffer[bufferSize];
    do {
        NSData *pcmData = [pcmFileHandle readDataUpToLength:bufferSize error:nil];
        if (pcmData.length == 0) {
            break;
        }
        int readPcmFrames = (int)pcmData.length / format->mBytesPerFrame;

        int encodedBytes = 0;
        if (format->mChannelsPerFrame == 2) {
            encodedBytes = lame_encode_buffer_interleaved(lame, (short int *)pcmData.bytes, readPcmFrames, mp3Buffer, bufferSize);
        } else {
            encodedBytes = lame_encode_buffer(lame, (short int *)pcmData.bytes, (short int *)pcmData.bytes, readPcmFrames, mp3Buffer, bufferSize);
        }
        // save mp3 to file
        if (encodedBytes < 0) {
            break;
        }
        NSData *mp3Data = [NSData dataWithBytes:&mp3Buffer length:encodedBytes];
        [mp3FileHandle writeData:mp3Data];
    } while (true);

    [pcmFileHandle closeFile];
    [mp3FileHandle closeFile];
    lame_close(lame);
}
@end
