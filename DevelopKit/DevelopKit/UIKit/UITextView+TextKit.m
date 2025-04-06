//
//  UITextView+TextKit.m
//  DevelopKit
//
//  Created by janezhuang on 2025/4/6.
//

#import "UITextView+TextKit.h"

@implementation UITextView (TextKit)

- (CGPoint)lastCharacterPosition {
    NSLayoutManager *layoutManager = self.layoutManager;
    NSUInteger characterIndex = self.textStorage.length - 1;
    NSUInteger glyphIndex = [layoutManager glyphIndexForCharacterAtIndex:characterIndex];

    CGRect rect = [layoutManager lineFragmentRectForGlyphAtIndex:glyphIndex effectiveRange:NULL];
    CGPoint glyphLocation = [layoutManager locationForGlyphAtIndex:glyphIndex];
    glyphLocation.x += CGRectGetMinX(rect);
    glyphLocation.y += CGRectGetMinY(rect);

    return glyphLocation;
}

- (NSInteger)numberOfLines {
    NSLayoutManager *layoutManager = self.layoutManager;
    NSTextContainer *textContainer = self.textContainer;

    CGFloat lastOriginY = -1.0;
    NSUInteger numberOfLines = 0;
    NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];

    NSRange lineRange = NSMakeRange(0, 0);
    while (lineRange.location < NSMaxRange(glyphRange)) {
        CGRect rect = [layoutManager lineFragmentRectForGlyphAtIndex:lineRange.location effectiveRange:&lineRange];
        if (CGRectGetMinY(rect) > lastOriginY)
            ++numberOfLines;
        lastOriginY = CGRectGetMinY(rect);
        lineRange.location = NSMaxRange(lineRange);
    }

    return numberOfLines;
}

- (NSArray *)linesInfo {
    NSMutableArray *result = [[NSMutableArray alloc] init];

    NSLayoutManager *layoutManager = [self layoutManager];

    int numberOfLines = 0;
    NSUInteger stringLength = [self.text length];

    for (NSUInteger index = 0; index < stringLength; numberOfLines++) {
        NSRange range;
        CGRect rect = [layoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&range];

        [result addObject:@{ @"range" : [NSValue valueWithRange:range], @"frame" : [NSValue valueWithCGRect:rect] }];
        index = NSMaxRange(range);
    }

    return result;
}

@end
