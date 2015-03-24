//
//  QLWeiboContentStorage.m
//  chat
//
//  Created by dql on 15/3/24.
//  Copyright (c) 2015年 dql. All rights reserved.
//

#import "QLWeiboContentStorage.h"

//extern NSString * const kPersonPageURLString;
static NSString * const kPersonPageURLString = @"file://PersonViewController";

@implementation QLWeiboContentStorage
{
    NSTextStorage * _textStorage;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)setString:(NSString *)string
{
    if (_string != string) {
        _string = string;
        _string = string.copy;
        
        _textStorage = [self storageWithText:_string];
    }
}

- (NSTextStorage *)storageWithText:(NSString *)text
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] init];
    
    // 检测图片表情，并替换为本地图片显示
    NSString * regexStr = @"d_xiaoku@2x.png";
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:nil];
    __block NSUInteger location = 0;
    [regex enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange matchRange = [result rangeAtIndex:0];
        
        // 普通文字
        NSString *normalSubString = [text substringWithRange:NSMakeRange(location, matchRange.location - location)];
        NSTextStorage *attSubStr = [[NSTextStorage alloc] initWithString:normalSubString];
        [textStorage appendAttributedString:attSubStr];
        location = matchRange.location + matchRange.length;
        
        // 图片
        NSString * subString = [text substringWithRange:matchRange];
        NSTextAttachment * attachment = [[NSTextAttachment alloc] init];
        UIImage * image;
        NSString * filePath = [[NSBundle mainBundle] pathForResource:subString ofType:nil];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            image = [UIImage imageNamed:subString];
        }
        else {
            // 取默认图片;
        }
        attachment.image = image;
        attachment.bounds = CGRectMake(0, -2, 14, 14); // 设置大小
        NSAttributedString * attachmentStr = [NSAttributedString attributedStringWithAttachment:attachment];
        [textStorage appendAttributedString:attachmentStr];

    }];
    
    if (location < text.length) {
        NSRange range = NSMakeRange(location, text.length - location);
        NSString *subStr = [text substringWithRange:range];
        NSTextStorage *attSubStr = [[NSTextStorage alloc] initWithString:subStr];
        [textStorage appendAttributedString:attSubStr];
    }
    
    // 检测 @ 人，添加跳转到个人页的链接
    {
        NSString * textString = textStorage.string;
        regexStr = @"@[^@\\s]+";
        regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:nil];
        
        [regex enumerateMatchesInString:textString options:0 range:NSMakeRange(0, textString.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSRange matchRange = [result rangeAtIndex:0];
            //        NSString * subString = [text substringWithRange:matchRange];
            
            [textStorage addAttribute:NSLinkAttributeName value:kPersonPageURLString range:matchRange];
            
        }];
    }

    // 检测 url 字符，并添加上响应链接，不带前缀的，默认 http
    {
        NSString * textString = textStorage.string;
        regexStr = @"((((http)|(ftp)|(https))://)|)www\\.\\w+\\.[^\\s]{2,}";
        
        regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:nil];
        
        [regex enumerateMatchesInString:textString options:0 range:NSMakeRange(0, textString.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSRange matchRange = [result rangeAtIndex:0];
            NSString * subString = [textString substringWithRange:matchRange];
            NSMutableString * valueString = nil;
            if ([subString hasPrefix:@"http"] | [subString hasPrefix:@"ftp"] | [subString hasPrefix:@"https"]) {
                valueString = subString.mutableCopy;
            }
            else {
                valueString = [NSMutableString string];
                [valueString appendFormat:@"http://%@", subString];
            }
            
            [textStorage addAttribute:NSLinkAttributeName value:valueString range:matchRange];
        }];
    }

    
    return textStorage;

}

@end
