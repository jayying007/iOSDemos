//
//  ObjCRuntimeUtil.h
//  DevelopKit
//
//  Created by janezhuang on 2025/4/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjCRuntimeUtil : NSObject

- (void)printMethod:(Class)cls;
- (void)printProperty:(Class)cls;
- (void)printVar:(Class)cls;

@end

NS_ASSUME_NONNULL_END
