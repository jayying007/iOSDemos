//
//  AudioDataProvider.h
//  Audio
//
//  Created by janezhuang on 2022/10/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioDataProvider : NSObject
- (instancetype)initWithURL:(NSURL *)url;

@property (nonatomic) AudioStreamBasicDescription *dataFormat;
@property (nonatomic) UInt32 duration;
@property (nonatomic) UInt32 maxPacketSize;

- (void)readPacketsFromCurrent:(UInt64)currentPacket
                    numPackets:(UInt32 &)numPackets
            packetDescriptions:(AudioStreamPacketDescription *)packetDescriptions
                     outBuffer:(void *)outBuffer
                      numBytes:(UInt32 &)numBytes;
@end

NS_ASSUME_NONNULL_END
