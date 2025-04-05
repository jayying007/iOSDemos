//
//  APLDailyTradeInfo.h
//  iOSDemos
//
//  Created by janezhuang on 2024/7/13.
//

#import <Foundation/Foundation.h>

@interface DailyTradeInfo : NSObject

@property (nonatomic, copy) NSDate *tradingDate;
@property (nonatomic, copy) NSNumber *openingPrice;
@property (nonatomic, copy) NSNumber *highPrice;
@property (nonatomic, copy) NSNumber *lowPrice;
@property (nonatomic, copy) NSNumber *closingPrice;
@property (nonatomic, copy) NSNumber *tradingVolume;

@end
