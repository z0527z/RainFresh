//
//  ViewController.m
//  chat
//
//  Created by dql on 15/2/12.
//  Copyright (c) 2015年 dql. All rights reserved.
//

#import "ViewController.h"
#import <XMPP.h>
#import "QLLabel.h"

@interface ViewController () <UITextViewDelegate>
@property (nonatomic, strong) XMPPStream * xmppStream;
@property (nonatomic, strong) NSAttributedString * contentString;
@property (nonatomic, strong) NSLayoutManager * layoutManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    UIApplication * application = [UIApplication sharedApplication];
//    id delegate = application.delegate;
//    self.xmppStream = [delegate xmppStream];
//    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
//    NSString * htmlString = @"<p>天气<strong>冷冷</strong>的<strong>，</strong>心里<span style=\"text-decoration: underline;\">暖羊羊</span><span style=\"text-decoration: none;\"><img src=\"/js/editor/dialogs/emotion/images/xhj0/j_0009.gif\"/></span></p>";
//    NSAttributedString * htmlAttr = [[NSAttributedString alloc] initWithString:htmlString];
//    NSString * desc = [htmlAttr string];
    
    
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
    [attributedStringTest insertAttributedString:attributedString atIndex:8];
    [attributedStringTest insertAttributedString:attributedString atIndex:20];
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor greenColor],
                                     NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                     NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    
    UITextView * textView = [[UITextView alloc] init];
    textView.delegate = self;
    textView.editable = NO;
    textView.linkTextAttributes = linkAttributes;
    textView.attributedText = attributedStringTest;
    textView.dataDetectorTypes = UIDataDetectorTypeLink;
    
    CGSize size = [textView sizeThatFits:CGSizeMake(200, 100)];
    textView.frame = CGRectMake(100, 200, 200, ceil(size.height));
    [self.view addSubview:textView];

//    [self buildFrames];
}


- (void)buildFrames
{
    NSTextStorage * textStorage = [[NSTextStorage alloc] initWithAttributedString:_contentString];
    
    _layoutManager = [NSLayoutManager new];
    [textStorage addLayoutManager:_layoutManager];
    
    NSTextContainer * textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(200, 100)];
    [_layoutManager addTextContainer:textContainer];
    
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 200, 200, 100) textContainer:textContainer];
    textView.backgroundColor = [UIColor redColor];
    textView.delegate = self;
    [self.view addSubview:textView];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
