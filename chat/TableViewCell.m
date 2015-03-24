//
//  TableViewCell.m
//  chat
//
//  Created by dql on 15/3/19.
//  Copyright (c) 2015年 dql. All rights reserved.
//

#import "TableViewCell.h"
#import "SDPhotoBrowser.h"

@interface TableViewCell () <SDPhotoBrowserDelegate, UITextViewDelegate>
{
    UITextView * _textView;
    BOOL _contentLoaded;
}
@end

@implementation TableViewCell
{
    NSString * content;
    UIImage * image;
    NSString * linkStr;
}

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = [UIColor lightGrayColor];
        
        UITextView * textView = [[UITextView alloc] init];
        _textView = textView;
        textView.delegate = self;
        textView.editable = NO;
        textView.dataDetectorTypes = UIDataDetectorTypeAll;
        [self addSubview:textView];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [_model.name drawAtPoint:CGPointMake(54, 15) withAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16.0f]}];
    
    [_model.time drawAtPoint:CGPointMake(54, 15 + 16 + 2) withAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    
    CGSize size = [_model.time sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16.0f]}];
    
    [_model.place drawAtPoint:CGPointMake(54 + ceil(size.width), 33) withAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    
//    NSString * str = @"没有你替我呼吸";
//    [str drawAtPoint:CGPointMake(15, 15 + 32 + 7) withAttributes: @{NSFontAttributeName : [UIFont systemFontOfSize:16.f]}];
//    
//    linkStr = @"我连命都活不";
//    
//    [linkStr drawAtPoint:CGPointMake(15, 15 + 32 + 7 + 2 + 16) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f], NSForegroundColorAttributeName: [UIColor greenColor], NSBackgroundColorAttributeName : [UIColor lightGrayColor]}];
    
//    [image drawAtPoint:CGPointMake(10, 30) blendMode:kCGBlendModeNormal alpha:1.0];
//    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
//    CGContextMoveToPoint(context, 20, 30);
//    CGContextAddLineToPoint(context, 200, 30);
//    CGContextStrokePath(context);
    
}

- (void)layoutSubviews
{

    if (!_contentLoaded) {
        _contentLoaded = YES;
        
        NSMutableAttributedString * contentAttr = [self attributedStringForContent:_model.content];
        NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor greenColor],
                                         NSLigatureAttributeName : @(-5)};
        _textView.attributedText = contentAttr;
        _textView.linkTextAttributes = linkAttributes;
        _textView.frame = CGRectMake(15, 15 + 32 + 7, CGRectGetWidth(self.bounds) - 30, _model.contentHeight);
    }

}

- (NSMutableAttributedString *)attributedStringForContent:(NSString *)string
{
    NSMutableAttributedString * attributedStringTest = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedStringTest addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.f] range:NSMakeRange(0, attributedStringTest.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    
    [attributedStringTest addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStringTest.length)];
    
//    [attributedStringTest addAttribute:NSLinkAttributeName
//                                 value:@"http://www.baidu.com"
//                                 range:NSMakeRange(0, 3)];
    [attributedStringTest addAttribute:NSLinkAttributeName
                                 value:@"http://www.cocoachina.com"
                                 range:[[attributedStringTest string] rangeOfString:@"我连命都活不"]];
    // 可用于 @人 话题的交互处理
    
    return attributedStringTest;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(10, 30, image.size.width, image.size.height);
    CGSize size = [linkStr sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f]}];
    rect = CGRectMake(15, 15 + 32 + 7 + 2 + 16, size.width, size.height);
    if (CGRectContainsPoint(rect, point)) {
        
        NSLog(@"点击了链接文字");
//        [self showPhotoBrowser];
    }
    else {
        NSLog(@"point:%@", NSStringFromCGPoint(point));
    }
}

- (void)showPhotoBrowser
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = 1; // 图片总数
    browser.currentImageIndex = (int)0;
    browser.delegate = self;
    [browser show];
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return image;
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:@"http://ww1.sinaimg.cn/bmiddle/a7c49da7jw1eq9wxm8q83j20hs214qb6.jpg"];
}

@end



// --------------------------- WeiboModel -----------------------

@implementation WeiboModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        _profileImgUrl = dict[@"profileImgUrl"];
        _name = dict[@"name"];
        _time = dict[@"time"];
        _place = dict[@"place"];
        _content = dict[@"content"];
        _images = dict[@"images"];
        
    }
    
    return self;
}

@end
