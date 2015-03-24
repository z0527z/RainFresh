//
//  QLWeiboContentView.m
//  chat
//
//  Created by dql on 15/3/24.
//  Copyright (c) 2015年 dql. All rights reserved.
//

#import "QLWeiboContentView.h"
#import "QLWeiboContentLayoutManager.h"

const NSRange kInvalidTouchRange = {.location = NSNotFound, .length = 0};

@implementation QLWeiboContentView
{
    QLWeiboContentLayoutManager * _layoutManager;
    NSTextContainer * _textContainer;
    NSRange _touchRange;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
//        self.userInteractionEnabled = YES;
        
        _layoutManager = [QLWeiboContentLayoutManager new];
        _layoutManager.delegate = self;
        
        CGSize size = CGSizeMake(frame.size.width, CGFLOAT_MAX);
        _textContainer = [[NSTextContainer alloc] initWithSize:size];
        [_layoutManager addTextContainer:_textContainer];
        
        _touchRange = kInvalidTouchRange;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (!_textStorage) return;
    
    NSRange glyphRange = [_layoutManager glyphRangeForTextContainer:_textContainer];
    CGPoint point = [_layoutManager locationForGlyphAtIndex:glyphRange.location];
    float dy = point.y - 5;
    point.y -= dy;
    [_layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:point];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_textContainer) {
        _textContainer.size = frame.size;
    }
}

- (void)setTextStorage:(NSTextStorage *)textStorage
{
    if (_textStorage != textStorage) {
        _textStorage = textStorage;
        [_textStorage addLayoutManager:_layoutManager];
        
        [self setNeedsUpdateConstraints];
        [self setNeedsDisplay];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPoint startPoint = [_layoutManager locationForGlyphAtIndex:0];
    
    location = CGPointMake(location.x - startPoint.x, location.y - startPoint.y);
    CGFloat fraction;
    NSUInteger index = [_layoutManager glyphIndexForPoint:location inTextContainer:_textContainer fractionOfDistanceThroughGlyph:&fraction];
    
    if (0.01 < fraction && fraction < 0.99) {
        NSRange effectiveRange;
        
        id value = [_textStorage attribute:NSLinkAttributeName atIndex:index longestEffectiveRange:&effectiveRange inRange:NSMakeRange(0, _textStorage.length)];
        if (value) {
            _touchRange = effectiveRange;
            _layoutManager.touchRange = _touchRange;
            _layoutManager.isTouched = YES;
            [self setNeedsDisplay];
            
            if ([self.delegate respondsToSelector:@selector(weiboContentView:touchedURLString:)]) {
                [self.delegate weiboContentView:self touchedURLString:value];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self touchesEnded:touches withEvent:event];
            });
            
        }
        else {
            _touchRange = kInvalidTouchRange;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_touchRange.location != NSNotFound) {
        _touchRange = kInvalidTouchRange;
        _layoutManager.isTouched = NO;
        [self setNeedsDisplay];
    }
    
    [super touchesEnded:touches withEvent:event];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGRect rect = [_layoutManager usedRectForTextContainer:_textContainer];
    CGFloat width = ceil(CGRectGetWidth(rect));
    CGFloat height = ceil(CGRectGetHeight(rect)) + 6;
    
    return CGSizeMake(width, height);
}

@end
