//
//  PopInteraction.h
//  FloatWindow
//
//  Created by janezhuang on 2022/5/21.
//

#import <UIKit/UIKit.h>

@interface PopInteraction : UIPercentDrivenInteractiveTransition
- (void)handleEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePanGesture;
@end
