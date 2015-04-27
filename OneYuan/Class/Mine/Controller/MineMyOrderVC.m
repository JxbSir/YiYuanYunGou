//
//  MineMyOrderVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/24.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineMyOrderVC.h"
#import "MineMyOrderModel.h"
#import "MineOrderCell.h"
#import "MineOrderHeadView.h"
#import "MineMyOrderTransVC.h"
#import "MineMyAddressVC.h"

@interface MineMyOrderVC ()<UITableViewDataSource,UITableViewDelegate,MineMyOrderCellDelegate,MineMyAddressVCDelegate>
{
    __block UITableView     *tbView;
    __block NSMutableArray  *arrData;
    __block int             allCount;
    __block int             curPage;
    
    MineOrderHeadView       *vHead;
}

@end

@implementation MineMyOrderVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"获得的商品";
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
    
    [self getData:nil];
    
    [self showLoad];
}

#pragma mark - getdata
- (void)getData:(void (^)(void))block
{
    __weak typeof (self) wSelf = self;
    [MineMyOrderModel getUserOrderlist:curPage size:10 success:^(AFHTTPRequestOperation* operation,NSObject* result){
        if(block != NULL)
            block();
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        [wSelf hideLoad];
        MineMyOrderList* list = [[MineMyOrderList alloc] initWithDictionary:(NSDictionary*)result];
        if(!arrData)
            arrData = [NSMutableArray arrayWithArray:list.listItems];
        else
            [arrData addObjectsFromArray:list.listItems];
        allCount = [list.count intValue];
        [tbView setShowsInfiniteScrolling:arrData.count < [list.count intValue]];
        [tbView reloadData];
        
        if(arrData.count == 0)
        {
            [tbView setHidden:YES];
            [wSelf showEmpty];
        }
        else
        {
            [tbView setHidden:NO];
            [wSelf hideEmpty];
        }
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取我的商品异常：%@",error]];
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
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    vHead = [[MineOrderHeadView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 35)];
    [vHead setNum:allCount];
    return vHead;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineMyOrderItem* item = [arrData objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"mineOrderCell";
    MineOrderCell *cell =  (MineOrderCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[MineOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.delegate = self;
    [cell setMyOrder:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MineMyOrderItem* item = [arrData objectAtIndex:indexPath.row];
    if([item.orderState intValue] <2)
    {
        return;
    }
    MineMyOrderTransVC* vc = [[MineMyOrderTransVC alloc] initWithNo:[item.orderNo intValue]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - delegate
- (void)confirmOrder:(int)orderId
{
    MineMyAddressVC* vc = [[MineMyAddressVC alloc] initWithType:MineAddressType_Select orderId:orderId];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)confirmShip:(int)orderId
{
    __weak typeof (self) wSelf = self;
    [[[UIAlertView alloc] initWithTitle:nil
                                message:@"是否确认已经收到商品？"
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                       otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
        
        [MineMyOrderModel doConfirmShip:orderId success:^(AFHTTPRequestOperation* opreation, NSObject* result){
            OneBaseParser* p = [[OneBaseParser alloc] initWithDictionary:(NSDictionary*)result];
            NSLog(@"%@",p);
            if([p.code intValue] == 0)
            {
                [[XBToastManager ShardInstance] showtoast:@"确认收货成功"];
                [wSelf refreshMyOrder];
            }
        } failure:^(NSError* error){
            
        }];
        
    }], nil] show];
}

- (void)refreshMyOrder
{
    curPage = 1;
    __weak typeof (self) wSelf = self;
    [self getData:^{
        __strong typeof (self) sSelf = wSelf;
        sSelf->arrData = nil;
    }];
}
@end
