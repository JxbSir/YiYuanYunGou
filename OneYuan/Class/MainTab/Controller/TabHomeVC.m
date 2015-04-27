//
//  TabHomeVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/18.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "TabHomeVC.h"
#import "HomeModel.h"
#import "HomeAdCell.h"
#import "HomeAdDigitalCell.h"
#import "HomeAdBtnCell.h"
#import "HomeNewCell.h"
#import "HomeHotCell.h"
#import "HomeOrderShowCell.h"
#import "HomeInstance.h"
#import "SearchVC.h"
#import "MineBuylistVC.h"
#import "UserInstance.h"
#import "LoginVC.h"
#import "TabNewestVC.h"
#import "ProductDetailVC.h"
#import "ProductLotteryVC.h"
#import "ShowOrderListVC.h"
#import "ShowOrderDetailVC.h"

@interface TabHomeVC ()<UITableViewDataSource,UITableViewDelegate,HomeAdCellDelegate,HomeAdBtnCellDelegate,HomeAdDigitalCellDelegate,HomeHotCellDelegate,HomeNewCellDelegate,HomeOrderShowCellDelegate>
{
    NSTimer         *timer;
    UITableView     *tbView;
    __block HomePageList    *listHomepage;
}
@end

@implementation TabHomeVC

- (void)dealloc
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyData) name:kDidNotifyFromBack object:nil];
    
    self.title = @"首页";
    __weak typeof (self) wSelf = self;
    
    if(![OyTool ShardInstance].bIsForReview)
    {
        [self actionCustomRightBtnWithNrlImage:@"search" htlImage:@"search" title:@"" action:^{
            SearchVC* vc = [[SearchVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [wSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    
    tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    [tbView addPullToRefreshWithActionHandler:^{
        [wSelf getNewest];
        [wSelf getOrderShows];
    }];
 
    [tbView.pullToRefreshView setOYStyle];
    
    [tbView triggerPullToRefresh];
    
    [self getLoadAds];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(refreshMyData) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark - load data
/**
 *  刷新数据
 */
- (void)refreshMyData
{
    [self getNewest];
    [self getOrderShows];
}

/**
 *  最新揭晓
 */
- (void)getNewest
{
    __weak UITableView* wTb = tbView;
    [HomeModel getNewing:^(AFHTTPRequestOperation* operation, NSObject* result){
         [HomeInstance ShardInstnce].listNewing = [[HomeNewingList alloc] initWithDictionary:(NSDictionary*)result];
        [HomeModel getHomePage:^(AFHTTPRequestOperation* operation, NSObject* result){
            listHomepage = [[HomePageList alloc] initWithDictionary:(NSDictionary*)result];
            [wTb.pullToRefreshView stopAnimating];
            [wTb reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidNotifyReloadNewest object:nil];
        } failure:^(NSError* error){
            [wTb.pullToRefreshView stopAnimating];
                //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取首页商品异常：%@",error]];
        }];
    } failure:^(NSError* error){
        [wTb.pullToRefreshView stopAnimating];
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取最新揭晓异常：%@",error]];
    }];
}

/**
 *  1元搜索广告
 */
- (void)getLoadAds
{
    __weak UITableView* wTb = tbView;
    [HomeModel getSearchAd1:^(AFHTTPRequestOperation* operation, NSObject* result){
        [HomeInstance ShardInstnce].listAd1 = [[HomeSearchAdList alloc] initWithDictionary:(NSDictionary*)result];
        [wTb reloadData];
    } failure:^(NSError* error){
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取搜索广告1异常:%@",error]];
    }];

    [HomeModel getSearchAd2:^(AFHTTPRequestOperation* operation, NSObject* result){
        [HomeInstance ShardInstnce].listAd2 = [[HomeSearchAdList alloc] initWithDictionary:(NSDictionary*)result];
        [wTb reloadData];
    } failure:^(NSError* error){
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取搜索广告2异常:%@",error]];
    }];
}

/**
 *  晒单分享
 */
- (void)getOrderShows
{
    __weak typeof (tbView) wTb = tbView;
    [HomeModel getOrderShow:^(AFHTTPRequestOperation* operation, NSObject* result){
        [HomeInstance ShardInstnce].listOrderShows = [[HomeOrderShowList alloc] initWithDictionary:(NSDictionary*)result];
        [wTb reloadData];
    } failure:^(NSError* error){
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取首页晒单分享异常:%@",error]];
    }];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 3)
        return 1;
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return indexPath.row == 0 ? 150:100;
    }
    if (indexPath.section == 1 && indexPath.row == 1)
        return 140.5;
    if (indexPath.section == 2 && indexPath.row == 1)
        return 200;
    if (indexPath.section == 3)
    {
        if([OyTool ShardInstance].bIsForReview)
        {
            return 44;
        }
        return 270;
    }
    if (indexPath.section == 4 && indexPath.row == 1)
        return 250;
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
        return 0.1;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0)
    {
        if(row == 0)
        {
            static NSString *CellIdentifier = @"homeAdCell";
            HomeAdCell *cell = (HomeAdCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[HomeAdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.delegate = self;
            [cell getAds];
            return cell;
        }
        else if(row == 1)
        {
            static NSString *CellIdentifier = @"homeAdBtnCell";
            HomeAdBtnCell *cell = (HomeAdBtnCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[HomeAdBtnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.delegate = self;
            return cell;
        }
    }
    if (section == 1)
    {
        if(row == 0)
        {
            static NSString *CellIdentifier = @"newTitleCell";
            UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.text = @"最新揭晓";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        else if(row == 1)
        {
            static NSString *CellIdentifier = @"homeNewCell";
            HomeNewCell *cell = (HomeNewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[HomeNewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setDelegate:self];
            [cell setNews:[HomeInstance ShardInstnce].listNewing homepage:listHomepage.Rows1];
            return cell;
        }
    }
    else if (section == 2)
    {
        if(row == 0)
        {
            static NSString *CellIdentifier = @"hotTitleCell";
            UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.text = @"人气推荐";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        else if (row == 1)
        {
            static NSString *CellIdentifier = @"homeHotCell";
            HomeHotCell *cell = (HomeHotCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[HomeHotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.delegate = self;
            [cell setHots:listHomepage.Rows2];
            return cell;
        }
    }
    else if(section == 3)
    {
        if (row == 0)
        {
            if ([OyTool ShardInstance].bIsForReview)
            {
                static NSString *CellIdentifier = @"homeAdDigReviewCell";
                UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                cell.textLabel.text = @"一元云购，云友的查询利器";
                return cell;

            }
            else
            {
                static NSString *CellIdentifier = @"homeAdDigCell";
                HomeAdDigitalCell *cell = (HomeAdDigitalCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
                if(cell == nil)
                {
                    cell = [[HomeAdDigitalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                [cell setDelegate:self];
                [cell doLoadAds];
                return cell;
            }
        }

    }
    else if (section == 4)
    {
        if(row == 0)
        {
            static NSString *CellIdentifier = @"showTitleCell";
            UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.text = @"晒单分享";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        else if(row==1)
        {
            static NSString *CellIdentifier = @"homeOrderShowCell";
            HomeOrderShowCell *cell = (HomeOrderShowCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[HomeOrderShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setDelegate:self];
            [cell setOrderShows];
            return cell;

        }
    }
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        self.tabBarController.selectedIndex = 2;
    }
    else if(indexPath.section == 2 && indexPath.row == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidShowNewPro object:[NSNumber numberWithInt:1]];
        self.tabBarController.selectedIndex = 1;
    }
    else if(indexPath.section == 4 && indexPath.row == 0)
    {
        ShowOrderListVC* vc = [[ShowOrderListVC alloc] initWithGoodsId:0];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - delegate;
- (void)adClick:(NSString *)key
{
    if([key rangeOfString:@"search,"].length > 0)
    {
        NSString* searchKey = [key stringByReplacingOccurrencesOfString:@"search," withString:@""];
        SearchVC* vc = [[SearchVC alloc] initWithKey:searchKey];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([key rangeOfString:@"goodsdetail,"].length > 0)
    {
        NSString* goodsId = [key stringByReplacingOccurrencesOfString:@"goodsdetail," withString:@""];
        ProductDetailVC* vc = [[ProductDetailVC alloc] initWithGoodsId:[goodsId intValue] codeId:0];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)btnHomeClick:(int)index
{
    if(index == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidShowNewPro object:[NSNumber numberWithInt:4]];
        self.tabBarController.selectedIndex = 1;
    }
    else if(index == 1)
    {
        ShowOrderListVC* vc = [[ShowOrderListVC alloc] initWithGoodsId:0];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(index == 2)
    {
        if(![UserInstance ShardInstnce].userId)
        {
            LoginVC* vc = [[LoginVC alloc] init];
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
        else
        {
            MineBuylistVC* vc = [[MineBuylistVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

#pragma mark - newest delegate
- (void)doClickGoods:(int)goodsId codeId:(int)codeId
{
    if(goodsId == 0)
    {
        ProductDetailVC* vc = [[ProductDetailVC alloc] initWithGoodsId:goodsId codeId:codeId];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        ProductLotteryVC* vc = [[ProductLotteryVC alloc] initWithGoods:goodsId codeId:codeId];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - show delegate
- (void)doCickShare:(int)postId
{
    ShowOrderDetailVC* vc = [[ShowOrderDetailVC alloc] initWithPostId:postId];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
