//
//  TableViewCell.h
//  chat
//
//  Created by dql on 15/3/19.
//  Copyright (c) 2015年 dql. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboModel;

@interface TableViewCell : UITableViewCell
@property (nonatomic, strong) WeiboModel * model;
@end


@interface WeiboModel : NSObject

@property (nonatomic, strong) NSString * profileImgUrl;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * place;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) NSArray * images;
@property (nonatomic, strong) NSString * mark;
//@property (nonatomic, strong) WeiboModel * reveal;


- (instancetype)initWithDict:(NSDictionary *)dict;

@end