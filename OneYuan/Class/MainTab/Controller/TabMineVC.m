//
//  TabMineVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/18.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "TabMineVC.h"
#import "LoginVC.h"
#import "UserModel.h"
#import "UserInstance.h"
#import "MineLoginView.h"
#import "MineUserView.h"
#import "MineBuylistVC.h"
#import "MineMyOrderVC.h"
#import "MineShowOrderVC.h"
#import "MineMoneyDetailVC.h"
#import "MineMyAddressVC.h"
#import "SettingVC.h"
#import "MineRechargeVC.h"

@interface TabMineVC () <UITableViewDataSource,UITableViewDelegate,MineLoginViewDelegate,MineUserViewDelegate>
{
    __block UITableView     *tbView;
    
    NSArray *arrTitles;
    NSArray *arrImages;
}
@end

@implementation TabMineVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UserInstance ShardInstnce] isUserStillOnline];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginOk) name:kDidLoginOk object:nil];
    __weak typeof (self) wSelf = self;
    self.title = @"我的云购";
    
    arrTitles = @[@"我的云购记录",@"获得的商品",@"我的晒单",@"账户明细",@"收货地址管理"];//@"我的好友",@"消息中心",,
    arrImages = @[@"me1",@"me2",@"me3",@"me6",@"me7"];//@"me4",@"me5",
    
    [self actionCustomRightBtnWithNrlImage:@"btnsetting" htlImage:@"btnsetting" title:@"" action:^{
        SettingVC* vc = [[SettingVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [wSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
}

- (void)didLoginOk
{
    [tbView reloadData];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrTitles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 130;
    return 10;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        if ([UserInstance ShardInstnce].userId)
        {
            MineUserView* v = [[MineUserView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 130)];
            v.delegate = self;
            return v;
        }
        else
        {
            MineLoginView* v = [[MineLoginView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 130)];
            v.delegate = self;
            return v;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  nil;//(UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString* title = nil;
    NSString* image = nil;
    title = [arrTitles objectAtIndex:indexPath.row];
    image = [arrImages objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"        %@",title];
    
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 24, 24)];
    img.image = [UIImage imageNamed:image];
    [cell addSubview:img];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            MineBuylistVC* vc = [[MineBuylistVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 1)
        {
            MineMyOrderVC* vc = [[MineMyOrderVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 2)
        {
            MineShowOrderVC* vc = [[MineShowOrderVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 3)
        {
            MineMoneyDetailVC* vc = [[MineMoneyDetailVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 4)
        {
            MineMyAddressVC* vc = [[MineMyAddressVC alloc] initWithType:MineAddressType_Common orderId:0];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - login view delegate
- (void)doLogin
{
    LoginVC* vc = [[LoginVC alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.tabBarController presentViewController:nav animated:YES completion:nil];
}

- (void)btnPayAction
{
    SCLAlertView* alert = [[SCLAlertView alloc] init];
    alert.showAnimationType = FadeIn;
    [alert showWarning:self.tabBarController title:@"提示" subTitle:@"请前往官方网站完成充值" closeButtonTitle:@"好的" duration:0];
}
@end
