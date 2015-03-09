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

@interface ListViewController () <UITableViewDelegate, UITableViewDataSource, EGORefreshTableDelegate>
{
    UITableView * _tableView;
    //EGOHeader
    EGORefreshTableHeaderView *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView *_refreshFooterView;
    NSMutableArray * _dataArray;
}
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray arrayWithCapacity:10];
    
    [self fakeData];
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 70;
    [self.view addSubview:tableView];
    
    [self createHeaderView];
    [_refreshHeaderView beginRefresh];
    
    [self createFooterView];
    
}

- (void)createHeaderView
{
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height)];
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
    for (NSInteger i = 0; i < 10; i ++) {
        [_dataArray addObject:[NSString stringWithFormat:@"%ld", i]];
    }
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = _dataArray[indexPath.row];
    
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
        [_dataArray addObject:@"10"];
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
