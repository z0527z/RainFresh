//
//  NSString+Custom.m
//  chat
//
//  Created by dql on 15/3/3.
//  Copyright (c) 2015年 dql. All rights reserved.
//

#import "NSString+Custom.h"

@implementation NSString (Custom)

- (CGSize)sizeForStringwithFont:(UIFont *)font andSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    CGSize retSize = [self boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize;
    
}

@end
