//
//  UiUtil.m
//  iOSDemos
//
//  Created by janezhuang on 2023/12/3.
//

#import "UiUtil.h"

@implementation UiUtil

+ (UIWindow *)mainWindow {
    let scene = [self mainScene];
    return [(id<UIWindowSceneDelegate>)[(UIWindowScene *)scene delegate] window];
}

+ (UIWindowScene *)mainScene {
    let scenes = [UIApplication sharedApplication].connectedScenes;
    for (UIScene *scene in scenes) {
        if ([scene isKindOfClass:UIWindowScene.class]) {
            return (UIWindowScene *)scene;
        }
    }
    return nil;
}

@end
