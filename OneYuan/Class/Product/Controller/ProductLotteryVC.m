//
//  ProductLotteryVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/28.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "ProductLotteryVC.h"
#import "ProductModel.h"
#import "ProductLotteryTopCell.h"
#import "ProductLotteryCodeCell.h"
#import "ShowOrderListVC.h"
#import "ProductBuyListVC.h"
#import "ProductLotteryOptView.h"
#import "ProductDetailVC.h"
#import "AllProModel.h"

@interface ProductLotteryVC ()<UITableViewDataSource,UITableViewDelegate,ProductLotteryOptViewDelegate>
{
    int _goodsId;
    int _codeId;
    
    __block ProductLotteryOptView   *optView;
    __block UITableView             *tbView;
    
    __block ProductLotteryDetail    *_detail;
    __block AllProPeriodList        *_allCodePeriod;
}
@end

@implementation ProductLotteryVC

- (id)initWithGoods:(int)goodsId codeId:(int)codeId
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
    self.title = @"揭晓结果";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    __weak typeof(self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    CGFloat margin = 0;
    if(![OyTool ShardInstance].bIsForReview)
    {
        margin = 44;
        optView = [[ProductLotteryOptView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 107, mainWidth, 44)];
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
    [tbView.pullToRefreshView setOYStyle];
    
    [self getData];
    
    [self showLoad];
    
    [self getProductAllCodes];
}

- (void)getData
{
    __weak typeof(self) wSelf = self;
    [ProductModel getGoodLottery:_codeId success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [[XBToastManager ShardInstance] hideprogress];
        [wSelf hideLoad];
        [tbView.pullToRefreshView stopAnimating];
        _detail = [[ProductLotteryDetail alloc] initWithDictionary:(NSDictionary*)result];
        [tbView reloadData];
    } failure:^(NSError* error){
        [wSelf hideLoad];
        [tbView.pullToRefreshView stopAnimating];
    }];
}

- (void)getProductAllCodes
{
    __weak typeof(self) wSelf = self;
    [AllProModel getGoodsPeriodByCodeId:_codeId success:^(AFHTTPRequestOperation* operation, NSObject* result){
        _allCodePeriod = [[AllProPeriodList alloc] initWithDictionary:(NSDictionary*)result];
        AllProPeriod* p = nil;
        int index = -1;
        for (AllProPeriod* period in _allCodePeriod.Rows) {
            index ++;
            if([period.codeState intValue] == 3)
            {
                p = period;
                break;
            }
        }
        [optView setBtnPeriod:[_allCodePeriod.Rows objectAtIndex:0]];
        if(index > 0)
        {
            NSMutableArray* tmp = [NSMutableArray arrayWithArray:_allCodePeriod.Rows];
            for(int i =0;i<index;i++)
            {
                [tmp removeObjectAtIndex:0];
            }
            _allCodePeriod.Rows = tmp;
        }
        if([p.codeID intValue] != _codeId)
        {
            _codeId = [p.codeID intValue];
            [wSelf getData];
        }
        else
            [tbView reloadData];
    } failure:^(NSError* error){
        
    }];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return !_detail ? 0 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    if(section == 2)
        return 1+_detail.Rows4.count;
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 100;
    if(indexPath.section == 2 && indexPath.row >0)
    {
        ProductCodeBuy* codes = [_detail.Rows4 objectAtIndex:indexPath.row - 1];
        NSString* codeList = [codes rnoNum];
        CGSize s = [codeList textSizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(mainWidth - 30, 999) lineBreakMode:NSLineBreakByWordWrapping];
        return s.height + 40;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 0.1;
    if(section == 2)
        return 50;
    return 10;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 2)
    {
        UIView* vvv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 50)];
     
        if(_allCodePeriod)
        {
            UIButton* btnPrev = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
            [btnPrev setImage:[UIImage imageNamed:@"prev"] forState:UIControlStateNormal];
            [btnPrev addTarget:self action:@selector(btnPrevAction) forControlEvents:UIControlEventTouchUpInside];
            [vvv addSubview:btnPrev];
            
            if(_allCodePeriod)
            {
                AllProPeriod* percode = [_allCodePeriod.Rows objectAtIndex:0];
                if(_codeId == [percode.codeID intValue])
                {
                    btnPrev.hidden = YES;
                }
                else if(_allCodePeriod.Rows.count >1)
                {
                    percode = [_allCodePeriod.Rows objectAtIndex:1];
                    if(_codeId == [percode.codeID intValue])
                    {
                        btnPrev.hidden = YES;
                    }
                }
            }
            
            UIButton* btnNext = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth - 40 - 5, 5, btnPrev.frame.size.width, btnPrev.frame.size.height)];
            [btnNext setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
            [btnNext addTarget:self action:@selector(btnNextAction) forControlEvents:UIControlEventTouchUpInside];
            [vvv addSubview:btnNext];
            
            if(_allCodePeriod)
            {
                AllProPeriod* percode = [_allCodePeriod.Rows objectAtIndex:_allCodePeriod.Rows.count - 1];
                if(_codeId == [percode.codeID intValue])
                {
                    btnNext.hidden = YES;
                }
            }
        }
        
        NSString* str = [NSString stringWithFormat:@"(第%d期)幸运云购码：%@",[_detail.Rows2.codePeriod intValue],[_detail.Rows2.codeRNO stringValue]];
        
        CGSize s = [str textSizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake((mainWidth - s.width) / 2, 18, 300, 15)];
        lbl.text = [NSString stringWithFormat:@"(第%d期)幸运云购码：",[_detail.Rows2.codePeriod intValue]];
        lbl.font = [UIFont systemFontOfSize:15];
        lbl.textColor = [UIColor grayColor];
        [vvv addSubview:lbl];
        
        s = [lbl.text textSizeWithFont:lbl.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        
        UILabel* lblCode = [[UILabel alloc] initWithFrame:CGRectMake(lbl.frame.origin.x + s.width, lbl.frame.origin.y, 100, 15)];
        lblCode.text = [_detail.Rows2.codeRNO stringValue];
        lblCode.font = [UIFont systemFontOfSize:15];
        lblCode.textColor = mainColor;
        [vvv addSubview:lblCode];
        
        return vvv;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"lotteryTopCell";
        ProductLotteryTopCell *cell =  (ProductLotteryTopCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[ProductLotteryTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setLottery:_detail];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"lotterybotCell";
        UITableViewCell *cell =  (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"所有云购记录";
        }
        else
        {
            cell.textLabel.text = @"商品晒单";
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor grayColor];
        return cell;
    }
    else if(indexPath.section == 2)
    {
        if(indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"lotteryCTCell";
            UITableViewCell *cell =  (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = [NSString stringWithFormat:@"商品获得者本期总共云购 %d 人次",[_detail.Rows2.codeRUserBuyCount intValue]];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor grayColor];
            return cell;
        }
        else
        {
            static NSString *CellIdentifier = @"lotteryCodeCell";
            ProductLotteryCodeCell *cell =  (ProductLotteryCodeCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[ProductLotteryCodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setCodes:[_detail.Rows4 objectAtIndex:indexPath.row - 1]];
            return cell;
        }
    }
    static NSString *CellIdentifier = @"productTopCell";
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
            ProductBuyListVC* vc = [[ProductBuyListVC alloc] initWithCodeId:_codeId];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            ShowOrderListVC* vc = [[ShowOrderListVC alloc] initWithGoodsId:_goodsId];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)btnNextAction
{
    if(_allCodePeriod)
    {
        int cur = 0;
        for (int i = 0;i<_allCodePeriod.Rows.count;i++) {
            AllProPeriod* period = [_allCodePeriod.Rows objectAtIndex:i];
            if([period.codeID intValue] == _codeId)
            {
                cur = i;
                break;
            }
        }
        if(cur+1 >= _allCodePeriod.Rows.count)
            return;
        int nextCode = [[[_allCodePeriod.Rows objectAtIndex:cur+1] codeID] intValue];
        if(nextCode > 0)
        {
            [[XBToastManager ShardInstance] showprogress];
            _codeId = nextCode;
            [self getData];
        }
    }
}

- (void)btnPrevAction
{
    if(_allCodePeriod)
    {
        int cur = 0;
        for (int i = 0;i<_allCodePeriod.Rows.count;i++) {
            AllProPeriod* period = [_allCodePeriod.Rows objectAtIndex:i];
            if([period.codeID intValue] == _codeId)
            {
                cur = i;
                break;
            }
        }
        if(cur<=1)
        {
            return;
        }
        else
        {
            int nextCode = [[[_allCodePeriod.Rows objectAtIndex:cur-1] codeID] intValue];
            if(nextCode > 0)
            {
                [[XBToastManager ShardInstance] showprogress];
                _codeId = nextCode;
                [self getData];
            }
        }
    }
}

#pragma mark - delegate
- (void)gotoCartAction
{
    self.tabBarController.selectedIndex = 3;
    [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.2];
}

- (void)gotoDetailAction
{
    ProductDetailVC* vc = [[ProductDetailVC alloc] initWithGoodsId:_goodsId codeId:_codeId];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
