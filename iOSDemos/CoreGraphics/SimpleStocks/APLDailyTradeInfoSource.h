//
//  DailyTradeInfoSource.h
//  iOSDemos
//
//  Created by janezhuang on 2024/7/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 A simple model controller, this class contains all the data rather than getting it from somewhere else. This simpler approach was chosen so this sample could focus on drawing rather than interaction with a data service.

 In the real world you'd want this class to request the information from a webservice or something similar.
 */

@interface DailyTradeInfoSource : NSObject

+ (NSArray *)tradeInfoArray;

@end

NS_ASSUME_NONNULL_END
