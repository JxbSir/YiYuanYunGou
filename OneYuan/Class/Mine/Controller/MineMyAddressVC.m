//
//  MineMyAddressVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/26.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineMyAddressVC.h"
#import "MineMyAddressModel.h"
#import "MineMyAddItemCell.h"
#import "MineMyAddressEditVC.h"
#import "MineMyOrderModel.h"

@interface MineMyAddressVC ()<UITableViewDataSource,UITableViewDelegate,MineMyAddressEditVCDelegate,MineMyAddItemCellDelegate>
{
    __weak  id<MineMyAddressVCDelegate> delegate;
    __block MineAddressType         myType;
    __block int                     myOrderId;
    __block MineMyAddressItemList   *myAddressData;
    
    __block UITableView     *tbView;
}
@end

@implementation MineMyAddressVC
@synthesize delegate;

- (id)initWithType:(MineAddressType)type orderId:(int)orderId
{
    self = [super init];
    if(self)
    {
        myType = type;
        myOrderId = orderId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = myType == MineAddressType_Common ? @"地址管理" : @"地址选择";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    if(myType == MineAddressType_Common)
    {
        [self actionCustomRightBtnWithNrlImage:@"btnAdd" htlImage:@"btnAdd" title:@"" action:^{
            MineMyAddressEditVC* vc  = [[MineMyAddressEditVC alloc] initWithAddress:nil];
            vc.delegate = self;
            vc.hidesBottomBarWhenPushed = YES;
            [wSelf.navigationController pushViewController:vc animated:YES];
        }];
    }

    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.view.bounds.size.height - 35) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = self.view.backgroundColor;
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    [tbView addPullToRefreshWithActionHandler:^{
        [wSelf getAddress];
    }];
    [tbView.pullToRefreshView setOYStyle];
    
    [tbView triggerPullToRefresh];
    
    [self showLoad];
}

- (void)getAddress
{
    __weak typeof (self) wSelf = self;
    [MineMyAddressModel getMyAddress:^(AFHTTPRequestOperation* operation,NSObject* result){
        [tbView.pullToRefreshView stopAnimating];
        [[XBToastManager ShardInstance] hideprogress];
        [wSelf hideLoad];
        NSString* tmp = (NSString*)result;
        NSError* error = nil;
        NSDictionary* dicTmp = [NSDictionary dictionaryWithJSONString:tmp error:&error];
        NSMutableArray* arr = [NSMutableArray array];
        NSArray* arrDicTmp = (NSArray*)dicTmp;
        if((NSNull*)arrDicTmp != [NSNull null] && arrDicTmp.count > 0)
        {
            for (NSDictionary* dic in (NSArray*)dicTmp) {
                MineMyAddressItem* item = [[MineMyAddressItem alloc] initWithDictionary:dic];
                [arr addObject:item];
            }
        }
        if(!myAddressData)
            myAddressData = [[MineMyAddressItemList alloc] init];
        myAddressData.list = [arr copy];
        
        [tbView reloadData];
        
        if(myAddressData.list.count == 0)
            [wSelf showEmpty];
        else
            [wSelf hideEmpty];
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
    }];
}

#pragma mark - delegate
- (void)refreshAddress
{
    [tbView triggerPullToRefresh];
}

- (void)setDefault:(int)addressId
{
    __weak typeof (self) wSelf = self;
    [[XBToastManager ShardInstance] showprogress];
    [MineMyAddressModel setDefault:addressId success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [[XBToastManager ShardInstance] showprogress];
        OneBaseParser* p = [[OneBaseParser alloc] initWithDictionary:(NSDictionary*)result];
        if([p.code intValue ] == 0)
        {
            [wSelf getAddress];
        }
        else
        {
            [[XBToastManager ShardInstance] showprogress];
            [[XBToastManager ShardInstance] showtoast:@"设置失败，请重试"];
        }
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] showprogress];
    }];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return myAddressData.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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
    MineMyAddressItem* item = [myAddressData.list objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"mineAddressCell";
    MineMyAddItemCell *cell =  (MineMyAddItemCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[MineMyAddItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setDelegate:self];
    [cell setAddress:item bShow:myType == MineAddressType_Common];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MineMyAddressItem* item = [myAddressData.list objectAtIndex:indexPath.row];
    if(myType == MineAddressType_Common)
    {
        MineMyAddressEditVC* vc  = [[MineMyAddressEditVC alloc] initWithAddress:item];
        vc.delegate = self;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        __weak typeof (self) wSelf = self;
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:[NSString stringWithFormat:@"是否确认使用此地址：%@%@%@%@%@ %@？",item.AName,item.BName,item.CName,item.DName,item.Address,item.Name]
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{

            [MineMyOrderModel doConfirmOrder:myOrderId addressId:[item.ID intValue] success:^(AFHTTPRequestOperation* opreation, NSObject* result){
                OneBaseParser* p = [[OneBaseParser alloc] initWithDictionary:(NSDictionary*)result];
                NSLog(@"%@",p);
                if([p.code intValue] == 0)
                {
                    [[XBToastManager ShardInstance] showtoast:@"添加收货信息成功"];
                    if(delegate)
                    {
                        [delegate refreshMyOrder];
                        [wSelf.navigationController popViewControllerAnimated:YES];
                    }
                }
            } failure:^(NSError* error){
                
            }];
            
        }], nil] show];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)indexPath.row;
    if(row >= myAddressData.list.count)
        return false;
    MineMyAddressItem* item = [myAddressData.list objectAtIndex:row];
    return ![item.Default boolValue];
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除地址";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        MineMyAddressItem* item = [myAddressData.list objectAtIndex:indexPath.row];
        if([item.Default boolValue])
            return;
        
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"是否确认删除该地址？"
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
            [[XBToastManager ShardInstance] showprogress];
            [MineMyAddressModel delMyAddress:[item.ID intValue] success:^(AFHTTPRequestOperation* operation, NSObject* result){
                [[XBToastManager ShardInstance] hideprogress];
                OneBaseParser* p = [[OneBaseParser alloc] initWithDictionary:(NSDictionary*)result];
                if([p.code intValue] == 0)
                {
                    NSMutableArray* tmp = [NSMutableArray arrayWithArray:myAddressData.list];
                    [tmp removeObjectAtIndex:indexPath.row];
                    myAddressData.list = tmp;
                    [tbView reloadData];
                    [[XBToastManager ShardInstance] showtoast:@"删除地址成功"];
                }
                else
                {
                    [[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"删除地址异常：%d",[p.code intValue]]];
                }
            } failure:^(NSError* error){
                [[XBToastManager ShardInstance] showprogress];
            }];
            
        }], nil] show];

    }
}

@end
