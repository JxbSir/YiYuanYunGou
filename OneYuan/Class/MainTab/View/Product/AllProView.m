//
//  AllProView.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/21.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "AllProView.h"
#import "AllProModel.h"
#import "AllProItemCell.h"

#define pageSize    10

@interface AllProView ()<UITableViewDataSource,UITableViewDelegate>
{
    __weak id<AllProViewDelegate> delegate;
    
    __block UITableView     *tbView;
    __block NSMutableArray  *arrPros;
    
    __block int       curPage;
    __block int       proType;
    __block int       proSort;
}

@end

@implementation AllProView
@synthesize delegate,proType;

- (id)initWithOrder:(CGRect)frame indexOrder:(int)indexOrder
{
    proSort = indexOrder;
    self = [self initWithFrame:frame];
    if(self)
    {
    
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        __weak typeof (self) wSelf = self;
        
        self.backgroundColor = [UIColor redColor];
        
        tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, frame.size.height) style:UITableViewStyleGrouped];
        tbView.delegate = self;
        tbView.dataSource = self;
        tbView.backgroundColor = [UIColor whiteColor];
        tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addSubview:tbView];
        proType = 0;
        [tbView addPullToRefreshWithActionHandler:^{
            __strong typeof (wSelf) sSelf = wSelf;
            sSelf->curPage = 1;
            [wSelf getDatas:sSelf->proType sort:sSelf->proSort block:^{
                sSelf->arrPros = nil;
            }];
        }];
        
        [tbView addInfiniteScrollingWithActionHandler:^{
            __strong typeof (wSelf) sSelf = wSelf;
            sSelf->curPage ++;
            [wSelf getDatas:sSelf->proType sort:sSelf->proSort block:nil];
        }];
        
        [tbView.pullToRefreshView setOYStyle];
        [tbView triggerPullToRefresh];
    }
    return self;
}

#pragma mark - set data
- (void)setTypeAndOrder:(int)type sort:(int)sort
{
    proType = type;
    proSort = sort;
    curPage = 1;
    __weak typeof (self) wSelf = self;
    [self getDatas:proType sort:proSort block:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->arrPros = nil;
    }];
}

#pragma mark - get data
- (void)getDatas:(int)type sort:(int)sort block:(void (^)(void))block
{
    [AllProModel getAllProduct:type sort:sort page:curPage size:pageSize success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        if(block!=NULL)
            block();
        AllProList* list = [[AllProList alloc] initWithDictionary:(NSDictionary*)result];
        if(!arrPros)
            arrPros = [NSMutableArray arrayWithArray:list.Rows];
        else
            [arrPros addObjectsFromArray:list.Rows];
        [tbView reloadData];
        [tbView setShowsInfiniteScrolling:arrPros.count < [list.count intValue]];
    }   failure:^(NSError* error){
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取商品数据异常:%@",error]];
    }];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrPros.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
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
    static NSString *CellIdentifier = @"allProItemCell";
    AllProItemCell *cell = (AllProItemCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[AllProItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setProItem:[arrPros objectAtIndex:indexPath.row] type:ProCellType_All];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int proid = [[[arrPros objectAtIndex:indexPath.row] goodsID] intValue];
    if(delegate)
    {
        [delegate doClickProduct:proid];
    }
}

@end
