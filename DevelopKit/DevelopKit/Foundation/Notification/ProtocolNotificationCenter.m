//
//  ProtocolNotificationCenter.m
//  ProtocolNotificationCenter
//
//  Created by janezhuang on 2023/2/24.
//

#import "ProtocolNotificationCenter.h"

@interface _ObserverObject : NSObject
@property (nonatomic, unsafe_unretained, readonly) id obj;
- (instancetype)initWithObj:(id)obj;
@end

@implementation _ObserverObject
- (instancetype)initWithObj:(id)obj {
    self = [super init];
    if (self) {
        _obj = obj;
    }
    return self;
}

- (BOOL)isEqual:(_ObserverObject *)object {
    if (_obj == nil || object.obj == nil) {
        return NO;
    }
    return _obj == object.obj;
}
@end


@interface ProtocolNotificationCenter () {
    NSMutableDictionary *m_protocolToObserver;
}
@end

@implementation ProtocolNotificationCenter
+ (instancetype)defaultCenter {
    static ProtocolNotificationCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ProtocolNotificationCenter alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        m_protocolToObserver = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addObserver:(id)observer protocol:(Protocol *)protocol {
    if ([observer conformsToProtocol:protocol] == NO) {
        return;
    }
    
    NSString *protocolName = NSStringFromProtocol(protocol);
    NSMutableArray *observerList = [m_protocolToObserver objectForKey:protocolName];
    if (observerList == nil) {
        observerList = [NSMutableArray array];
        [m_protocolToObserver setObject:observerList forKey:protocolName];
    }
    
    _ObserverObject *observerObj = [[_ObserverObject alloc] initWithObj:observer];
    if ([observerList containsObject:observerObj] == NO) {
        [observerList addObject:observerObj];
    }
}

- (void)removeObserver:(id)observer protocol:(Protocol *)protocol {
    NSString *protocolName = NSStringFromProtocol(protocol);
    NSMutableArray *observerList = [m_protocolToObserver objectForKey:protocolName];
    
    _ObserverObject *observerObj = [[_ObserverObject alloc] initWithObj:observer];
    [observerList removeObject:observerObj];
}

- (void)postNotification:(Protocol *)protocol selector:(SEL)selector action:(void (^)(id observer))action {
    NSString *protocolName = NSStringFromProtocol(protocol);
    NSArray *observerList = [[m_protocolToObserver objectForKey:protocolName] copy];
    
    for (_ObserverObject *observerObj in observerList) {
        id observer = observerObj.obj;
        if (observer == nil) {
            continue;
        }
        if ([observer respondsToSelector:selector] == NO) {
            continue;
        }
        action(observer);
    }
}
@end
