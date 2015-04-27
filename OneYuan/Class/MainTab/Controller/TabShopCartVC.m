//
//  TabShopCartVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/18.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "TabShopCartVC.h"
#import "CartEmptyView.h"
#import "CartModel.h"
#import "CartCell.h"
#import "CartOptView.h"
#import "CartInstance.h"
#import "UserInstance.h"
#import "AppDelegate.h"
#import "ProductDetailVC.h"

@interface TabShopCartVC ()<UITableViewDataSource,UITableViewDelegate,CartCellDelegate,CartOptViewDelegate>
{
    __block CartEmptyView   *viewEmpty;
    __block CartOptView     *viewOpt;
    
    __block NSArray         *arrData;
    
    __block UITableView     *tbView;
    
    __block NSTimer         *timerResult;
 
    __block SCLAlertView    *alertWait ;
}
@end

@implementation TabShopCartVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (viewOpt)
    {
        [viewOpt setOpt];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCartItem) name:kDidAddCart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCartItem) name:kDidAddCartSearch object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCartItem) name:kDidAddCartOpt object:nil];
    
    __weak typeof (self) wSelf = self;
    
    viewEmpty = [[CartEmptyView alloc] initWithFrame:self.view.bounds];
    
    viewOpt = [[CartOptView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 155, mainWidth, 44)];
    [viewOpt setDelegate:self];
    [viewOpt setOpt];
    [self.view addSubview:viewOpt];
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.view.bounds.size.height - 44) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    [tbView addPullToRefreshWithActionHandler:^{
        [wSelf reloadCartItem];
    }];
    
    [tbView.pullToRefreshView setOYStyle];
    
    [self reloadCartItem];
    
}

- (void)reloadCartItem
{
    __weak typeof (self) wSelf = self;
    [CartModel quertCart:nil value:nil block:^(NSArray* result){
        [tbView.pullToRefreshView stopAnimating];
        arrData = result;
        [viewOpt setHidden:arrData.count==0];
        [tbView setHidden:arrData.count==0];
        if(arrData.count > 0)
        {
            [viewEmpty removeFromSuperview];
        }
        else
        {
            [wSelf.view addSubview:viewEmpty];
        }
        [tbView reloadData];
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
    return 100;
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
    static NSString *CellIdentifier = @"cartCell";
    CartCell *cell =  (CartCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[CartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setDelegate:self];
    [cell setCart:[arrData objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CartItem* item = [arrData objectAtIndex:indexPath.row];
    ProductDetailVC* vc = [[ProductDetailVC alloc] initWithGoodsId:[item.cPid intValue] codeId:[item.cPid intValue]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartItem* item = [arrData objectAtIndex:indexPath.row];
    [CartModel removeCart:item];
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setCartNum];
    
    if (viewOpt)
    {
        [viewOpt setOpt];
    }
    
    [self reloadCartItem];
}

#pragma mark - delegate
- (void)setOpt
{
    if(viewOpt)
    {
        [viewOpt setOpt];
    }
}

- (void)cartCalcAction
{
    if(![UserInstance ShardInstnce].userId)
    {
        LoginVC* vc = [[LoginVC alloc] init];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        __block int count = 0;
        NSArray* arr = [CartModel quertCart2:nil value:nil];
        for (CartItem* item in arr) {
            count += [item.cBuyNum intValue];
        }
        if(count == 0)
        {
            SCLAlertView  *alertView = [[SCLAlertView alloc] init];
            alertView.showAnimationType = FadeIn;
            [alertView showWarning:self.tabBarController title:@"提示" subTitle:@"您未选购任何商品，请选择" closeButtonTitle:@"确定" duration:0];
            return;
        }
        if([[[UserInstance ShardInstnce].userMoney stringByReplacingOccurrencesOfString:@"￥" withString:@"" ] doubleValue] < count)
        {
            SCLAlertView  *alertView = [[SCLAlertView alloc] init];
            alertView.showAnimationType = FadeIn;
            [alertView showWarning:self.tabBarController title:@"提示" subTitle:@"您的余额不足，请充值哦" closeButtonTitle:@"确定" duration:0];
            return;
        }
        if(alertWait)
            alertWait = nil;
        alertWait = [[SCLAlertView alloc] init];
        alertWait.showAnimationType = FadeIn;
        [alertWait showWaiting:self.tabBarController title:@"正在结算" subTitle:@"服务器正在努力结算中,请稍等" closeButtonTitle:nil duration:0];
        __weak typeof (self) wSelf = self;
        [CartModel getCartInServer:^(AFHTTPRequestOperation* operation, NSObject* result){
            NSString* body = (NSString*)result;
            if([[Jxb_Common_Common sharedInstance] containString:body cStr:@"<div class=\"u-Cart-r\">"])
            {
                NSString* tmp = [[Jxb_Common_Common sharedInstance] getMidString:body front:@"<ul id=\"cartBody\">" end:@"</ul>"];
                NSArray* arr = [[Jxb_Common_Common sharedInstance] getSpiltString:tmp split:@"<li>"];
                __block BOOL bAllClear = YES;
                for(int i = 1; i<arr.count; i++)
                {
                    NSString* item = [arr objectAtIndex:i];
                    NSString* cid = [[Jxb_Common_Common sharedInstance] getMidString:item front:@"cid=\"" end:@"\""];
                    bAllClear = [CartModel delCartInServer:[cid intValue]];
                    if(!bAllClear)
                        break;
                }
                if(!bAllClear)
                {
                    [alertWait hideView];
                    SCLAlertView  *alertView = [[SCLAlertView alloc] init];
                    alertView.showAnimationType = FadeIn;
                    [alertView showError:self.tabBarController title:@"异常" subTitle:@"结算失败，请重试[1]" closeButtonTitle:@"确定" duration:0];
                    return;
                }
            }
            [wSelf submitPros];
            
        } failure:^(NSError* error){
        
        }];
    }
}

- (void)submitPros
{
    [CartModel quertCart:nil value:nil block:^(NSArray* result){
        BOOL bAllAdd = YES;
        NSString* goodsName = nil;
        int goodPeriod = 0;
        CartAddResult   r = CartAddResult_Failed;
        for (CartItem* item in result) {
            r = [CartModel addCartInServer:item];
            if(r!=CartAddResult_Success)
            {
                goodsName = item.cName;
                goodPeriod = [item.cPeriod intValue];
                bAllAdd = NO;
                break;
            }
        }
        if(!bAllAdd)
        {
            [alertWait hideView];
            if(r == CartAddResult_Full)
            {
                SCLAlertView  *alertView = [[SCLAlertView alloc] init];
                alertView.showAnimationType = FadeIn;
                [alertView showError:self.tabBarController title:@"异常" subTitle:[NSString stringWithFormat:@"[%d期]已满员：%@",goodPeriod,goodsName] closeButtonTitle:@"确定" duration:0];
            }
            else
            {
                SCLAlertView  *alertView = [[SCLAlertView alloc] init];
                alertView.showAnimationType = FadeIn;
                [alertView showError:self.tabBarController title:@"异常" subTitle:@"结算失败，请重试[2]" closeButtonTitle:@"确定" duration:0];
            }
            return ;
        }
        [CartModel postCartInServer:^(AFHTTPRequestOperation* operation, NSObject* res1){
            CartResult* r1 = [[CartResult alloc] initWithDictionary:(NSDictionary*)res1];
            if([r1.state intValue] != 0)
            {
                [alertWait hideView];
                SCLAlertView  *alertView = [[SCLAlertView alloc] init];
                alertView.showAnimationType = FadeIn;
                [alertView showError:self.tabBarController title:@"异常" subTitle:@"结算失败，请重试[4]" closeButtonTitle:@"确定" duration:0];
                return;
            }
            timerResult = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(quertResut:) userInfo:r1.str repeats:YES];
        } failure:^(NSError* error){
            [alertWait hideView];
            SCLAlertView  *alertView = [[SCLAlertView alloc] init];
            alertView.showAnimationType = FadeIn;
            [alertView showError:self.tabBarController title:@"异常" subTitle:@"结算失败，请重试[3]" closeButtonTitle:@"确定" duration:0];
        }];
    }];
}

- (void)quertResut:(NSString*)str
{
    [CartModel queryCartResultInServer:(NSString*)timerResult.userInfo success:^(AFHTTPRequestOperation* operation, NSObject* result)
     {
         if(!timerResult)
             return;
         CartResultAsnyc* r1 = [[CartResultAsnyc alloc] initWithDictionary:(NSDictionary*)result];
         if([r1.state intValue] == 0 && [r1.code intValue] == 1)
         {
             [timerResult invalidate];
             timerResult = nil;
             
             [alertWait hideView];
             
             [CartModel removeAllCart];
             [(AppDelegate*)[[UIApplication sharedApplication] delegate] setCartNum];
             [[NSNotificationCenter defaultCenter] postNotificationName:kDidAddCart object:nil];
             [[NSNotificationCenter defaultCenter] postNotificationName:kDidReloadUser object:nil];
             
             SCLAlertView  *alertView = [[SCLAlertView alloc] init];
             alertView.showAnimationType = FadeIn;
             [alertView showSuccess:self.tabBarController title:@"成功" subTitle:@"结算成功，在我的云购记录中查看" closeButtonTitle:@"确定" duration:0];
         }
         else if ([r1.code intValue] == 2)
         {
             [timerResult invalidate];
             
             [alertWait hideView];
             
             SCLAlertView  *alertView = [[SCLAlertView alloc] init];
             alertView.showAnimationType = FadeIn;
             [alertView showError:self.tabBarController title:@"失败" subTitle:@"余额不足，请先充值" closeButtonTitle:@"确定" duration:0];
         }
     } failure:^(NSError* error){
         [alertWait hideView];
         
         SCLAlertView  *alertView = [[SCLAlertView alloc] init];
         alertView.showAnimationType = FadeIn;
         [alertView showSuccess:self.tabBarController title:@"未知" subTitle:@"结算出现异常，在我的云购记录中查看" closeButtonTitle:@"确定" duration:0];
     }];
}
@end
