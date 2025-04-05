//
//  APLSimpleStockViewController.m
//  iOSDemos
//
//  Created by janezhuang on 2024/7/13.
//

#import "APLSimpleStockViewController.h"
#import "APLSimpleStockView.h"
#import "APLDailyTradeInfoSource.h"

@interface APLSimpleStockViewController () <APLSimpleStockViewDataSource>

@end

@implementation APLSimpleStockViewController

- (void)loadView {
    APLSimpleStockView *stockView = [[APLSimpleStockView alloc] initWithFrame:self.navigationController.view.bounds];
    stockView.dataSource = self;
    self.view = stockView;
}

#pragma mark - APLSimpleStockViewDataSource

- (NSInteger)graphViewDailyTradeInfoCount:(APLSimpleStockView *)graphView {
    return [[DailyTradeInfoSource tradeInfoArray] count];
}

/*
 Return the month to be drawn.
 */
- (NSArray *)graphViewSortedMonths:(APLSimpleStockView *)graphView {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSArray *closingDates = [[DailyTradeInfoSource tradeInfoArray] valueForKeyPath:@"tradingDate"];
    __block NSCountedSet *months = [NSCountedSet set];
    [closingDates enumerateObjectsUsingBlock:^(id closingDate, NSUInteger index, BOOL *stop) {
        [months addObject:[calendar components:NSCalendarUnitMonth fromDate:closingDate]];
    }];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"month" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    return [months sortedArrayUsingDescriptors:descriptors];
}

/*
 For the given month (in components) return the number of trades some months have 20 trading days, some have 23. This method makes it possible for us to layout the months names accordingly
 */
- (NSInteger)graphView:(APLSimpleStockView *)graphView tradeCountForMonth:(NSDateComponents *)components {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSArray *closingDates = [[DailyTradeInfoSource tradeInfoArray] valueForKeyPath:@"tradingDate"];
    __block NSCountedSet *months = [NSCountedSet set];
    [closingDates enumerateObjectsUsingBlock:^(id closingDate, NSUInteger index, BOOL *stop) {
        [months addObject:[calendar components:NSCalendarUnitMonth fromDate:closingDate]];
    }];
    return [months countForObject:components];
}

/*
 * Return the model objects
 */
- (NSArray *)graphViewDailyTradeInfos:(APLSimpleStockView *)graphView {
    return [DailyTradeInfoSource tradeInfoArray];
}

/*
 * Return the max closing price
 */
- (CGFloat)graphViewMaxClosingPrice:(APLSimpleStockView *)graphView {
    return [[[DailyTradeInfoSource tradeInfoArray] valueForKeyPath:@"@max.closingPrice"] floatValue];
}

/*
 * Return the min closing price
 */
- (CGFloat)graphViewMinClosingPrice:(APLSimpleStockView *)graphView {
    return [[[DailyTradeInfoSource tradeInfoArray] valueForKeyPath:@"@min.closingPrice"] floatValue];
}

/*
 * Return the max trading volume
 */
- (CGFloat)graphViewMaxTradingVolume:(APLSimpleStockView *)graphView {
    return [[[DailyTradeInfoSource tradeInfoArray] valueForKeyPath:@"@max.tradingVolume"] floatValue];
}

/*
 * Return the min trading volume
 */
- (CGFloat)graphViewMinTradingVolume:(APLSimpleStockView *)graphView {
    return [[[DailyTradeInfoSource tradeInfoArray] valueForKeyPath:@"@min.tradingVolume"] floatValue];
}

@end
