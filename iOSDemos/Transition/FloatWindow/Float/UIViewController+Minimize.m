//
//  UIViewController+Minimize.m
//  FloatWindow
//
//  Created by janezhuang on 2022/5/22.
//

#import "UIViewController+Minimize.h"
#import "FloatTransitionMgr.h"
#import "FloatWindowMgr.h"

@implementation UIViewController (Minimize)
- (void)installMinimize:(NSString *)text {
    [Service(FloatTransitionMgr) setUseInteraction:NO];

    UIScreenEdgePanGestureRecognizer *edgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                                         action:@selector(handleEdgePanGesture:)];
    edgePanGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePanGesture];

    [Service(FloatWindowMgr) setText:text];
}

- (void)handleEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePanGesture {
    if (edgePanGesture.state == UIGestureRecognizerStateBegan) {
        [Service(FloatTransitionMgr) setUseInteraction:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [Service(FloatTransitionMgr) handleEdgePanGesture:edgePanGesture];
    }
}
@end
