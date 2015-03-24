//
//  ViewController.m
//  chat
//
//  Created by dql on 15/2/12.
//  Copyright (c) 2015年 dql. All rights reserved.
//

#import "ViewController.h"
#import "QLLabel.h"
#import "QLTextStorage.h"
#import "QLWeiboContentView.h"

@interface ViewController () <UITextViewDelegate, QLWeiboContentViewDelegate>
@property (nonatomic, strong) NSAttributedString * contentString;
@property (nonatomic, strong) NSLayoutManager * layoutManager;
@property (nonatomic, strong) QLTextStorage * textStorage;
@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, assign) NSRange wordCharacterRange;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
//    [self methodForCustomedUITextView];
    
//    [self methodForDefaultUITextView];
    
    [self methodForWeiboContentView];
    
    

    // NSDataDetector
//    NSString * linkString = @"啊啊啊 www.baidu.com嗯，吼吼www.dayhr.com";
//    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
//    NSRange range = NSMakeRange(0, linkString.length);
//    NSArray *matches = [detector matchesInString:linkString options:0 range:range];
//    
//    NSLog(@"%@", matches);
    
    //    [self buildFrames];
}

#pragma mark - Label 方案
- (void)methodForLabel
{
    NSString * string = @"😄哈哈款到即发http://www.baidu.com";
    NSMutableAttributedString * contentString = [[[NSAttributedString alloc] initWithString:string] mutableCopy];
    [contentString addAttribute:NSLinkAttributeName value:@"http://www.baidu.com" range:NSMakeRange(8, 20)];
    _contentString = contentString;
    
    UIImage * image = [UIImage imageNamed:@"d_numa_s.png"];
    NSTextAttachment * textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    textAttachment.image = image;
    
    
    NSAttributedString * attributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [contentString insertAttributedString:attributedString atIndex:2];
    
    
    QLLabel * label = [[QLLabel alloc] init];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor grayColor];
    label.attributedText = contentString;
    
    float height = [label sizeThatFits:CGSizeMake(200, 100)].height;
    label.frame = CGRectMake(100, 100, 200, height);
    
    
    [contentString enumerateAttributesInRange:NSMakeRange(0, contentString.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        NSLog(@"attrs:%@, range:%@", attrs, NSStringFromRange(range));
    }];
    
    [self.view addSubview:label];
}

#pragma mark - Default UITextView 方案
- (void)methodForDefaultUITextView
{
    // 微博内容显示方案
    // UITextView for UITextKit
    NSMutableAttributedString * attributedStringTest = [[NSMutableAttributedString alloc] initWithString:@"＠啊哈 收到飒飒地方发送发大水接啊阿拉山大师傅都是反复发撒旦法是否口撒娇的了发诺@哈哟😄"];
    [attributedStringTest addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.f] range:NSMakeRange(0, attributedStringTest.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;
    
    [attributedStringTest addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStringTest.length)];
    
    [attributedStringTest addAttribute:NSLinkAttributeName
                                 value:@"http://www.baidu.com"
                                 range:NSMakeRange(0, 3)];
    [attributedStringTest addAttribute:NSLinkAttributeName
                                 value:@"http://www.cocoachina.com"
                                 range:NSMakeRange(10, 5)];
    [attributedStringTest addAttribute:NSLinkAttributeName
                                 value:@"http://www.raywenderlich.com"
                                 range:NSMakeRange(25, 5)];
    // 可用于 @人 话题的交互处理
    [attributedStringTest addAttribute:NSLinkAttributeName
                                 value:@"file://viewController"
                                 range:NSMakeRange(8, 2)];
    
    // 图片
    UIImage * image = [UIImage imageNamed:@"d_numa_s.png"];
    NSTextAttachment * textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    textAttachment.image = image;
    
    NSAttributedString * attributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedStringTest insertAttributedString:attributedString atIndex:8];
    [attributedStringTest insertAttributedString:attributedString atIndex:20];
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName : [UIColor greenColor],
                                     NSUnderlineColorAttributeName : [UIColor lightGrayColor],
                                     NSUnderlineStyleAttributeName : @(NSUnderlinePatternSolid),
                                     NSParagraphStyleAttributeName : [self myParagraphStyle],
                                     NSExpansionAttributeName : @1};
    
    UITextView * textView = [[UITextView alloc] init];
    textView.delegate = self;
    textView.editable = NO;
    textView.linkTextAttributes = linkAttributes;
    textView.attributedText = attributedStringTest;
    textView.dataDetectorTypes = UIDataDetectorTypeLink;
    
    CGSize size = [textView sizeThatFits:CGSizeMake(200, 100)];
    textView.frame = CGRectMake(100, 200, 200, ceil(size.height));
    [self.view addSubview:textView];

}

#pragma mark - customed UITextView 方案
- (void)methodForCustomedUITextView
{
    NSString * string = @"@啊哈 @ 收到飒飒地方发送发大水接啊阿拉山大师傅都是反复发撒旦法口撒娇的了发诺@哈哟😄";
    
    NSDictionary * attrs = @{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:string attributes:attrs];
    
    _textStorage = [QLTextStorage new];
    [_textStorage appendAttributedString:attrString];
    
    NSLayoutManager * layoutManager = [NSLayoutManager new];
    _layoutManager = layoutManager;
    
    CGSize containerSize = CGSizeMake(200, CGFLOAT_MAX);
    
    NSTextContainer * container = [[NSTextContainer alloc] initWithSize:containerSize];
    container.widthTracksTextView = YES;
    [layoutManager addTextContainer:container];
    [_textStorage addLayoutManager:layoutManager];
    
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, 200, 100) textContainer:container];
    _textView = textView;
    textView.delegate = self;
    textView.editable = NO;
    [self.view addSubview:textView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [textView addGestureRecognizer:tapGesture];
}

#pragma mark - WeiboContent View
- (void)methodForWeiboContentView
{
    QLWeiboContentView * WeiboView = [[QLWeiboContentView alloc] initWithFrame:CGRectMake(10, 20, 200, 100)];
//    WeiboView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0f];
    WeiboView.delegate = self;
    [self.view addSubview:WeiboView];
    
    NSString * text = @"@哈哈 阿哈利安静 d_xiaoku@2x.png 多了咖啡机www.dayhr.com @ 哈www.baidu.com 😄 就爱上了多久啊收到了福建路口 哈";
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:12], NSParagraphStyleAttributeName : [self myParagraphStyle]};
    
    NSTextStorage * textStorage = [[[QLWeiboContentStorage alloc] init] storageWithText:text];
    [textStorage addAttributes:attributes range:NSMakeRange(0, textStorage.length)];
    WeiboView.textStorage = textStorage;
    
    CGSize size = [WeiboView sizeThatFits:CGSizeMake(200, 100)];
    NSLog(@"size:%@", NSStringFromCGSize(size));
    
    CGRect rect = WeiboView.frame;
    rect.size.height = size.height;
    WeiboView.frame = rect;
}

- (NSParagraphStyle *)myParagraphStyle {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    //	paragraphStyle.lineSpacing = 5;
    //	paragraphStyle.paragraphSpacing = 15;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    //	paragraphStyle.firstLineHeadIndent = 5;
    //	paragraphStyle.headIndent = 5;
    //	paragraphStyle.tailIndent = 250;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    //	paragraphStyle.minimumLineHeight = 10;
    //	paragraphStyle.maximumLineHeight = 20;
    paragraphStyle.baseWritingDirection = NSWritingDirectionNatural;
    //	paragraphStyle.lineHeightMultiple = 1.0;
    //	paragraphStyle.hyphenationFactor = 2;
    //	paragraphStyle.paragraphSpacingBefore = 0;
    
    return [paragraphStyle copy];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return NO;
}

#pragma mark - QLWeiboContentView Delegate
- (void)weiboContentView:(UIView *)view touchedURLString:(NSString *)urlString
{
    if ([urlString isKindOfClass:[NSString class]]) {
        
        if ([urlString hasPrefix:@"file://"]) {
            NSLog(@"点击了 @ 人");
        }
        else {
            NSLog(@"点击了 url 链接 --> %@", urlString);
            UIApplication * sharedApplication = [UIApplication sharedApplication];
            NSURL * url = [NSURL URLWithString:urlString];
            if ([sharedApplication canOpenURL:url]) {
                [sharedApplication openURL:url];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
