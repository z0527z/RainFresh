//
//  QLWeiboContentLayoutManager.m
//  chat
//
//  Created by dql on 15/3/24.
//  Copyright (c) 2015年 dql. All rights reserved.
//

#import "QLWeiboContentLayoutManager.h"

@implementation QLWeiboContentLayoutManager

- (instancetype)init
{
    if (self = [super init]) {
        _touchRange = kInvalidTouchRange;
        _isTouched = NO;
    }
    
    return self;
}

- (void)drawUnderlineForGlyphRange:(NSRange)glyphRange underlineType:(NSUnderlineStyle)underlineVal baselineOffset:(CGFloat)baselineOffset lineFragmentRect:(CGRect)lineRect lineFragmentGlyphRange:(NSRange)lineGlyphRange containerOrigin:(CGPoint)containerOrigin
{
    // 找到带下划线文字的起点和终点，绘制链接背景
    CGFloat startX = [self locationForGlyphAtIndex:glyphRange.location].x;
    CGFloat endX;
    
    if (NSMaxRange(glyphRange) < NSMaxRange(lineGlyphRange)) {
        endX = [self locationForGlyphAtIndex:NSMaxRange(glyphRange)].x;
    }
    else {
        endX = [self lineFragmentUsedRectForGlyphAtIndex:NSMaxRange(glyphRange) - 1 effectiveRange:NULL].size.width;
    }
    
    lineRect.origin.x += startX;
    lineRect.size.width = endX - startX;
    lineRect.size.height = lineRect.size.height;
    
    lineRect.origin.x += containerOrigin.x;
    lineRect.origin.y += containerOrigin.y;
    
    lineRect = CGRectInset(CGRectIntegral(lineRect), 0.5, 0.5);
    
    NSRange tmpRange = NSIntersectionRange(_touchRange, glyphRange);
    if (_isTouched && tmpRange.length) {
        [[UIColor lightGrayColor] set];
    }
    else {
        [[UIColor whiteColor] set];
    }
    
    [[UIBezierPath bezierPathWithRect:lineRect] fill];
}

@end
