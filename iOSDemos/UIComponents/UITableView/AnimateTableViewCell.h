//
//  AnimateTableViewCell.h
//  iOSDemos
//
//  Created by janezhuang on 2023/12/1.
//

#import <UIKit/UIKit.h>

@interface Model : NSObject

@property (nonatomic) CGFloat normalHeight;
@property (nonatomic) CGFloat expendHeight;
@property (nonatomic) BOOL expend;

+ (instancetype)ModelWithNormalHeight:(CGFloat)normalHeight expendHeight:(CGFloat)expendHeight expend:(BOOL)expend;

@end

@interface AnimateTableViewCell : UITableViewCell

@property (nonatomic, weak) NSIndexPath *indexPath;
@property (nonatomic, weak) UITableView *tableView;

- (void)loadData:(id)data;

- (void)buttonEvent;

@end
