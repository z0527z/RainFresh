//
//  ListViewController.m
//  chat
//
//  Created by dql on 15/3/6.
//  Copyright (c) 2015年 dql. All rights reserved.
//

#import "ListViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

// test
#import "TableViewCell.h"

@interface ListViewController () <UITableViewDelegate, UITableViewDataSource, EGORefreshTableDelegate>
{
    UITableView * _tableView;
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    NSMutableArray * _dataArray;
    CGFloat _cellHeight;
}
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray arrayWithCapacity:10];
    
    [self fakeData];
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    [self createHeaderView];
    [_refreshHeaderView beginRefresh];
    
    [self createFooterView];
    
}

- (void)createHeaderView
{
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - 65.0f, self.view.frame.size.width, 65.0f)];
    _refreshHeaderView.delegate = self;
    [_tableView addSubview:_refreshHeaderView];
}

- (void)createFooterView
{
    CGFloat height = MAX(_tableView.contentSize.height, _tableView.frame.size.height);
    _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, height, _tableView.frame.size.width, self.view.bounds.size.height)];
    _refreshFooterView.delegate = self;
    [_tableView addSubview:_refreshFooterView];
}

- (void)fakeData
{
    for (NSInteger i = 0; i < 1; i ++) {

        NSDictionary * dict = @{@"profileImgUrl" : @"http://tp4.sinaimg.cn/2814680487/180/22870552345/0",
                                @"name" : @"笑话君",
                                @"time" : @"刚刚",
                                @"place" : @"香格里拉",
                                @"content" : @"没有你替我呼吸，\n我连命都活不下去！😂",
                                @"images" : @[@"http://ww4.sinaimg.cn/thumbnail/a7c49da7jw1eqat8pbpuwj20c80lzgnp.jpg"]
                                };
        
        WeiboModel * model = [[WeiboModel alloc] initWithDict:dict];
        
        CGFloat height = [self caculateCellHeight:model];
        _cellHeight = height;
        
        [_dataArray addObject:model];
    }
}

- (CGFloat)caculateCellHeight:(WeiboModel *)model
{
    CGFloat height;
    
    // 头像偏移
    height += 15;
    
    // 头像高度
    height += 32;
    
    // 文字和头像间距
    height += 7;
    
    UITextView * textView = [[UITextView alloc] init];
    textView.font = [UIFont systemFontOfSize:16.0f];
    textView.text = model.content;
    
    CGSize contentSize = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(self.view.bounds), 100)];
    model.contentHeight = contentSize.height;
    // 内容高度
    height += contentSize.height;
    
    // 配图距离内容距离
    height += 8;
    
    // 图片高度
    height += 80;
    
    return height;
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
//    cell.textLabel.text = _dataArray[indexPath.row];
    cell.model = _dataArray[indexPath.row];
    
    return cell;
}


#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableView:(UIView *)view DidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    NSLog(@"开始刷新");
    
    if ([view isKindOfClass:[EGORefreshTableHeaderView class]]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"下拉刷新");
            
            [_refreshHeaderView endRefresh];
        });
    }
    else if ([view isKindOfClass:[EGORefreshTableFooterView class]]) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"上拉加载更多完成");
            
            [_refreshFooterView endRefresh];
            [_tableView reloadData];
        });
    }
    

}

//- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
//    
////    return _reloading; // should return if data source model is reloading
//    return NO;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
