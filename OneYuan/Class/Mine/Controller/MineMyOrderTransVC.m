//
//  MineMyOrderTransVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/28.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineMyOrderTransVC.h"
#import "MineMyOrderModel.h"
#import "MineMyOrderTransModel.h"
#import "MineOrderTranAddressCell.h"
#import "MineOrderTranMsgCell.h"

@interface MineMyOrderTransVC()<UITableViewDataSource,UITableViewDelegate>
{
    int     myNo;
    
    __block UITableView         *tbView;
    __block MineMyOrderTrans    *tranItem;
}
@end

@implementation MineMyOrderTransVC

- (id)initWithNo:(int)no
{
    self = [super init];
    if(self)
    {
        myNo = no;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"获得的商品";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];

    tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = self.view.backgroundColor;
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    [tbView addPullToRefreshWithActionHandler:^{
        [wSelf getData];
    }];
    [tbView.pullToRefreshView setOYStyle];
    [tbView triggerPullToRefresh];

}

- (void)getData
{
    [MineMyOrderTransModel getUserOrderTrans:myNo success:^(AFHTTPRequestOperation* operation,NSObject* result){
        [tbView.pullToRefreshView stopAnimating];
        tranItem = [[MineMyOrderTrans alloc] init];
        NSString* body = (NSString*)result;
        tranItem.tranCompany = [[Jxb_Common_Common sharedInstance] getMidString:body front:@"快递公司：" end:@"<"];
        tranItem.tranNo = [[Jxb_Common_Common sharedInstance] getMidString:body front:@"快递单号：" end:@"<"];
        NSString* address = [[Jxb_Common_Common sharedInstance] getMidString:body front:@"收货信息</p>" end:@"</div>"];
        tranItem.tranAddress = [address stringByReplacingOccurrencesOfString:@"<br/>" withString:@"  "];
        
        NSString* tmp = [[Jxb_Common_Common sharedInstance] getMidString:body front:@"<article class=\"clearfix m-round m-address-rst\">" end:@"</ul>"];
        NSArray* arr = [[Jxb_Common_Common sharedInstance] getSpiltString:tmp split:@"<li>"];
        NSMutableArray* arrInfo = [NSMutableArray array];
        for(int i = 1; i< arr.count; i++)
        {
            NSString* item = [arr objectAtIndex:i];
            NSString* msg = [[[Jxb_Common_Common sharedInstance] getMidString:item front:@"</p>" end:@"</li>"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString* name = [[Jxb_Common_Common sharedInstance] getMidString:item front:@"<span class=\"fr\">" end:@"<"];
            NSString* time = [[[Jxb_Common_Common sharedInstance] getMidString:item front:@"</span>" end:@"</p>"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            MineMyOrderTransInfo* info = [[MineMyOrderTransInfo alloc] init];
            info.msg = msg;
            info.time = [NSString stringWithFormat:@"%@ (%@)",time,name];
            [arrInfo addObject:info];
        }
        tranItem.tranInfos = arrInfo;
        [tbView reloadData];
    } failure:^(NSError* error){
        [tbView.pullToRefreshView stopAnimating];
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取商品物流异常：%@",error]];
    }];

}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tranItem)
        return 2;
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    return tranItem.tranInfos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        NSString* address = [NSString stringWithFormat:@"配送地址：%@" , tranItem.tranAddress];
        CGSize s = [address textSizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(mainWidth - 32, 999) lineBreakMode:NSLineBreakByWordWrapping];
        return 40 + s.height;
    }
    if(indexPath.section == 1)
    {
        MineMyOrderTransInfo* info = [tranItem.tranInfos objectAtIndex:tranItem.tranInfos.count - 1 - indexPath.row];
        CGSize s = [info.msg textSizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(mainWidth - 60, 999) lineBreakMode:NSLineBreakByCharWrapping];
        return s.height + 30;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
        return 10;
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"mineOrderTranCell";
        MineOrderTranAddressCell *cell =  (MineOrderTranAddressCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[MineOrderTranAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setTrans:tranItem];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"mineOrderMsgCell";
        MineOrderTranMsgCell *cell =  (MineOrderTranMsgCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[MineOrderTranMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setTrans:[tranItem.tranInfos objectAtIndex:tranItem.tranInfos.count - 1 - indexPath.row] index:(int)indexPath.row last:tranItem.tranInfos.count - 1 == indexPath.row];
        return cell;
    }
    static NSString *CellIdentifier = @"mineOrderCell";
    UITableViewCell *cell =  (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

@end
