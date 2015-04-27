//
//  MineShowOrderVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/25.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineShowOrderVC.h"
#import "MineShowOrderCell.h"
#import "MineShowOrderModel.h"
#import "ShowOrderDetailVC.h"

@interface MineShowOrderVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __block UITableView     *tbView;
    __block NSMutableArray  *arrData;
    __block int             allCount;
    __block int             curPage;
}

@end

@implementation MineShowOrderVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"我的晒单";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.view.bounds.size.height - 35) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = self.view.backgroundColor;
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    curPage = 1;
    
    [tbView addPullToRefreshWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->curPage = 1;
        [wSelf getData:^{
            sSelf->arrData = nil;
        }];
    }];
    
    [tbView addInfiniteScrollingWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->curPage ++;
        [wSelf getData:nil];
    }];
    
    [tbView.pullToRefreshView setOYStyle];
    [tbView triggerPullToRefresh];
}

#pragma mark - getdata
- (void)getData:(void (^)(void))block
{
    __weak typeof(self) wSelf = self;
    [MineShowOrderModel getShowOrderlist:curPage size:10 success:^(AFHTTPRequestOperation* operation,NSObject* result){
        if(block != NULL)
            block();
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        MineShowOrderList* list = [[MineShowOrderList alloc] initWithDictionary:(NSDictionary*)result];
        if(!arrData)
            arrData = [NSMutableArray arrayWithArray:list.listItems];
        else
            [arrData addObjectsFromArray:list.listItems];
        allCount = [list.postCount intValue] + [list.unPostCount intValue];
        [tbView setShowsInfiniteScrolling:arrData.count < allCount];
        [tbView reloadData];
        if(arrData.count == 0)
        {
            [wSelf showEmpty];
        }
        else
        {
            [wSelf hideEmpty];
        }
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取我的晒单异常：%@",error]];
    }];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineShowOrderItem* item = [arrData objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"mineShowOrderCell";
    MineShowOrderCell *cell =  (MineShowOrderCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[MineShowOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setMyPost:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MineShowOrderItem* item = [arrData objectAtIndex:indexPath.row];
    ShowOrderDetailVC* vc = [[ShowOrderDetailVC alloc] initWithPostId:[item.postID intValue]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

@end

