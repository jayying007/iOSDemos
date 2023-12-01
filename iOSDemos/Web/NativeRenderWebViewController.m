//
//  NativeRenderWebViewController.m
//  iOSDemos
//
//  Created by janezhuang on 2023/12/1.
//

#import "NativeRenderWebViewController.h"
#import "NativeRenderContainerView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

@interface NativeRenderWebViewController () <WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation NativeRenderWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    [_webView.configuration.userContentController addScriptMessageHandler:self name:@"nativeViewHandler"];
    NSString *html = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];
    [_webView loadHTMLString:html baseURL:nil];
    [self.view addSubview:_webView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self handleGestrues];
    });
}

- (void)handleGestrues {
    UIScrollView *webViewScrollView = self.webView.scrollView;
    if ([webViewScrollView isKindOfClass:NSClassFromString(@"WKScrollView")]) {
        UIView *_WKContentView = webViewScrollView.subviews.firstObject;
        if (![_WKContentView isKindOfClass:NSClassFromString(@"WKContentView")]) {
            return;
        }
        NSArray *gestrues = _WKContentView.gestureRecognizers;
        for (UIGestureRecognizer *gesture in gestrues) {
            gesture.cancelsTouchesInView = NO;
            gesture.delaysTouchesBegan = NO;
            gesture.delaysTouchesEnded = NO;
        }
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self insertNativeView:message];
}

- (void)insertNativeView:(WKScriptMessage *)message {
    NSDictionary *params = message.body[@"args"];
    NSLog(@"%@", params);

    UIView *v = [self findView:self.webView str:@"" ids:params[@"id"]];
    UIView *parentView = nil;
    // 查目标容器
    for (UIView *sub in v.subviews) {
        if ([sub isKindOfClass:NSClassFromString(@"WKChildScrollView")]) {
            parentView = sub;
            break;
        }
    }

    // 这里创建一个UILabel 做演示
    NativeRenderContainerView *containerView = [[NativeRenderContainerView alloc] init];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, v.frame.size.width, 100)];
    label.backgroundColor = UIColor.orangeColor;
    label.font = [UIFont systemFontOfSize:40];
    label.text = [NSString stringWithFormat:@"组件ID为：%@的原生同层组件", params[@"id"]];
    label.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:label];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"按钮" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 200, v.frame.size.width, 100);
    button.titleLabel.font = [UIFont systemFontOfSize:40];
    [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:button];

    if (parentView) {
        containerView.frame = parentView.bounds;
        [parentView addSubview:containerView];
    }
}

- (UIView *)findView:(UIView *)root str:(NSString *)pre ids:(NSString *)ids {
    if (!root) {
        return nil;
    }
    NSLog(@"%@%@,%@", pre, root.class, root.layer.name);
    if ([root.layer.name containsString:[NSString stringWithFormat:@"id='%@'", ids]]) {
        return root;
    }

    for (UIView *v in root.subviews) {
        UIView *res = [self findView:v str:[NSString stringWithFormat:@"%@ - ", pre] ids:ids];
        if (res) {
            return res;
        }
    }
    return nil;
}

- (void)clickButton {
    NSLog(@"点我呢");
}

@end
