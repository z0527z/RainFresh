//
//  QLLabel.m
//  chat
//
//  Created by dql on 15/3/3.
//  Copyright (c) 2015年 dql. All rights reserved.
//

#import "QLLabel.h"
#import "NSString+Custom.h"

@implementation QLLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
//    NSLog(@"text:%@, rect:%@", self.attributedText, NSStringFromCGRect(rect));
//    
//    NSString * normalString = [self.text substringToIndex:5];
//    CGSize size = [normalString sizeForStringwithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]] andSize:rect.size];
//    float width = ceilf(size.width);
//    float height = ceilf(size.height);
//    [normalString drawInRect:CGRectMake(0, 0, width, height) withAttributes:nil];
    
}




@end
