//
//  QLWeiboContentStorage.h
//  chat
//
//  Created by dql on 15/3/24.
//  Copyright (c) 2015年 dql. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLWeiboContentStorage : NSObject

@property (nonatomic, strong) NSString * string;

- (NSTextStorage *)storageWithText:(NSString *)text;

@end
