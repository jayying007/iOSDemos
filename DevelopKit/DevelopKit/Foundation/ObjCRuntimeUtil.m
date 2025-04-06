//
//  ObjCRuntimeUtil.m
//  DevelopKit
//
//  Created by janezhuang on 2025/4/5.
//

#import "ObjCRuntimeUtil.h"
#import <objc/runtime.h>

@implementation ObjCRuntimeUtil

- (void)printMethod:(Class)cls {
    NSLog(@"=====Method=====");
    unsigned int methodCount;
    Method *methods = class_copyMethodList(cls, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        NSLog(@"%@", NSStringFromSelector(method_getName(method)));
    }
}

- (void)printProperty:(Class)cls {
    NSLog(@"=====Property=====");
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"%s", property_getName(property));
    }
}

- (void)printVar:(Class)cls {
    NSLog(@"=====iVar=====");
    unsigned int varCount;
    Ivar *vars = class_copyIvarList(cls, &varCount);
    for (int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        NSLog(@"%s", ivar_getName(var));
    }
}

@end
