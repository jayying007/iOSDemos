//
//  MemoryMapFile.h
//  DevelopKit
//
//  Created by janezhuang on 2025/4/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 because a `MemoryMapFile` is page align, you need to record the real data size somewhere. for example, in other `MemoryMapFile`
 */
@interface MemoryMapFile : NSObject

/**
 @discussion will create file if not exist.
 @return nil if some error happen.
 */
- (instancetype)initWithFilePath:(NSString *)filePath;
@property (nonatomic, readonly) uint64_t fileSize;

/**
 read data from current offset to end of file. Then update current offset.
 */
- (NSData *)readDataToEndOfFile;
/**
 read data from current offset with given length. Then update current offset.
 @discussion if length isn't available, it will return from current offset to end of file.
 */
- (NSData *)readDataUpToLength:(uint64_t)length;

/**
 @return it is equal to file size
 */
- (uint64_t)seekToEndOfFile;
/**
 @param offset must be less or equal than fileSize.
 */
- (void)seekToOffset:(uint64_t)offset;
/**
 current offset in file
 */
@property (nonatomic, readonly) uint64_t offset;

/**
 write data start from current offset. Truncate if need. Then update current offset.
 */
- (BOOL)writeData:(NSData *)data;
- (BOOL)appendData:(NSData *)data;

/**
 flush the data to disk. Otherwise, it will be handle by mmap itself.
 */
- (void)synchronize:(BOOL)sync;

@end

NS_ASSUME_NONNULL_END
