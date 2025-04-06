//
//  MemoryMapFile.m
//  DevelopKit
//
//  Created by janezhuang on 2025/4/6.
//

#import "MemoryMapFile.h"
#import <sys/stat.h>
#import <sys/mman.h>

@interface MemoryMapFile () {
    int _fd;

    void *_filePtr;
    uint64_t _mmapSize;
}
@end

@implementation MemoryMapFile
- (instancetype)initWithFilePath:(NSString *)filePath {
    self = [super init];
    if (self) {
        _fd = open([filePath UTF8String], O_CREAT | O_RDWR, S_IRUSR | S_IWUSR);
        if (_fd < 0) {
            NSLog(@"open file fail");
            return nil;
        }

        if ([self initFileInfo] == NO) {
            return nil;
        }

        if ([self doMemoryMap] == NO) {
            return nil;
        }
    }
    return self;
}

- (void)dealloc {
    if (close(_fd) < 0) {
        NSLog(@"fail to close: %d,", _fd);
    }
    if (munmap(_filePtr, _fileSize) < 0) {
        NSLog(@"munmap fail");
    }
}
#pragma mark - Public
- (NSData *)readDataToEndOfFile {
    uint64_t length = _fileSize - _offset;
    return [self readDataUpToLength:length];
}

- (NSData *)readDataUpToLength:(uint64_t)length {
    if (_offset + length >= _fileSize) {
        length = _fileSize - _offset;
    }

    if (length == 0) {
        return nil;
    }

    void *dst = malloc(length);
    memcpy(dst, _filePtr + _offset, length);
    _offset += length;

    NSData *data = [[NSData alloc] initWithBytesNoCopy:dst length:length];
    return data;
}

- (uint64_t)seekToEndOfFile {
    _offset = _fileSize;
    return _offset;
}

- (void)seekToOffset:(uint64_t)offset {
    if (offset > _fileSize) {
        NSAssert(NO, @"out of size");
        return;
    }
    _offset = offset;
}

- (BOOL)writeData:(NSData *)data {
    uint64_t length = data.length;
    if (length == 0) {
        return YES;
    }

    if ([self truncateToSize:_offset + length] == NO) {
        return NO;
    }

    const void *src = data.bytes;
    memcpy(_filePtr + _offset, src, length);
    _offset += length;

    _fileSize = MAX(_fileSize, _offset);
    return YES;
}

- (BOOL)appendData:(NSData *)data {
    [self seekToEndOfFile];
    return [self writeData:data];
}

- (void)synchronize:(BOOL)sync {
    msync(_filePtr, _mmapSize, sync ? MS_SYNC : MS_ASYNC);
}
#pragma mark - Private
- (BOOL)initFileInfo {
    struct stat st = {};
    if (fstat(_fd, &st) != -1) {
        _fileSize = (uint64_t)st.st_size;
    } else {
        NSLog(@"get file size fail");
        return NO;
    }

    size_t pageSize = getpagesize();
    if (_fileSize == 0 || _fileSize % pageSize != 0) {
        _mmapSize = (_fileSize / pageSize + 1) * pageSize;
    } else {
        _mmapSize = _fileSize;
    }

    _offset = 0;
    return YES;
}

- (BOOL)doMemoryMap {
    _filePtr = (char *)mmap(NULL, _mmapSize, PROT_READ | PROT_WRITE, MAP_SHARED, _fd, 0);
    if (_filePtr == MAP_FAILED) {
        NSLog(@"mmap fail");
        return NO;
    }

    return YES;
}

- (BOOL)truncateToSize:(uint64_t)size {
    if (size <= _fileSize) {
        return YES;
    }

    if (ftruncate(_fd, size) != 0) {
        NSLog(@"truncate size:%llu fail", size);
        return NO;
    }
    _fileSize = size;

    size_t pageSize = getpagesize();
    uint64_t newSize = (size / pageSize + 1) * pageSize;
    if (newSize != _mmapSize) {
        if (munmap(_filePtr, _mmapSize) < 0) {
            NSLog(@"munmap fail");
            return NO;
        }

        _mmapSize = newSize;
        if ([self doMemoryMap] == NO) {
            return NO;
        }
    }

    return YES;
}

@end
