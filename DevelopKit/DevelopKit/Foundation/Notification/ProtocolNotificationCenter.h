//
//  ProtocolNotificationCenter.h
//  ProtocolNotificationCenter
//
//  Created by janezhuang on 2023/2/24.
//

#import <Foundation/Foundation.h>

#define ADD_OBSERVER(obj, protocolName) \
    [[ProtocolNotificationCenter defaultCenter] addObserver:obj protocol:@protocol(protocolName)]

#define REMOVE_OBSERVER(obj, protocolName) \
    [[ProtocolNotificationCenter defaultCenter] removeObserver:obj protocol:@protocol(protocolName)]

#define POST_NOTIFICATION(protocolName, sel, method) \
    [[ProtocolNotificationCenter defaultCenter] postNotification:@protocol(protocolName) selector:sel action:^(id _Nonnull observer) { [observer method]; }]

/*
 ```objc
 @protocol ExampleNotification <NSObject>
 - (void)receiveNewNotify:(NSString *)param1 param2:(NSString *)param2 param3:(int)param3;
 @end

 @interface Dog : NSObject <ExampleNotification>
 @end

 @implementation Dog
 - (instancetype)init {
     self = [super init];
     if (self) {
         ADD_OBSERVER(self, ExampleNotification);
     }
     return self;
 }

 - (void)dealloc {
     REMOVE_OBSERVER(self, ExampleNotification);
 }

 - (void)receiveNewNotify:(NSString *)param1 param2:(NSString *)param2 param3:(int)param3 {
     NSLog(@"dog %@ %@ %d", param1, param2, param3);
 }
 @end
 ```
 then post notification
 ```objc
 POST_NOTIFICATION(ExampleNotification, @selector(receiveNewNotify:param2:param3:), receiveNewNotify:@"hello" param2:@"world" param3:404);
 ```
 */
@interface ProtocolNotificationCenter : NSObject

+ (instancetype)defaultCenter;

- (void)addObserver:(id)observer protocol:(Protocol *)protocol;
- (void)removeObserver:(id)observer protocol:(Protocol *)protocol;
- (void)postNotification:(Protocol *)protocol selector:(SEL)selector action:(void(^)(id observer))action;

@end
