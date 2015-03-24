//
//  QLWeiboContentLayoutManager.h
//  chat
//
//  Created by dql on 15/3/24.
//  Copyright (c) 2015年 dql. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const NSRange kInvalidTouchRange;

@interface QLWeiboContentLayoutManager : NSLayoutManager

@property (nonatomic, assign) NSRange touchRange;
@property (nonatomic, assign) BOOL isTouched;

@end
