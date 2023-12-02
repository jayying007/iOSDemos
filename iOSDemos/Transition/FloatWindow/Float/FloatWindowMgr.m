//
//  FloatWindowMgr.m
//  FloatWindow
//
//  Created by janezhuang on 2022/5/21.
//

#import "FloatWindowMgr.h"
#import "FloatDetailViewController.h"
#import "FloatButton.h"
#import "FloatFan.h"

@interface FloatWindowMgr () <FloatButtonDelegate, FloatFanDelegate>
@property (nonatomic) FloatButton *floatBtn;
@property (nonatomic) FloatFan *floatFan;
@property (nonatomic) BOOL bInFloatFan;
@property (nonatomic) NSString *realText;
@end

@implementation FloatWindowMgr
- (instancetype)init {
    self = [super init];
    if (self) {
        weakify(self);
        [[NSNotificationCenter defaultCenter] addObserverForName:kFinishInteraction
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *_Nonnull note) {
                                                          strongify(self);
                                                          if (self == nil) {
                                                              return;
                                                          }
                                                          if (self.bInFloatFan) {
                                                              self.realText = self->_text;
                                                              self.floatBtn.hidden = NO;
                                                          }
                                                      }];
        [[NSNotificationCenter defaultCenter] addObserverForName:kGestureEnd
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *_Nonnull note) {
                                                          [self hideFloatFan];
                                                      }];
        NSLog(@"init %@", self.floatFan);
    }
    return self;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static FloatWindowMgr *instance;
    dispatch_once(&onceToken, ^{
        instance = [[FloatWindowMgr alloc] init];
    });
    return instance;
}

- (FloatButton *)floatBtn {
    if (_floatBtn == nil) {
        _floatBtn = [[FloatButton alloc] initWithFrame:CGRectMake(8, WINDOW.height * 0.6, 64, 64)];
        _floatBtn.delegate = self;
        [WINDOW addSubview:_floatBtn];
    }
    return _floatBtn;
}

- (FloatFan *)floatFan {
    if (_floatFan == nil) {
        _floatFan = [[FloatFan alloc] initWithFrame:CGRectMake(WINDOW.width, WINDOW.height, 160, 160)];
        _floatFan.delegate = self;
        [WINDOW addSubview:_floatFan];

        [[NSNotificationCenter defaultCenter] addObserverForName:kGestureChangePercent
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *_Nonnull note) {
                                                          NSNumber *number = note.userInfo[@"percent"];
                                                          CGFloat percent = [number doubleValue];
                                                          [self updateFloatFanPercent:percent];
                                                      }];
    }
    return _floatFan;
}

- (NSString *)text {
    if (_realText.length > 0) {
        return _realText;
    }
    return _text;
}
#pragma mark -
- (void)hideFloatFan {
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.floatFan.origin = CGPointMake(WINDOW.width, WINDOW.height);
                     }];
}

- (void)updateFloatFanPercent:(CGFloat)percent {
    CGFloat x = percent * self.floatFan.width * 2;
    x = MAX(WINDOW.width - x, WINDOW.width - self.floatFan.width);
    CGFloat y = percent * self.floatFan.height * 2;
    y = MAX(WINDOW.height - y, WINDOW.height - self.floatFan.height);
    self.floatFan.origin = CGPointMake(x, y);
}
#pragma mark - delegate * notification
- (void)handleTapFloatButton {
    //这里需要获取最上层的ViewController，简单处理
    FloatDetailViewController *vc = [[FloatDetailViewController alloc] initWithText:Service(FloatWindowMgr).text];
    [(UINavigationController *)WINDOW.rootViewController pushViewController:vc animated:YES];

    self.floatBtn.hidden = YES;
}

- (void)onFocusChange:(BOOL)focus {
    self.bInFloatFan = focus;
}
@end
