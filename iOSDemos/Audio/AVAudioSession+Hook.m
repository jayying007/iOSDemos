//
//  AVAudioSession+Hook.m
//  Audio
//
//  Created by janezhuang on 2022/10/23.
//

#import "AVAudioSession+Hook.h"
#import <objc/runtime.h>

@implementation AVAudioSession (Hook)
+ (void)load {
    Method m1 = class_getInstanceMethod(AVAudioSession.class, @selector(setActive:error:));
    Method m2 = class_getInstanceMethod(AVAudioSession.class, @selector(mm_setActive:error:));
    method_exchangeImplementations(m1, m2);

    Method m3 = class_getInstanceMethod(AVAudioSession.class, @selector(setActive:withOptions:error:));
    Method m4 = class_getInstanceMethod(AVAudioSession.class, @selector(mm_setActive:withOptions:error:));
    method_exchangeImplementations(m3, m4);
}

- (BOOL)mm_setActive:(BOOL)active error:(NSError *__autoreleasing _Nullable *)outError {
    AudioInfo(@"%s, active:%d", __func__, active);
    return [self mm_setActive:active error:outError];
}

- (BOOL)mm_setActive:(BOOL)active withOptions:(AVAudioSessionSetActiveOptions)options error:(NSError *__autoreleasing _Nullable *)outError {
    AudioInfo(@"%s, active:%d, options:%lu", __func__, active, options);
    return [self mm_setActive:active withOptions:options error:outError];
}
@end
