//
//  UITableViewInfo.h
//  iOSDemos
//
//  Created by janezhuang on 2023/11/29.
//

#import <Foundation/Foundation.h>

typedef void(^RowClickHandler)(void);

@interface UITableViewRowInfo : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *detail;
@property (nonatomic) RowClickHandler handler;

@end

@interface UITableViewSectionInfo : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSMutableArray *rows;

- (void)addRowInfo:(void(^)(UITableViewRowInfo *rowInfo))rowBuilder;

@end

@interface UITableViewInfo : NSObject

@property (nonatomic) NSMutableArray *sections;

- (void)addSectionInfo:(void(^)(UITableViewSectionInfo *sectionInfo))sectionBuilder;

@end

