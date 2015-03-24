//
//  QLWeiboContentView.h
//  chat
//
//  Created by dql on 15/3/24.
//  Copyright (c) 2015年 dql. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLWeiboContentStorage.h"

@protocol QLWeiboContentViewDelegate <NSObject>

- (void)weiboContentView:(UIView *)view touchedURLString:(NSString *)urlString;

@end

@interface QLWeiboContentView : UIView <NSLayoutManagerDelegate>
@property (nonatomic, assign) id <QLWeiboContentViewDelegate> delegate;
@property (nonatomic, strong) NSTextStorage * textStorage;

@end
