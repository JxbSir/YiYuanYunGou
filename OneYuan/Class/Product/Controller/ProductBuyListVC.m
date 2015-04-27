//
//  ProductBuyListVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/1.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "ProductBuyListVC.h"
#import "ProdcutBuyModel.h"
#import "ProductBuyCell.h"

@interface ProductBuyListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    int _codeId;
    __block UITableView     *tbView;
    __block NSMutableArray  *arrData;
    __block int             curPage;
}
@end

@implementation ProductBuyListVC

- (id)initWithCodeId:(int)codeId
{
    self = [super init];
    if(self)
    {
        _codeId = codeId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"所有云购记录";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    __weak typeof(self) wSelf = self;
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


#pragma mark - getdata
- (void)getData:(void (^)(void))block
{
    __weak typeof(self) wSelf = self;
    [ProdcutBuyModel getGoodBuyList:_codeId page:curPage size:10 success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        if(block!=NULL)
            block();
        ProdcutBuyList* list = [[ProdcutBuyList alloc] initWithDictionary:(NSDictionary*)result];
        if (!arrData)
        {
            arrData = [NSMutableArray arrayWithArray:list.Rows];
        }
        else
        {
            [arrData addObjectsFromArray:list.Rows];
        }
        [tbView reloadData];
        [tbView setShowsInfiniteScrolling:arrData.count<[list.Count integerValue]];
        if(arrData.count ==0)
        {
            [wSelf showEmpty];
        }
    } failure:^(NSError* error){
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取云购记录页面数据异常:%@",error]];
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
    return 80;
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
    static NSString *CellIdentifier = @"proBuyCell";
    ProductBuyCell *cell =  (ProductBuyCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[ProductBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setBuy:[arrData objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
