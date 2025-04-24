//
//  FileUtil.h
//  Audio
//
//  Created by janezhuang on 2022/10/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileUtil : NSObject
+ (BOOL)createFile:(NSString *)filePath;
+ (UInt64)fileSize:(NSString *)filePath;
@end

NS_ASSUME_NONNULL_END
