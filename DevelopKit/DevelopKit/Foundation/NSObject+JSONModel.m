//
//  NSObject+JSONModel.m
//  JSONModel
//
//  Created by jane on 2023/2/1.
//

#import "NSObject+JSONModel.h"
#import <objc/runtime.h>

@implementation NSObject (JSONModel)
+ (instancetype)mm_modelWithJSONString:(NSString *)jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    return jsonObject == nil ? nil : [self mm_modelWithJSONObject:jsonObject];
}

+ (instancetype)mm_modelWithJSONObject:(NSDictionary *)json {
    // 是不是用-[NSObject setValuesForKeysWithDictionary:]更省事？？？
    id object = [[self alloc] init];
    
    unsigned int propertyCount;
    objc_property_t *propertyList = class_copyPropertyList(self, &propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = propertyList[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        
        id value = [json objectForKey:propertyName]; // 这个地方可以做一下属性映射
        if (value == nil) {
            continue;
        }
        
        if ([value isKindOfClass:NSDictionary.class]) {
            NSString *attributeName = [NSString stringWithUTF8String:property_getAttributes(property)];
            NSRange classNameRange = NSMakeRange(3, [attributeName rangeOfString:@"\"" options:NSBackwardsSearch].location - 3);
            NSString *className = [attributeName substringWithRange:classNameRange];
            
            Class class = NSClassFromString(className);
            // 如果property本身就是NSDictionary，那就不用转换了
            if (class && class != NSDictionary.class && class != NSMutableDictionary.class) {
                value = [class mm_modelWithJSONObject:value];
            }
        }
        if (value) {
            [object setValue:value forKey:propertyName];
        }
    }
    free(propertyList);
    
    return object;
}

- (NSString *)mm_modelToJSONString {
    NSDictionary *json = [self mm_modelToJSONObject];
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    
    return [NSString stringWithUTF8String:data.bytes];
}

- (NSDictionary *)mm_modelToJSONObject {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    unsigned int propertyCount;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = propertyList[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        
        id value = [self valueForKey:propertyName]; // 这个地方可以做一下属性映射
        if (value == nil) {
            continue;
        }
        
        if ([value isKindOfClass:NSArray.class]) {
            value = [self _mm_arrayWithArray:value];
        } else if ([value isKindOfClass:NSDictionary.class] == NO && [value isKindOfClass:NSString.class] == NO && [value isKindOfClass:NSNumber.class] == NO) {
            value = [value mm_modelToJSONObject];
        }
        
        if (value) {
            [json setObject:value forKey:propertyName];
        }
    }
    free(propertyList);
    
    return json;
}

- (NSArray *)_mm_arrayWithArray:(NSArray *)value {
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [(NSArray *)value count]; i++) {
        id arrayItem = value[i];
        if ([arrayItem isKindOfClass:NSArray.class]) {
            [array addObject:[self _mm_arrayWithArray:arrayItem]];
        } else if ([arrayItem isKindOfClass:NSDictionary.class] || [arrayItem isKindOfClass:NSString.class] || [arrayItem isKindOfClass:NSNumber.class]) {
            [array addObject:arrayItem];
        } else {
            [array addObject:[arrayItem mm_modelToJSONObject]];
        }
    }

    return [array copy];
}
@end
