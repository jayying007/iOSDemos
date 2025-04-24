//
//  WavAudioEncoder.m
//  Audio
//
//  Created by janezhuang on 2022/10/13.
//

#import "WAVAudioEncoder.h"
#import <DevelopKit/FileUtil.h>

// 格式参考 https://blog.csdn.net/u013517122/article/details/111374205
NSData *WAVHeader(long audioDataLen, long sampleRate, int channels, long byteRate) {
    long chunkSize = audioDataLen + 36;

    Byte header[44];
    header[0] = 'R'; // RIFF/WAVE header
    header[1] = 'I';
    header[2] = 'F';
    header[3] = 'F';
    header[4] = (Byte)(chunkSize & 0xff); //file-size (equals file-size - 8)
    header[5] = (Byte)((chunkSize >> 8) & 0xff);
    header[6] = (Byte)((chunkSize >> 16) & 0xff);
    header[7] = (Byte)((chunkSize >> 24) & 0xff);
    header[8] = 'W'; // Mark it as type "WAVE"
    header[9] = 'A';
    header[10] = 'V';
    header[11] = 'E';
    header[12] = 'f'; // Mark the format section 'fmt ' chunk
    header[13] = 'm';
    header[14] = 't';
    header[15] = ' ';
    header[16] = 16; // 4 bytes: size of 'fmt ' chunk, Length of format data.  Always 16
    header[17] = 0;
    header[18] = 0;
    header[19] = 0;
    header[20] = 1; // format = 1 ,Wave type PCM
    header[21] = 0;
    header[22] = (Byte)channels; // channels
    header[23] = 0;
    header[24] = (Byte)(sampleRate & 0xff);
    header[25] = (Byte)((sampleRate >> 8) & 0xff);
    header[26] = (Byte)((sampleRate >> 16) & 0xff);
    header[27] = (Byte)((sampleRate >> 24) & 0xff);
    header[28] = (Byte)(byteRate & 0xff);
    header[29] = (Byte)((byteRate >> 8) & 0xff);
    header[30] = (Byte)((byteRate >> 16) & 0xff);
    header[31] = (Byte)((byteRate >> 24) & 0xff);
    header[32] = (Byte)(2 * 16 / 8); // block align
    header[33] = 0;
    header[34] = 16; // bits per sample
    header[35] = 0;
    header[36] = 'd'; //"data" marker
    header[37] = 'a';
    header[38] = 't';
    header[39] = 'a';
    header[40] = (Byte)(audioDataLen & 0xff); //data-size (equals file-size - 44).
    header[41] = (Byte)((audioDataLen >> 8) & 0xff);
    header[42] = (Byte)((audioDataLen >> 16) & 0xff);
    header[43] = (Byte)((audioDataLen >> 24) & 0xff);
    return [[NSData alloc] initWithBytes:header length:44];
}

@implementation WAVAudioEncoder

- (void)encodePCMFileFromPath:(NSString *)fromPath withFormat:(const AudioStreamBasicDescription *)format toPath:(NSString *)toPath {
    AudioFileID audioFile;
    AudioFileCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:toPath], kAudioFileWAVEType, format, kAudioFileFlags_EraseFile, &audioFile);

    UInt64 fileSize = [FileUtil fileSize:fromPath];
    long byteRate = format->mSampleRate * format->mBytesPerFrame;
    // write header
    NSData *fileHeader = WAVHeader(fileSize, format->mSampleRate, format->mChannelsPerFrame, byteRate);
    UInt32 numBytes = (UInt32)fileHeader.length;
    AudioFileWriteBytes(audioFile, false, 0, &numBytes, fileHeader.bytes);
    // write data
    NSData *audioData = [NSData dataWithContentsOfFile:fromPath];
    numBytes = (UInt32)audioData.length;
    AudioFileWriteBytes(audioFile, false, fileHeader.length, &numBytes, audioData.bytes);

    AudioFileClose(audioFile);
}

@end
