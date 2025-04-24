//
//  FileUtil.m
//  Audio
//
//  Created by janezhuang on 2022/10/15.
//

#import "FileUtil.h"

@implementation FileUtil
+ (BOOL)createFile:(NSString *)filePath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        BOOL ret = [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        if (ret == NO) {
            return NO;
        }
    }
    return [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
}

+ (UInt64)fileSize:(NSString *)filePath {
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
}
@end
