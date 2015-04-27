//
//  SearchVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/27.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "SearchVC.h"
#import "SearchModel.h"
#import "AllProModel.h"
#import "AllProItemCell.h"
#import "ProductDetailVC.h"
#import "SearchCartView.h"
#import "CartModel.h"

@interface SearchVC ()<UITableViewDataSource,UITableViewDelegate,SearchCartViewDelegate,UITextFieldDelegate>
{
    NSString* mySearchKey;
    UITextField             *txtKey;
    __block SearchCartView  *searchCart;
    __block UITableView     *tbView;
    __block NSArray         *arrData;
}
@end

@implementation SearchVC

- (id)initWithKey:(NSString *)key
{
    self = [super init];
    if(self)
    {
        mySearchKey = key;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToCart) name:kDidAddCartSearch object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"商品搜索";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    __weak typeof (self) wSelf = self;
    
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, mainWidth, self.view.bounds.size.height - 44) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    searchCart = [[SearchCartView alloc] initWithFrame:CGRectMake(mainWidth - 100, self.view.bounds.size.height - 120, 50, 50)];
    searchCart.hidden = YES;
    searchCart.delegate = self;
    [self.view addSubview:searchCart];
    
    
    UIView* vSearch = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 44)];
    vSearch.backgroundColor = [UIColor hexFloatColor:@"f68e49"];
    [self.view addSubview:vSearch];
    
    UIView* vSearchTxt = [[UIView alloc] initWithFrame:CGRectMake(10, 7, mainWidth - 80, 30)];
    vSearchTxt.backgroundColor = [UIColor whiteColor];
    vSearchTxt.layer.cornerRadius = 15;
    [self.view addSubview:vSearchTxt];
    
    UIImageView* imgSearch = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 14, 14)];
    imgSearch.image = [UIImage imageNamed:@"search-1"];
    [vSearchTxt addSubview:imgSearch];
    
    txtKey = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, mainWidth - 110, 30)];
    txtKey.placeholder = @"搜索 iPhone 试试";
    txtKey.font = [UIFont systemFontOfSize:13];
    txtKey.text = mySearchKey;
    txtKey.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtKey.returnKeyType = UIReturnKeySearch;
    txtKey.delegate = self;
    [vSearchTxt addSubview:txtKey];
    
    UIButton* btnSearch = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth - 60, 12, 50, 20)];
    [btnSearch setTitle:@"搜索" forState:UIControlStateNormal];
    [btnSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(doSearchAction) forControlEvents:UIControlEventTouchUpInside];
    [vSearch addSubview: btnSearch];
    
    if (!mySearchKey)
    {
        [self showEmpty:CGRectMake(0, 44, mainWidth, self.view.bounds.size.height - 150)];
    }
    else
    {
        [self searchItems];
    }
}

- (void)searchItems
{
    [txtKey resignFirstResponder];
    __weak typeof (self) wSelf = self;
    [[XBToastManager ShardInstance] showprogress];
    [SearchModel searchItems:mySearchKey success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [[XBToastManager ShardInstance] hideprogress];
        AllProList* list = [[AllProList alloc] initWithDictionary:(NSDictionary*)result];
        arrData = list.Rows;
        [tbView reloadData];
        if(arrData.count == 0)
        {
            [searchCart setHidden:YES];
            [wSelf showEmpty:CGRectMake(0, 44, mainWidth, self.view.bounds.size.height - 150)];
        }
        else
        {
            [searchCart setHidden:NO];
            [wSelf hideEmpty];
        }
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"搜索商品异常：%@",error]];
    }];
}

- (void)doSearchAction
{
    if(txtKey.text.length == 0 || [txtKey.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入关键词"];
        return;
    }
    mySearchKey = txtKey.text;
    [self searchItems];
}

#pragma mark - notify
- (void)addToCart
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            [CartModel quertCart:nil value:nil block:^(NSArray* result){
                [searchCart setCartNum:(int)result.count];
            }];
        });
    });
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
    [cell setProItem:[arrData objectAtIndex:indexPath.row] type:ProCellType_Search];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int goodsId = [[[arrData objectAtIndex:indexPath.row] goodsID] intValue];
    
    ProductDetailVC* vc = [[ProductDetailVC alloc] initWithGoodsId:goodsId codeId:0];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - delegate
- (void)gotoCart
{
    self.tabBarController.selectedIndex = 3;
    [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.2];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:txtKey])
    {
        [self doSearchAction];
        return true;
    }
    return false;
}
@end
