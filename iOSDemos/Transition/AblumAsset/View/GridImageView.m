//
//  GridImageView.m
//  MicroMessenger
//
//  Created by janezhuang on 2022/11/8.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "GridImageView.h"
#import "UIView+Frame.h"

@interface GridImageView ()
@property (nonatomic) NSMutableArray *imageViews;
@end

@implementation GridImageView

- (instancetype)initWithImages:(NSArray *)images {
    self = [super init];
    if (self) {
        self.imageViews = [NSMutableArray array];
        for (int i = 0; i < MIN(images.count, 9); i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:images[i]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [self.imageViews addObject:imageView];
            [self addSubview:imageView];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    NSArray *imagesRect = [self getImagesRect];
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView *imageView = self.imageViews[i];
        imageView.frame = [imagesRect[i] CGRectValue];
    }
}

/// 根据图片数量，返回每张图片的位置信息
- (NSArray *)getImagesRect {
    int count = (int)self.imageViews.count;
    int margin = 1;
    switch (count) {
        case 0:
        case 1:
            return @[ @(CGRectMake(0, 0, self.width, self.height)) ];
        case 2: {
            CGFloat itemWidth = (self.width - margin) / 2;
            CGFloat itemHeight = self.height;
            return @[ @(CGRectMake(0, 0, itemWidth, itemHeight)), @(CGRectMake(itemWidth + margin, 0, itemWidth, itemHeight)) ];
        }
        case 3: {
            CGFloat row1ItemWidth = (self.width - margin) / 2;
            CGFloat itemHeight = (self.height - margin) / 2;
            return @[
                @(CGRectMake(0, 0, row1ItemWidth, itemHeight)),
                @(CGRectMake(row1ItemWidth + margin, 0, row1ItemWidth, itemHeight)),
                @(CGRectMake(0, itemHeight + margin, self.width, itemHeight))
            ];
        }
        case 4: {
            CGFloat itemWidth = (self.width - margin) / 2;
            CGFloat itemHeight = (self.height - margin) / 2;
            return @[
                @(CGRectMake(0, 0, itemWidth, itemHeight)),
                @(CGRectMake(itemWidth + margin, 0, itemWidth, itemHeight)),
                @(CGRectMake(0, itemHeight + margin, itemWidth, itemHeight)),
                @(CGRectMake(itemWidth + margin, itemHeight + margin, itemWidth, itemHeight))
            ];
        }
        case 5: {
            CGFloat row1ItemWidth = (self.width - margin * 2) / 3;
            CGFloat itemHeight = (self.height - margin) / 2;
            return @[
                @(CGRectMake(0, 0, row1ItemWidth, itemHeight)),
                @(CGRectMake(row1ItemWidth + margin, 0, row1ItemWidth, itemHeight)),
                @(CGRectMake((row1ItemWidth + margin) * 2, 0, row1ItemWidth, itemHeight)),
                @(CGRectMake(0, itemHeight + margin, row1ItemWidth, itemHeight)),
                @(CGRectMake(row1ItemWidth + margin, itemHeight + margin, self.width - row1ItemWidth - margin, itemHeight))
            ];
        }
        case 6: {
            CGFloat itemWidth = (self.width - margin * 2) / 3;
            CGFloat itemHeight = (self.height - margin) / 2;
            return @[
                @(CGRectMake(0, 0, itemWidth, itemHeight)),
                @(CGRectMake(itemWidth + margin, 0, itemWidth, itemHeight)),
                @(CGRectMake((itemWidth + margin) * 2, 0, itemWidth, itemHeight)),
                @(CGRectMake(0, itemHeight + margin, itemWidth, itemHeight)),
                @(CGRectMake(itemWidth + margin, itemHeight + margin, itemWidth, itemHeight)),
                @(CGRectMake((itemWidth + margin) * 2, itemHeight + margin, itemWidth, itemHeight))
            ];
        }
        case 7: {
            CGFloat row12ItemWidth = (self.width - margin * 2) / 3;
            CGFloat itemHeight = (self.height - margin * 2) / 3;
            return @[
                @(CGRectMake(0, 0, row12ItemWidth, itemHeight)),
                @(CGRectMake(row12ItemWidth + margin, 0, row12ItemWidth, itemHeight)),
                @(CGRectMake((row12ItemWidth + margin) * 2, 0, row12ItemWidth, itemHeight)),
                @(CGRectMake(0, itemHeight + margin, row12ItemWidth, itemHeight)),
                @(CGRectMake(row12ItemWidth + margin, itemHeight + margin, row12ItemWidth, itemHeight)),
                @(CGRectMake((row12ItemWidth + margin) * 2, itemHeight + margin, row12ItemWidth, itemHeight)),
                @(CGRectMake(0, (itemHeight + margin) * 2, self.width, itemHeight))
            ];
        }
        case 8: {
            CGFloat row12ItemWidth = (self.width - margin * 2) / 3;
            CGFloat itemHeight = (self.height - margin * 2) / 3;
            return @[
                @(CGRectMake(0, 0, row12ItemWidth, itemHeight)),
                @(CGRectMake(row12ItemWidth + margin, 0, row12ItemWidth, itemHeight)),
                @(CGRectMake((row12ItemWidth + margin) * 2, 0, row12ItemWidth, itemHeight)),
                @(CGRectMake(0, itemHeight + margin, row12ItemWidth, itemHeight)),
                @(CGRectMake(row12ItemWidth + margin, itemHeight + margin, row12ItemWidth, itemHeight)),
                @(CGRectMake((row12ItemWidth + margin) * 2, itemHeight + margin, row12ItemWidth, itemHeight)),
                @(CGRectMake(0, (itemHeight + margin) * 2, row12ItemWidth, itemHeight)),
                @(CGRectMake(row12ItemWidth + margin, (itemHeight + margin) * 2, self.width - row12ItemWidth - margin, itemHeight))
            ];
        }
        case 9:
        default: {
            CGFloat itemWidth = (self.width - margin * 2) / 3;
            CGFloat itemHeight = (self.height - margin * 2) / 3;
            return @[
                @(CGRectMake(0, 0, itemWidth, itemHeight)),
                @(CGRectMake(itemWidth + margin, 0, itemWidth, itemHeight)),
                @(CGRectMake((itemWidth + margin) * 2, 0, itemWidth, itemHeight)),
                @(CGRectMake(0, itemHeight + margin, itemWidth, itemHeight)),
                @(CGRectMake(itemWidth + margin, itemHeight + margin, itemWidth, itemHeight)),
                @(CGRectMake((itemWidth + margin) * 2, itemHeight + margin, itemWidth, itemHeight)),
                @(CGRectMake(0, (itemHeight + margin) * 2, itemWidth, itemHeight)),
                @(CGRectMake(itemWidth + margin, (itemHeight + margin) * 2, itemWidth, itemHeight)),
                @(CGRectMake((itemWidth + margin) * 2, (itemHeight + margin) * 2, itemWidth, itemHeight))
            ];
        }
    }
    return nil;
}
@end
