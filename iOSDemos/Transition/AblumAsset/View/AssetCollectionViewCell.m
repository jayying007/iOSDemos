//
//  AssetCollectionViewCell.m
//  Album_StyleC
//
//  Created by janezhuang on 2022/11/15.
//

#import "AssetCollectionViewCell.h"

@interface AssetCollectionViewCell ()

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIImageView *selectedIconView;

@end

@implementation AssetCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];

        [self initContentView];

        _selectedIconView = [[UIImageView alloc] init];
        _selectedIconView.hidden = YES;
        [self.contentView addSubview:_selectedIconView];
    }
    return self;
}

- (void)setData:(UIImage *)data {
    _imageView.image = data;

    [self setNeedsLayout];
}

- (void)setBSelected:(BOOL)bSelected {
    _bSelected = bSelected;
    [self setNeedsLayout];
}

- (void)setBInSelectMode:(BOOL)bInSelectMode {
    _bInSelectMode = bInSelectMode;
    [self setNeedsLayout];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _imageView.frame = self.bounds;
}
#pragma mark - 子类重装
- (void)initContentView {
}

- (void)layoutContentView:(CGRect)rect {
}
#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];

    [_selectedIconView setHighlighted:_bSelected];
    [_selectedIconView setHidden:!_bInSelectMode];

    _imageView.frame = self.bounds;

    CGRect imgDisplayRect = [self getImageDisplayRect];
    [self layoutContentView:imgDisplayRect];
    _selectedIconView.frame = CGRectMake(CGRectGetMaxX(imgDisplayRect) - 22, CGRectGetMinY(imgDisplayRect) + 2, 20, 20);
}

- (BOOL)isAccessibilityElement {
    return YES;
}
#pragma mark -
- (CGRect)getImageDisplayRect {
    if (_imageView.image == nil) {
        return CGRectZero;
    }

    CGSize imgSize = _imageView.image.size;
    CGFloat widthRatio = imgSize.width / _imageView.width;
    CGFloat heightRatio = imgSize.height / _imageView.height;
    if (widthRatio > heightRatio) {
        CGFloat imgHeight = imgSize.height / widthRatio;
        return CGRectMake(0, (_imageView.height - imgHeight) / 2, _imageView.width, imgHeight);
    } else {
        CGFloat imgWidth = imgSize.width / heightRatio;
        return CGRectMake((_imageView.width - imgWidth) / 2, 0, imgWidth, _imageView.height);
    }
}
@end
