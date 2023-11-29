//
//  UITableViewInfo.m
//  iOSDemos
//
//  Created by janezhuang on 2023/11/29.
//

#import "UITableViewInfo.h"

@implementation UITableViewRowInfo

@end

@implementation UITableViewSectionInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        _rows = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addRowInfo:(void (^)(UITableViewRowInfo *))rowBuilder {
    UITableViewRowInfo *rowInfo = [[UITableViewRowInfo alloc] init];
    rowBuilder(rowInfo);
    [_rows addObject:rowInfo];
}

@end

@implementation UITableViewInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        _sections = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addSectionInfo:(void (^)(UITableViewSectionInfo *sectionInfo))sectionBuilder {
    UITableViewSectionInfo *sectionInfo = [[UITableViewSectionInfo alloc] init];
    sectionBuilder(sectionInfo);
    [_sections addObject:sectionInfo];
}

@end
