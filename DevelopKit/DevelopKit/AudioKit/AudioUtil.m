//
//  AudioUtil.m
//  DevelopKit
//
//  Created by janezhuang on 2025/4/6.
//

#import "AudioUtil.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation AudioUtil

+ (void)mockPCM:(double)hz type:(LineType)type sampleRate:(double)sampleRate duration:(double)duration filePath:(NSString *)filePath {
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];

    AudioStreamBasicDescription asbd;
    memset(&asbd, 0, sizeof(asbd));
    asbd.mSampleRate = sampleRate;
    asbd.mFormatID = kAudioFormatLinearPCM;
    asbd.mFormatFlags = kAudioFormatFlagIsBigEndian | kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    asbd.mBitsPerChannel = 16;
    asbd.mChannelsPerFrame = 1;
    asbd.mBytesPerFrame = asbd.mChannelsPerFrame * asbd.mBitsPerChannel / 8;
    asbd.mFramesPerPacket = 1;
    asbd.mBytesPerPacket = asbd.mBytesPerFrame * asbd.mFramesPerPacket;
    //AIFF只接受BigEndian
    AudioFileID audioFile;
    OSStatus status = AudioFileCreateWithURL((__bridge CFURLRef)fileUrl, kAudioFileAIFFType, &asbd, kAudioFileFlags_EraseFile, &audioFile);
    assert(status == noErr);

    //总的采样次数
    long maxSampleCount = sampleRate * duration;
    long sampleCount = 0;
    UInt32 bytesToWrite = 2;
    //这个频率内，有多少个采样点
    double waveLengthInSamples = sampleRate / hz;

    while (sampleCount < maxSampleCount) {
        for (int i = 0; i < waveLengthInSamples; i++) {
            //SHRT_MIN、SHRT_MAX 用来控制响度
            SInt16 sample;
            if (type == LineType_Sine) {
                sample = CFSwapInt16HostToBig((SInt16)(SHRT_MAX * sin(2 * M_PI * i / waveLengthInSamples)));
            } else if (type == LineType_Square) {
                if (i < waveLengthInSamples / 2) {
                    sample = CFSwapInt16HostToBig(SHRT_MAX);
                } else {
                    sample = CFSwapInt16HostToBig(SHRT_MIN);
                }
            } else if (type == LineType_SawTooth) {
                sample = CFSwapInt16HostToBig((SInt16)(SHRT_MAX * 2 * i / waveLengthInSamples - SHRT_MAX));
            }

            status = AudioFileWriteBytes(audioFile, false, sampleCount * 2, &bytesToWrite, &sample);
            assert(status == noErr);
            sampleCount++;
        }
    }

    status = AudioFileClose(audioFile);
    assert(status == noErr);

    NSLog(@"wrote %ld samples", sampleCount);
}

+ (AudioFileTypeID)fileTypeForUrl:(NSURL *)url {
    if ([url isFileURL]) {
        if ([url.pathExtension isEqualToString:@"mp3"]) {
            return kAudioFileMP3Type;
        }
        if ([url.pathExtension isEqualToString:@"m4a"]) {
            return kAudioFileM4AType;
        }
    }
    return 0;
}

+ (AudioFileTypeID)fileTypeForString:(NSString *)string {
    if ([string isEqualToString:@"mp3"]) {
        return kAudioFileMP3Type;
    }
    if ([string isEqualToString:@"wav"]) {
        return kAudioFileWAVEType;
    }
    if ([string isEqualToString:@"aac"]) {
        return kAudioFileAAC_ADTSType;
    }
    return 0;
}

+ (NSString *)enumValueToString:(SInt32)value {
    static char str[16];

    *(UInt32 *)(str + 1) = CFSwapInt32HostToBig(value);
    if (isprint(str[1]) && isprint(str[2]) && isprint(str[3]) && isprint(str[4])) {
        str[0] = str[5] = '\'';
        str[6] = '\0';
    } else if (value > -200000 && value < 200000) {
        // no, format it as an integer
        sprintf(str, "%d", (int)value);
    } else {
        sprintf(str, "0x%x", (int)value);
    }

    return [NSString stringWithUTF8String:str];
}

+ (void)printFileInfo:(NSURL *)url {
    //读取文件
    AudioFileID audioFile;
    AudioFileOpenURL((__bridge CFURLRef)url, kAudioFileReadPermission, 0, &audioFile);

    //获取大小
    UInt32 dictionarySize = 0;
    AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyInfoDictionary, &dictionarySize, 0);

    NSDictionary *dictionary;
    AudioFileGetProperty(audioFile, kAudioFilePropertyInfoDictionary, &dictionarySize, &dictionary); // 为啥是&dictionary

    AudioFileClose(audioFile);
    NSLog(@"=====Meta Data=====");
    NSLog(@"%@", dictionary);
}

@end
