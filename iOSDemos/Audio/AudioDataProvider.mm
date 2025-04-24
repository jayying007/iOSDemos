//
//  AudioDataProvider.m
//  Audio
//
//  Created by janezhuang on 2022/10/3.
//

#import "AudioDataProvider.h"
#import "AudioDecoder.h"
#import "AudioManager.h"

@interface AudioDataProvider ()
@property (nonatomic) AudioDecoder *decoder;
@end

@implementation AudioDataProvider
- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        NSString *decoderName = [[AudioManager manager] currentDecoderName];
        _decoder = [[NSClassFromString(decoderName) alloc] initWithURL:url];
    }
    return self;
}

- (AudioStreamBasicDescription *)dataFormat {
    return _decoder.dataFormat;
}

- (UInt32)duration {
    return _decoder.duration;
}

- (UInt32)maxPacketSize {
    return _decoder.maxPacketSize;
}

- (void)readPacketsFromCurrent:(UInt64)currentPacket
                    numPackets:(UInt32 &)numPackets
            packetDescriptions:(AudioStreamPacketDescription *)packetDescriptions
                     outBuffer:(void *)outBuffer
                      numBytes:(UInt32 &)numBytes {
    return [_decoder readPacketsFromCurrent:(UInt32)currentPacket
                                 numPackets:numPackets
                         packetDescriptions:packetDescriptions
                                  outBuffer:outBuffer
                                   numBytes:numBytes];
}
@end
