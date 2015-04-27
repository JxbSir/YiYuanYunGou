//
//  TabProductVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/18.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "TabProductVC.h"
#import "AllProView.h"
#import "SearchVC.h"
#import "ProductDetailVC.h"

typedef enum
{
    TbViewType_Type = 0,
    TbViewType_Order = 1
}TbViewType;

@interface TabProductVC ()<UITableViewDataSource,UITableViewDelegate,AllProViewDelegate>
{
    LMDropdownView  *dropdownView;
    
    UIButton        *btnType;
    UIButton        *btnOrder;
    AllProView      *allProView;
    
    UITableView     *tbViewType;
    
    TbViewType      tbType;
    NSArray         *arrOfType;
    NSArray         *arrOfTypeImage;
    NSArray         *arrOfOrder;
    NSArray         *arrOfOrderFlag;
    NSInteger       indexType;
    NSInteger       indexOrder;
}
@end

@implementation TabProductVC

- (id)init
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNewPro:) name:kDidShowNewPro object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所有商品";
    __weak typeof (self) wSelf = self;
    
    if(![OyTool ShardInstance].bIsForReview)
    {
        [self actionCustomRightBtnWithNrlImage:@"search" htlImage:@"search" title:@"" action:^{
            SearchVC* vc = [[SearchVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [wSelf.navigationController pushViewController:vc animated:YES];
        }];
        
        
        arrOfType = @[@"全部分类",@"手机数码",@"电脑办公",@"家用电器",@"化妆个护",@"钟表首饰",@"其他商品"];
        arrOfTypeImage = @[@"sort0",@"sort100",@"sort106",@"sort104",@"sort2",@"sort222",@"sort312"];
        arrOfOrder = @[@"即将揭晓",@"人气",@"价值（由高到低）",@"价值（由低到高）",@"最新"];
        arrOfOrderFlag = @[@"10",@"20",@"30",@"31",@"50"];
    }
    else
    {
        arrOfType = @[@"家用电器",@"化妆个护",@"钟表首饰",@"其他商品"];
        arrOfTypeImage = @[@"sort104",@"sort2",@"sort222",@"sort312"];
        arrOfOrder = @[@"即将揭晓",@"人气",@"价值（由高到低）",@"价值（由低到高）",@"最新"];
        arrOfOrderFlag = @[@"10",@"20",@"30",@"31",@"50"];
    }
    
    btnType = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mainWidth / 2, 44)];
    [btnType setTitle:[arrOfType objectAtIndex:0] forState:UIControlStateNormal];
    btnType.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnType setBackgroundColor:[UIColor hexFloatColor:@"f8f8f8"]];
    [btnType setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnType addTarget:self action:@selector(btnTypeAction) forControlEvents:UIControlEventTouchUpInside];
    [btnType setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [btnType setImageEdgeInsets:UIEdgeInsetsMake(0,0,8,8)];
    [self.view addSubview:btnType];
    
    btnOrder = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth / 2+0.5, 0, mainWidth / 2 - 0.5, 43.5)];
    [btnOrder setTitle:[arrOfOrder objectAtIndex:indexOrder] forState:UIControlStateNormal];
    btnOrder.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnOrder setBackgroundColor:[UIColor hexFloatColor:@"f8f8f8"]];
    [btnOrder setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnOrder addTarget:self action:@selector(btnOrderAction) forControlEvents:UIControlEventTouchUpInside];
    [btnOrder setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [btnOrder setImageEdgeInsets:UIEdgeInsetsMake(0,0,8,8)];
    [self.view addSubview:btnOrder];
    
    UIImageView *imgLine1 = [[UIImageView alloc] initWithFrame:CGRectMake(mainWidth / 2 + 0.5, 0, 0.5, 43.5)];
    imgLine1.backgroundColor = [UIColor hexFloatColor:@"dedede"];
    [self.view addSubview:imgLine1];
    
    UIImageView *imgLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43.5, mainWidth, 0.5)];
    imgLine2.backgroundColor = [UIColor hexFloatColor:@"dedede"];
    [self.view addSubview:imgLine2];
    
    tbViewType = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tbViewType.delegate = self;
    tbViewType.dataSource = self;
    tbViewType.backgroundColor = [UIColor whiteColor];
    tbViewType.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbViewType.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    tbType = TbViewType_Type;
    
    dropdownView = [[LMDropdownView alloc] init];
    dropdownView.menuBackgroundColor = [UIColor whiteColor];
    dropdownView.menuContentView = tbViewType;
    
    allProView = [[AllProView alloc] initWithOrder:CGRectMake(0, 44, mainWidth, self.view.bounds.size.height - 155) indexOrder:[[arrOfOrderFlag objectAtIndex:indexOrder] intValue]];
    allProView.delegate = self;
    allProView.proType = [[[arrOfTypeImage objectAtIndex:0] stringByReplacingOccurrencesOfString:@"sort" withString:@""] intValue];
    [self.view addSubview:allProView];
}

- (void)doClickProduct:(int)goodsId
{
    ProductDetailVC* vc = [[ProductDetailVC alloc] initWithGoodsId:goodsId codeId:0];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 *  btn action
 */
- (void)btnTypeAction
{
    if ([dropdownView isOpen] && tbType == TbViewType_Type)
    {
        tbType = TbViewType_Type;
        [dropdownView hide];
    }
    else
    {
        tbType = TbViewType_Type;
        [tbViewType reloadData];
        [dropdownView showInView:self.view withFrame:CGRectMake(0, 44, mainWidth, self.view.bounds.size.height - 44)];
    }
}

- (void)btnOrderAction
{
    if ([dropdownView isOpen] && tbType == TbViewType_Order)
    {
        tbType = TbViewType_Order;
        [dropdownView hide];
    }
    else
    {
        tbType = TbViewType_Order;
        [tbViewType reloadData];
        [dropdownView showInView:self.view withFrame:CGRectMake(0, 44, mainWidth, self.view.bounds.size.height - 44)];
    }
}

#pragma mark - notify
- (void)showNewPro:(NSNotification*)obj
{
    indexOrder = [obj.object intValue];
    if(btnOrder)
        [btnOrder setTitle:[arrOfOrder objectAtIndex:indexOrder] forState:UIControlStateNormal];
    if(allProView)
        [allProView setTypeAndOrder:[[[arrOfTypeImage objectAtIndex:indexType] stringByReplacingOccurrencesOfString:@"sort" withString:@""] intValue] sort:[[arrOfOrderFlag objectAtIndex:indexOrder] intValue]];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tbType == TbViewType_Type ? arrOfType.count : arrOfOrder.count;
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
    //static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell =  nil;//(UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
    }
    cell.textLabel.text = tbType == TbViewType_Type ? [NSString stringWithFormat:@"        %@", [arrOfType objectAtIndex:indexPath.row]] : [arrOfOrder objectAtIndex:indexPath.row];
    if(tbType == TbViewType_Type)
    {
        NSString* name = [arrOfTypeImage objectAtIndex:indexPath.row];
        if(indexPath.row == indexType)
        {
            name = [NSString stringWithFormat:@"%@_checked",name];
            cell.textLabel.textColor = mainColor;
            
            UIImageView* imgOK = [[UIImageView alloc] initWithFrame:CGRectMake(mainWidth - 32, 14, 20, 16)];
            imgOK.image = [UIImage imageNamed:@"screening_select"];
            [cell addSubview:imgOK];
        }
        else
        {
            name = [NSString stringWithFormat:@"%@_normal",name];
        }
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 24, 24)];
        img.image = [UIImage imageNamed:name];
        [cell addSubview:img];
    }
    else
    {
        if(indexPath.row == indexOrder)
        {
            cell.textLabel.textColor = mainColor;
            
            UIImageView* imgOK = [[UIImageView alloc] initWithFrame:CGRectMake(mainWidth - 32, 14, 20, 16)];
            imgOK.image = [UIImage imageNamed:@"screening_select"];
            [cell addSubview:imgOK];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    tbType == TbViewType_Type ? (indexType = indexPath.row) : (indexOrder = indexPath.row);
    tbType == TbViewType_Type ? ([btnType setTitle:[arrOfType objectAtIndex:indexPath.row] forState:UIControlStateNormal]) : ([btnOrder setTitle:[arrOfOrder objectAtIndex:indexPath.row] forState:UIControlStateNormal]);
    [tbViewType reloadData];
    [dropdownView hide];
    
    [allProView setTypeAndOrder:[[[arrOfTypeImage objectAtIndex:indexType] stringByReplacingOccurrencesOfString:@"sort" withString:@""] intValue] sort:[[arrOfOrderFlag objectAtIndex:indexOrder] intValue]];
}
@end
