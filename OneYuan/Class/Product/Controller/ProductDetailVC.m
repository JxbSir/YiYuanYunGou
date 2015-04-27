//
//  ProductDetailVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/27.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "ProductDetailVC.h"
#import "ProductModel.h"
#import "ProductDetailTopCell.h"
#import "ProductDetailGetCell.h"
#import "AllProModel.h"
#import "ShowOrderListVC.h"
#import "ProductBuyListVC.h"
#import "ProductDetailOptView.h"
#import "CartModel.h"
#import "CartInstance.h"
#import "ProductLotteryVC.h"

@interface ProductDetailVC ()<UITableViewDataSource,UITableViewDelegate,ProductDetailOptViewDelegate>
{
    int    _goodsId;
    int    _codeId;
    
    
    __block UITableView     *tbView;
    __block ProductDetail   *proDetail;
    
    UIImageView     *imgPro;
    __block ProductDetailOptView* optView;
}
@end

@implementation ProductDetailVC

- (id)initWithGoodsId:(int)goodsId codeId:(int)codeId
{
    self = [super init];
    if(self)
    {
        _goodsId = goodsId;
        _codeId = codeId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"商品详情";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    CGFloat margin = 0;
    if(![OyTool ShardInstance].bIsForReview)
    {
        margin = 44;
        optView = [[ProductDetailOptView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 107, mainWidth, 44)];
        optView.delegate = self;
        [self.view addSubview:optView];
    }
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.view.bounds.size.height - margin) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    [tbView addPullToRefreshWithActionHandler:^{
        [wSelf getData];
    }];
    
    if(_goodsId)
    {
        [self getData];
    }
    else
    {
        [self getGoodsId];
    }
    
    [tbView.pullToRefreshView setOYStyle];
    [self showLoad];
    
}

- (void)getData
{
    __weak typeof (self) wSelf = self;
    [ProductModel getGoodDetail:_goodsId success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [tbView.pullToRefreshView stopAnimating];
        [wSelf hideLoad];
        proDetail = [[ProductDetail alloc] initWithDictionary:(NSDictionary*)result];
        [tbView reloadData];
    } failure:^(NSError* error){
        [tbView.pullToRefreshView stopAnimating];
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"加载商品详情异常：%@",error]];
    }];
}

- (void)getGoodsId
{
    __weak typeof (self) wSelf = self;
    [AllProModel getGoodsPeriodByCodeId:_codeId success:^(AFHTTPRequestOperation* operation, NSObject* result){
        AllProPeriodList* list = [[AllProPeriodList alloc] initWithDictionary:(NSDictionary*)result];
        _goodsId = [[[list.Rows objectAtIndex:0] goodsID] intValue];
        [wSelf getData];
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
    }];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return !proDetail ? 0 : (proDetail.Rows2.userName ? 3 : 2);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1)
    {
        int row = proDetail.Rows2.codePeriod.intValue > 1 ? 3 : 2;
        return row;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 180;
    if(indexPath.section == 2)
        return 100;
    return 44;
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
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"productTopCell";
        ProductDetailTopCell *cell =  (ProductDetailTopCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[ProductDetailTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UIImageView* img = nil;
        [cell setProDetail:proDetail img:&img];
        imgPro = img;
        return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"proCommonCell";
        UITableViewCell *cell =  (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor grayColor];
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"所有云购记录";
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"商品晒单(%d)",[proDetail.Rows3.Topic intValue]];
        }
        else if(indexPath.row == 2)
        {
            cell.textLabel.text = @"历史云购";
        }
        return cell;
    }
    else if (indexPath.section == 2)
    {
        static NSString *CellIdentifier = @"productGetCell";
        ProductDetailGetCell *cell =  (ProductDetailGetCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[ProductDetailGetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setProDetail:proDetail];
        return cell;
    }
    static NSString *CellIdentifier = @"productCommoneCell";
    UITableViewCell *cell =  (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            ProductBuyListVC* vc = [[ProductBuyListVC alloc] initWithCodeId:[proDetail.Rows2.codeID intValue]];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row ==1)
        {
            ShowOrderListVC* vc = [[ShowOrderListVC alloc] initWithGoodsId:_goodsId];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == 2)
        {
            ProductLotteryVC* vc = [[ProductLotteryVC alloc] initWithGoods:_goodsId codeId:[proDetail.Rows2.codeID intValue] - 1];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

#pragma mark - delegate
- (void)addToCartAction
{
    CartItem* item = [[CartItem alloc] init];
    item.cPid = [NSNumber numberWithInt:_goodsId];
    item.cName = proDetail.Rows2.goodsName;
    item.cPeriod = proDetail.Rows2.codePeriod;
    item.cBuyNum = [NSNumber numberWithInt:1];
    item.cCid = proDetail.Rows2.codeID;
    item.cPrice = proDetail.Rows2.codePrice;
    item.cSrc = [NSString stringWithFormat:@"%@%@",oyImageBaseUrl,[[proDetail.Rows1 objectAtIndex:0] picName]];
    [[CartInstance ShartInstance] addToCart:item imgPro:imgPro type:addCartType_Opt];
    
    [self performSelector:@selector(setCartNum) withObject:nil afterDelay:1];

}

- (void)setCartNum
{
    [CartModel quertCart:nil value:nil block:^(NSArray* result){
        [optView setCartNum:(int)result.count];
    }];
}

- (void)gotoCartAction
{
    self.tabBarController.selectedIndex = 3;
    [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.2];
}

- (void)addGotoCartAction
{
    CartItem* item = [[CartItem alloc] init];
    item.cPid = [NSNumber numberWithInt:_goodsId];
    item.cName = proDetail.Rows2.goodsName;
    item.cPeriod = proDetail.Rows2.codePeriod;
    item.cBuyNum = [NSNumber numberWithInt:1];
    item.cCid = proDetail.Rows2.codeID;
    item.cPrice = proDetail.Rows2.codePrice;
    item.cSrc = [NSString stringWithFormat:@"%@%@",oyImageBaseUrl,[[proDetail.Rows1 objectAtIndex:0] picName]];
    [[CartInstance ShartInstance] addToCart:item imgPro:imgPro type:addCartType_Opt];
    
    [self performSelector:@selector(gotoCartAction) withObject:nil afterDelay:1];

}

@end
