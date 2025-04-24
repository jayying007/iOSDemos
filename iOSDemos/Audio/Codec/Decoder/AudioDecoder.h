//
//  AudioDecoder.h
//  Audio
//
//  Created by janezhuang on 2022/10/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioDecoder : NSObject {
    AudioStreamBasicDescription *dataFormat;
    UInt32 duration;
    UInt32 maxPacketSize;
    UInt64 audioDataByteCount;
    UInt64 audioDataPacketCount;
    UInt32 readyToProducePackets;
    UInt32 bitRate;
    UInt64 audioDataOffset;
}
- (instancetype)initWithURL:(NSURL *)url;
- (void)readPacketsFromCurrent:(UInt32)currentPacket
                    numPackets:(UInt32 &)numPackets
            packetDescriptions:(AudioStreamPacketDescription *)packetDescriptions
                     outBuffer:(void *)outBuffer
                      numBytes:(UInt32 &)numBytes;

- (AudioStreamBasicDescription *)dataFormat;
- (UInt32)duration;
- (UInt32)maxPacketSize;
@end

NS_ASSUME_NONNULL_END
