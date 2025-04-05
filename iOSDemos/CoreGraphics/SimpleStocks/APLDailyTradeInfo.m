//
//  APLDailyTradeInfo.m
//  iOSDemos
//
//  Created by janezhuang on 2024/7/13.
//

#import "APLDailyTradeInfo.h"

@implementation DailyTradeInfo

/*
 * Simple debugging info.
 */
- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %@", self.tradingDate, self.closingPrice];
}

/*
 * Compare trading info's based on their trade date so they sort acording to their date.
 */
- (NSComparisonResult)compare:obj2 {
    return [self.tradingDate compare:((DailyTradeInfo *)obj2).tradingDate];
}

@end
