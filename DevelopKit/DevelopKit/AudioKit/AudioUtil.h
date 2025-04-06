//
//  AudioUtil.h
//  DevelopKit
//
//  Created by janezhuang on 2025/4/6.
//

#import <Foundation/Foundation.h>

typedef enum LineType {
    LineType_Sine = 0, //默认，正弦波形图
    LineType_Square = 1, //类似脉冲
    LineType_SawTooth = 2, //线性
} LineType;

NS_ASSUME_NONNULL_BEGIN

@interface AudioUtil : NSObject

+ (void)mockPCM:(double)hz type:(LineType)type sampleRate:(double)sampleRate duration:(double)duration filePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
