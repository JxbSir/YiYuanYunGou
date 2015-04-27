//
//  MineMoneyDetailVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/25.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineMoneyDetailVC.h"
#import "MineMoneyCell.h"
#import "MineMoneyModel.h"

@interface MineMoneyDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __block UITableView     *tbView;
    __block NSMutableArray  *arrData;
    __block int             allCount;
    __block int             curPage;
    __block int             curState;
    
    __block UIView          *viewHead;
    __block UILabel         *lblCount;
    __block UILabel         *lblTip;
    
    __block UILabel         *lbl1;
    __block UILabel         *lbl2;
    __block UILabel         *lbl3;
    
    __block NSString        *strIn;
    __block NSString        *strOut;
}

@end

@implementation MineMoneyDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"账户明细";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UISegmentedControl* seg = [[UISegmentedControl alloc] initWithItems:@[@"充值明细",@"消费明细"]];
    seg.frame = CGRectMake(30, 10, mainWidth - 60, 32);
    [seg setTintColor:mainColor];
    [seg setSelectedSegmentIndex:0];
    [seg addTarget:self action:@selector(setSelectChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seg];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, mainWidth, 0.5)];
    line.backgroundColor = [UIColor hexFloatColor:@"dedede"];
    [self.view addSubview:line];

    viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 60, mainWidth, 25)];
    [self.view addSubview:viewHead];
    
    lblTip = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 15)];
    lblTip.text = @"总充值金额：";
    lblTip.textColor = [UIColor lightGrayColor];
    lblTip.font = [UIFont systemFontOfSize:13];
    [viewHead addSubview:lblTip];
    
    lblCount = [[UILabel alloc] initWithFrame:CGRectMake(75, 5, 200, 15)];
    lblCount.text = @"￥110.00";
    lblCount.textColor = mainColor;
    lblCount.font = [UIFont systemFontOfSize:13];
    [viewHead addSubview:lblCount];
    
    UIView* viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 90, mainWidth, 44)];
    viewTop.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewTop];
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 0.5)];
    line1.backgroundColor = [UIColor hexFloatColor:@"dedede"];
    [viewTop addSubview:line1];
    
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43.5, mainWidth, 0.5)];
    line2.backgroundColor = [UIColor hexFloatColor:@"dedede"];
    [viewTop addSubview:line2];
    
    lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 13)];
    lbl1.text = @"充值时间";
    lbl1.font = [UIFont systemFontOfSize:13];
    lbl1.textColor = [UIColor lightGrayColor];
    [viewTop addSubview:lbl1];
    
    lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(mainWidth / 2, 15, 100, 13)];
    lbl2.text = @"资金渠道";
    lbl2.font = [UIFont systemFontOfSize:13];
    lbl2.textColor = [UIColor lightGrayColor];
    [viewTop addSubview:lbl2];
    
    lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(mainWidth - 80, 15, 100, 13)];
    lbl3.text = @"充值金额";
    lbl3.font = [UIFont systemFontOfSize:13];
    lbl3.textColor = [UIColor lightGrayColor];
    [viewTop addSubview:lbl3];
    
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 134, mainWidth, self.view.bounds.size.height - 134) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = self.view.backgroundColor;
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    curPage = 1;
    curState = 0;
    
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
    
    strIn = @"￥0.00";
    strOut = @"￥0.00";
    
    [self setHeadMoney];
    
    [self getMoney];
}

#pragma mark - seg action
- (void)setSelectChange:(UISegmentedControl*)_seg
{
    [[XBToastManager ShardInstance] showprogress];
    arrData = nil;
    if (_seg.selectedSegmentIndex == 1)
    {
        curState = 1;
        
        lbl1.text = @"消费时间";
        [lbl2 setHidden:YES];
        lbl3.text = @"消费金额";
        
    }
    else {
        curState = 0;
        
        lbl1.text = @"充值时间";
        [lbl2 setHidden:NO];
        lbl3.text = @"充值金额";
    }
    
    [self setHeadMoney];
    
    [self getData:nil];
}

- (void)setHeadMoney
{
    if (curState == 0)
    {
        lblTip.text = @"总充值金额：";
        lblCount.text = strIn;
    }
    else
    {
        lblTip.text = @"总消费金额：";
        lblCount.text = strOut;
    }
    
    CGSize  s = [[NSString stringWithFormat:@"%@%@",lblTip.text,lblCount.text] textSizeWithFont:lblTip.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    viewHead.frame = CGRectMake((mainWidth - s.width) / 2, viewHead.frame.origin.y, s.width, s.height);
}

#pragma mark - getdata
- (void)getMoney
{
    __weak typeof (self) wSelf = self;
    [MineMoneyModel getMyMoneyAll:^(AFHTTPRequestOperation* operation,NSObject* result){
        NSString* body = (NSString*)result;
        strIn = [[Jxb_Common_Common sharedInstance] getMidString:body front:@"(充值总金额：" end:@")"];
        strOut = [[Jxb_Common_Common sharedInstance] getMidString:body front:@"(消费总金额：" end:@")"];
        [wSelf setHeadMoney];
    } failure:^(NSError* error){
        
    }];
}

- (void)getData:(void (^)(void))block
{
    __weak typeof (self) wself = self;
    [MineMoneyModel getMyMoneylist:curPage size:10 state:curState success:^(AFHTTPRequestOperation* operation,NSObject* result){
        if(block != NULL)
            block();
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        MineMoneyList* list = [[MineMoneyList alloc] initWithDictionary:(NSDictionary*)result];
        if(!arrData)
            arrData = [NSMutableArray arrayWithArray:list.listItems];
        else
            [arrData addObjectsFromArray:list.listItems];
        allCount = [list.count intValue];
        [tbView setShowsInfiniteScrolling:arrData.count < [list.count intValue]];
        [tbView reloadData];
        
        if(arrData.count == 0)
        {
            [wself showEmpty:CGRectMake(0, 150, mainWidth, tbView.frame.size.height)];
        }
        else
        {
            [wself hideEmpty];
        }
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取账户异常：%@",error]];
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
    return 44;
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
    MineMoneyOutItem* item = [arrData objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"mineOrderCell";
    MineMoneyCell *cell =  (MineMoneyCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[MineMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setMoney:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
