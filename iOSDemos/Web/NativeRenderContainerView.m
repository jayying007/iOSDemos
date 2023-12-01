//
//  NativeRenderContainerView.m
//  iOSDemos
//
//  Created by janezhuang on 2023/12/1.
//

#import "NativeRenderContainerView.h"

@implementation NativeRenderContainerView

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    if (aProtocol == NSProtocolFromString(@"WKNativelyInteractible")) {
        return YES;
    }
    return [super conformsToProtocol:aProtocol];
}

@end
