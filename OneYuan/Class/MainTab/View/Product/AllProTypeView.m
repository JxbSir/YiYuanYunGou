//
//  AllProTypeView.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/22.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "AllProTypeView.h"

@interface AllProTypeView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *tbView;
    
    NSArray         *arrOfType;
    NSArray         *arrOfTypeImage;
    NSInteger       indexType;
    
    __weak id<AllProTypeViewDelegate> delegate;
}
@end

@implementation AllProTypeView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor redColor];
        
        tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, frame.size.height) style:UITableViewStyleGrouped];
        tbView.delegate = self;
        tbView.dataSource = self;
        tbView.backgroundColor = [UIColor whiteColor];
        tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:tbView];
        
        if(![OyTool ShardInstance].bIsForReview)
        {
            arrOfType = @[@"全部分类",@"手机数码",@"电脑办公",@"家用电器",@"化妆个护",@"钟表首饰",@"其他商品"];
            arrOfTypeImage = @[@"sort0",@"sort100",@"sort106",@"sort104",@"sort2",@"sort222",@"sort312"];
        }
        else
        {
            arrOfType = @[@"家用电器",@"化妆个护",@"钟表首饰",@"其他商品"];
            arrOfTypeImage = @[@"sort104",@"sort2",@"sort222",@"sort312"];
        }
    }
    return self;
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  arrOfType.count;
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
    cell.textLabel.text = [NSString stringWithFormat:@"        %@", [arrOfType objectAtIndex:indexPath.row]];
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

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    indexType = indexPath.row;
    [tbView reloadData];
    
    if(delegate)
    {
        NSString* code = [[arrOfTypeImage objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@"sort" withString:@""];
        [delegate selectedTypeCode:[code intValue]];
    }
}

@end
