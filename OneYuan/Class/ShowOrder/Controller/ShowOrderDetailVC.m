//
//  ShowOrderDetailVC.M
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/28.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "ShowOrderDetailVC.H"
#import "ShowOrderModel.h"
#import "ShowOrderPostTopCell.h"

@interface ShowOrderDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    int     _postId;
    __block UITableView         *tbView;
    __block ShowOrderPostItem   *_item;
    __block ShowOrderReplyList  *_reply;
}
@end

@implementation ShowOrderDetailVC

- (id)initWithPostId:(int)postId
{
    self = [super init];
    if(self)
    {
        _postId = postId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"晒单详情";
    __weak typeof (self) wSelf = self;
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
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
    
    [self getData];
    
    [self showLoad];
}

- (void)getData
{
    __weak typeof (self) wSelf = self;
    [ShowOrderModel getPostDetail:_postId success:^(AFHTTPRequestOperation* opretaion, NSObject* result){
        [wSelf hideLoad];
        ShowOrderPostDetail* list = [[ShowOrderPostDetail alloc] initWithDictionary:(NSDictionary*)result];
        _item = list.Rows;
        [tbView reloadData];
    } failure:^(NSError* error){
        [wSelf hideLoad];
       // [[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取晒单详情异常：%@",error]];
    }];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return !_item ? 0 : (!_reply ? 1 : 2);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1)
    {
        return _reply.Rows.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        CGSize s = [_item.postContent textSizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(mainWidth - 20, 999) lineBreakMode:NSLineBreakByCharWrapping];
        int count = (int)[[Jxb_Common_Common sharedInstance] getSpiltString:_item.postAllPic split:@"," ].count;
        CGFloat height = 120 + s.height + (count > 6 ? 6 : count) * 320;
        return height;
    }
    return 33;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 0.1;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"showPostTopCell";
        ShowOrderPostTopCell *cell = (ShowOrderPostTopCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[ShowOrderPostTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setPost:_item];
        return cell;
    }
    
    static NSString *CellIdentifier = @"newedCell";
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
