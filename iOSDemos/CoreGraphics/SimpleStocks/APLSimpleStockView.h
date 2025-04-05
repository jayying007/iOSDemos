//
//  APLSimpleStockView.h
//  iOSDemos
//
//  Created by janezhuang on 2024/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class APLSimpleStockView;

/*
 * A protocol to return the data for this view to draw.
 */
@protocol APLSimpleStockViewDataSource <NSObject>

- (NSInteger)graphViewDailyTradeInfoCount:(APLSimpleStockView *)graphView;
- (NSInteger)graphView:(APLSimpleStockView *)graphView tradeCountForMonth:(NSDateComponents *)components;
- (NSArray *)graphViewSortedMonths:(APLSimpleStockView *)graphView;
- (NSArray *)graphViewDailyTradeInfos:(APLSimpleStockView *)graphView;
- (CGFloat)graphViewMaxClosingPrice:(APLSimpleStockView *)graphView;
- (CGFloat)graphViewMinClosingPrice:(APLSimpleStockView *)graphView;
- (CGFloat)graphViewMaxTradingVolume:(APLSimpleStockView *)graphView;
- (CGFloat)graphViewMinTradingVolume:(APLSimpleStockView *)graphView;

@end

@interface APLSimpleStockView : UIView

@property (nonatomic, weak) id<APLSimpleStockViewDataSource> dataSource;

@end

NS_ASSUME_NONNULL_END
