//
//  QLTextStorage.m
//  chat
//
//  Created by dql on 15/3/23.
//  Copyright (c) 2015年 dql. All rights reserved.
//

#import "QLTextStorage.h"

@implementation QLTextStorage
{
    NSMutableAttributedString * _storeString;
}

- (instancetype)init
{
    if (self = [super init]) {
        _storeString = [NSMutableAttributedString new];
    }
    
    return self;
}

- (NSString *)string
{
    return [_storeString string];
}


- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_storeString attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    NSLog(@"replaceCharactersInRange:%@ withString:%@", NSStringFromRange(range), str);
    
    [self beginEditing];
    [_storeString replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedAttributes | NSTextStorageEditedCharacters range:range changeInLength:str.length - range.length];
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    NSLog(@"setAttributes:%@ range:%@", attrs, NSStringFromRange(range));
    
    [self beginEditing];
    [_storeString setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes | NSTextStorageEditedCharacters range:range changeInLength:0];
    [self endEditing];
}


- (void)processEditing
{
    [self performReplacementsForRange:[self editedRange]];
    [super processEditing];
}

- (void)performReplacementsForRange:(NSRange)changedRange
{
    NSRange extendedRange = NSUnionRange(changedRange, [[_storeString string] lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(changedRange, [[_storeString string] lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    
    [self applyStylesToRange:extendedRange];
}

- (void)applyStylesToRange:(NSRange)searchRange
{

    UIFont * normalFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    NSString * regexStr = @"@[^@\\s]+";
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:nil];
    NSDictionary * colorAttributes = @{NSForegroundColorAttributeName : [UIColor greenColor]};
    NSDictionary * normalAttributes = @{NSFontAttributeName : normalFont};
    
    
    [regex enumerateMatchesInString:[_storeString string] options:0 range:searchRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange matchRange = [result rangeAtIndex:0];
        NSString * subString = [_storeString.string substringWithRange:matchRange];

        [self addAttributes:colorAttributes range:matchRange];
        
//        if (NSMaxRange(matchRange) + 1 < self.length) {
//            [self addAttributes:normalAttributes range:NSMakeRange(NSMaxRange(matchRange) + 1, 1)];
//        }
    }];
}

@end
