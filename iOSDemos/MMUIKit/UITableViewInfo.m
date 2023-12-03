//
//  UITableViewInfo.m
//  iOSDemos
//
//  Created by janezhuang on 2023/11/29.
//

#import "UITableViewInfo.h"

@implementation UITableViewRowInfo

- (UITableViewRowInfo * (^)(NSString *))c_title {
    return ^UITableViewRowInfo *(NSString *title) {
        self.title = title;
        return self;
    };
}

- (UITableViewRowInfo * (^)(NSString *))c_detail {
    return ^UITableViewRowInfo *(NSString *detail) {
        self.detail = detail;
        return self;
    };
}

- (UITableViewRowInfo * (^)(NSString *))c_className {
    return ^UITableViewRowInfo *(NSString *className) {
        self.className = className;
        return self;
    };
}

- (UITableViewRowInfo * (^)(RowClickHandler))c_handler {
    return ^UITableViewRowInfo *(RowClickHandler handler) {
        self.handler = handler;
        return self;
    };
}

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

- (UITableViewRowInfo *)addRow {
    UITableViewRowInfo *rowInfo = [[UITableViewRowInfo alloc] init];
    [self.rows addObject:rowInfo];
    return rowInfo;
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
