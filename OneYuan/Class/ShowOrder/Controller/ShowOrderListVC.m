//
//  ShowOrderListVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/28.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "ShowOrderListVC.h"
#import "ShowOrderModel.h"
#import "ShowOrderItemCell.h"
#import "ShowOrderDetailVC.h"

@interface ShowOrderListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __block UITableView     *tbView;
    __block int             curPage;
    __block NSMutableArray  *arrData;
    
    int                     _goodsId;
}
@end

@implementation ShowOrderListVC

- (id)initWithGoodsId:(int)goodsId
{
    self = [super init];
    if(self)
    {
        _goodsId = goodsId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"商品晒单";
    __weak typeof (self) wSelf = self;
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
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

- (void)getData:(void (^)(void))block
{
    __weak typeof (self) wSelf = self;
    [ShowOrderModel getGoodLottery:_goodsId page:curPage size:10 success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        if(block!=NULL)
            block();
        ShowOrderList* list = [[ShowOrderList alloc] initWithDictionary:(NSDictionary*)result];
        if (!arrData)
        {
            arrData = [NSMutableArray arrayWithArray:list.Rows];
        }
        else
        {
            [arrData addObjectsFromArray:list.Rows];
        }
        [tbView reloadData];
        [tbView setShowsInfiniteScrolling:arrData.count<[list.count integerValue]];
        if(arrData.count == 0)
        {
            [wSelf showEmpty];
        }
    } failure:^(NSError* error){
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取商品晒单页面数据异常:%@",error]];
    }];

}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 0.1;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newedCell";
    ShowOrderItemCell *cell = (ShowOrderItemCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[ShowOrderItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setShow:[arrData objectAtIndex:indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShowOrderDetailVC* vc = [[ShowOrderDetailVC alloc] initWithPostId:[[[arrData objectAtIndex:indexPath.section] postID] intValue]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
