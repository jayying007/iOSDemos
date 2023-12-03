//
//  UITableViewInfo.h
//  iOSDemos
//
//  Created by janezhuang on 2023/11/29.
//

#import <Foundation/Foundation.h>

typedef void (^RowClickHandler)(void);

@interface UITableViewRowInfo : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *detail;

/// 跳转的VC
@property (nonatomic) NSString *className;
@property (nonatomic) RowClickHandler handler;

- (UITableViewRowInfo * (^)(NSString *))c_title;
- (UITableViewRowInfo * (^)(NSString *))c_detail;
- (UITableViewRowInfo * (^)(NSString *))c_className;
- (UITableViewRowInfo * (^)(RowClickHandler))c_handler;

@end

@interface UITableViewSectionInfo : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSMutableArray *rows;

- (void)addRowInfo:(void (^)(UITableViewRowInfo *rowInfo))rowBuilder;

- (UITableViewRowInfo *)addRow;

@end

@interface UITableViewInfo : NSObject

@property (nonatomic) NSMutableArray *sections;

- (void)addSectionInfo:(void (^)(UITableViewSectionInfo *sectionInfo))sectionBuilder;

@end
