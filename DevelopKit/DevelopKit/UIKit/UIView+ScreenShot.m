//
//  UIView+ScreenShot.m
//  DevelopKit
//
//  Created by janezhuang on 2025/4/6.
//

#import "UIView+ScreenShot.h"
#import <objc/runtime.h>

const char *kForbidScreenShotKey = "forbidScreenShot";
const int kSecureViewTag = 10086;

@implementation UIView (ScreenShot)

+ (void)load {
    Method m1 = class_getInstanceMethod(self, @selector(didMoveToSuperview));
    Method m2 = class_getInstanceMethod(self, @selector(mm_didMoveToSuperview));
    method_exchangeImplementations(m1, m2);
}

- (void)setForbidScreenShot:(BOOL)flag {
    objc_setAssociatedObject(self, kForbidScreenShotKey, @(flag), OBJC_ASSOCIATION_ASSIGN);
    flag ? [self insertSecureViewIfNeed] : [self removeSecureViewIfNeed];
}

- (void)mm_didMoveToSuperview {
    [self mm_didMoveToSuperview];
    BOOL flag = [objc_getAssociatedObject(self, kForbidScreenShotKey) boolValue];
    flag ? [self insertSecureViewIfNeed] : nil;
}

- (void)insertSecureViewIfNeed {
    if (self.superview == nil) {
        return;
    }

    if (self.superview.tag == kSecureViewTag) {
        return;
    }

    UITextField *textField = [[UITextField alloc] init];
    textField.secureTextEntry = YES;
    UIView *secureView = textField.subviews.firstObject;
    secureView.frame = UIScreen.mainScreen.bounds;
    secureView.tag = kSecureViewTag;
    // find the index to insert
    UIView *nextView = nil;
    NSArray *subViews = self.superview.subviews;
    for (int i = 0; i < subViews.count; i++) {
        UIView *view = subViews[i];
        if (view == self && i < subViews.count - 1) {
            nextView = subViews[i + 1];
            break;
        }
    }
    if (nextView) {
        [self.superview insertSubview:secureView belowSubview:nextView];
    } else {
        [self.superview addSubview:secureView];
    }
    [secureView addSubview:self];
}

- (void)removeSecureViewIfNeed {
    if (self.superview.tag != kSecureViewTag) {
        return;
    }

    // find the index to insert
    UIView *secureView = self.superview;
    UIView *nextView = nil;
    NSArray *subViews = secureView.superview.subviews;
    for (int i = 0; i < subViews.count; i++) {
        UIView *view = subViews[i];
        if (view == secureView && i < subViews.count - 1) {
            nextView = subViews[i + 1];
            break;
        }
    }
    if (nextView) {
        [secureView.superview insertSubview:self belowSubview:nextView];
    } else {
        [secureView.superview addSubview:self];
    }
    [secureView removeFromSuperview];
}

@end
