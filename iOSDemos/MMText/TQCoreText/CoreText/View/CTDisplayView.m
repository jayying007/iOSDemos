//
//  CTDisplayView.m
//  TQCoreText
//
//  Created by janezhuang on 2022/7/9.
//

#import "CTDisplayView.h"
#import "CoreTextImageData.h"
#import "CoreTextUtils.h"

NSString *const CTDisplayViewImagePressedNotification = @"CTDisplayViewImagePressedNotification";
NSString *const CTDisplayViewLinkPressedNotification = @"CTDisplayViewLinkPressedNotification";

@interface CTDisplayView () <UIGestureRecognizerDelegate> {
}
@end

@implementation CTDisplayView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapGestureDetected:)];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    //翻转坐标系
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    if (self.data) {
        CTFrameDraw(self.data.ctFrame, context);
    }

    for (CoreTextImageData *imageData in self.data.imageArray) {
        UIImage *image = [UIImage imageNamed:imageData.name];
        if (image) {
            CGContextDrawImage(context, imageData.imagePosition, image.CGImage);
        }
    }
}

- (void)userTapGestureDetected:(UIGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
    for (CoreTextImageData *imageData in self.data.imageArray) {
        // 翻转坐标系，因为imageData中的坐标是CoreText的坐标系
        CGRect imageRect = imageData.imagePosition;
        CGPoint imagePosition = imageRect.origin;
        imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
        // 检测点击位置 Point 是否在rect之内
        if (CGRectContainsPoint(rect, point)) {
            NSLog(@"hint image");
            // 在这里处理点击后的逻辑
            NSDictionary *userInfo = @{ @"imageData" : imageData };
            [[NSNotificationCenter defaultCenter] postNotificationName:CTDisplayViewImagePressedNotification object:self userInfo:userInfo];
            return;
        }
    }

    CoreTextLinkData *linkData = [CoreTextUtils touchLinkInView:self atPoint:point data:self.data];
    if (linkData) {
        NSLog(@"hint link!");
        NSDictionary *userInfo = @{ @"linkData" : linkData };
        [[NSNotificationCenter defaultCenter] postNotificationName:CTDisplayViewLinkPressedNotification object:self userInfo:userInfo];
        return;
    }
}
@end
