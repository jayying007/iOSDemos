//
//  AudioDecoder.m
//  Audio
//
//  Created by janezhuang on 2022/10/3.
//

#import "AudioDecoder.h"

@implementation AudioDecoder
- (instancetype)init {
    self = [super init];
    if (self) {
        dataFormat = (AudioStreamBasicDescription *)malloc(sizeof(AudioStreamBasicDescription));
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)url {
    return nil;
}

- (void)readPacketsFromCurrent:(UInt32)currentPacket
                    numPackets:(UInt32 &)numPackets
            packetDescriptions:(AudioStreamPacketDescription *)packetDescriptions
                     outBuffer:(void *)outBuffer
                      numBytes:(UInt32 &)numBytes {
}

- (AudioStreamBasicDescription *)dataFormat {
    return dataFormat;
}

- (UInt32)duration {
    return duration;
}

- (UInt32)maxPacketSize {
    return maxPacketSize;
}
@end
