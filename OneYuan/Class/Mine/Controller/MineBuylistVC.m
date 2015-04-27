//
//  MineBuylistVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/24.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineBuylistVC.h"
#import "MineMyBuyModel.h"
#import "MineBuyCell.h"
#import "MineBuyingCell.h"
#import "ProductLotteryVC.h"
#import "ProductDetailVC.h"

@interface MineBuylistVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __block UITableView     *tbView;
    __block NSMutableArray  *arrData;
    
    __block int             curPage;
    __block int             curState;
}
@end

@implementation MineBuylistVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的云购记录";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UISegmentedControl* seg = [[UISegmentedControl alloc] initWithItems:@[@"全部",@"进行中",@"已揭晓"]];
    seg.frame = CGRectMake(30, 10, mainWidth - 60, 32);
    [seg setTintColor:mainColor];
    [seg setSelectedSegmentIndex:0];
    [seg addTarget:self action:@selector(setSelectChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seg];
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 52, mainWidth, self.view.bounds.size.height - 52) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor whiteColor];
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    curPage = 1;
    [tbView addInfiniteScrollingWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->curPage ++;
        [wSelf getData];
    }];
    
    [self getData];
}

#pragma mark - seg action
- (void)setSelectChange:(UISegmentedControl*)_seg
{
    [[XBToastManager ShardInstance] showprogress];
    arrData = nil;
    curPage = 1;
    if (_seg.selectedSegmentIndex == 1)
        curState = 1;
    else if (_seg.selectedSegmentIndex == 2)
        curState = 3;
    else curState = -1;
    [self getData];
}

#pragma mark - getdata
- (void)getData
{
    if(curState == 0)
        curState = -1;
    [MineMyBuyModel getUserBuylist:curPage size:10 state:curState success:^(AFHTTPRequestOperation* operation,NSObject* result){
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.infiniteScrollingView stopAnimating];
        MineMyBuyList* list = [[MineMyBuyList alloc] initWithDictionary:(NSDictionary*)result];
        if(!arrData)
            arrData = [NSMutableArray arrayWithArray:list.listItems];
        else
            [arrData addObjectsFromArray:list.listItems];
        if(arrData.count == 0)
        {
            [self showEmpty:CGRectMake(0, 52, mainWidth, self.view.bounds.size.height - 52)];
        }
        else
            [self hideEmpty];
        [tbView reloadData];
        [tbView setShowsInfiniteScrolling:arrData.count < [list.count intValue]];
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.infiniteScrollingView stopAnimating];
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取我的云购记录异常：%@",error]];
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
    return 110;
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
    MineMyBuyItem* item = [arrData objectAtIndex:indexPath.row];
    if([item.codeState integerValue] == 3)
    {
        static NSString *CellIdentifier = @"mineBuyCell";
        MineBuyCell *cell =  (MineBuyCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[MineBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setBuyed:item];
        return cell;
    }
    else //if([item.codeState integerValue] == 1)
    {
        static NSString *CellIdentifier = @"mineBuyingCell";
        MineBuyingCell *cell =  (MineBuyingCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[MineBuyingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setBuying:item];
        return cell;

    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MineMyBuyItem* item = [arrData objectAtIndex:indexPath.row];
    if([item.codeState intValue] == 3)
    {
        ProductLotteryVC* vc = [[ProductLotteryVC alloc] initWithGoods:0 codeId:[item.codeID intValue]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        ProductDetailVC* vc = [[ProductDetailVC alloc] initWithGoodsId:0 codeId:[item.codeID intValue]];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
