//
//  SettingVC.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/26.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "SettingVC.h"
#import "UserInstance.h"
#import "SettingExitCell.h"
#import "SettingWifiCell.h"
#import "SettingCommonCell.h"
#import "SettingFeedListVC.h"
#import "SettingServiceVC.h"

@interface SettingVC ()<UITableViewDataSource,UITableViewDelegate,SettingExitCellDelegate>
{
    __block UITableView *tbView;
    
    NSArray     *arrNames;
}
@end

@implementation SettingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    __weak typeof (self) wSelf = self;
    
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
    
    arrNames = @[@[@"意见反馈",@"2G/3G/4G网络开启无图模式",@"清除缓存"],@[@"服务协议"]];//,@"版本更新"
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrNames.count + ([UserInstance ShardInstnce].userId ? 1 : 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section>=arrNames.count)
        return 1;
    NSArray* arr = (NSArray*)[arrNames objectAtIndex:section];
    return  arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section >= arrNames.count)
        return 60;
    return 44;
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
    if(indexPath.section >= arrNames.count)
    {
        static NSString *CellIdentifier = @"setExitCell";
        SettingExitCell *cell = (SettingExitCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[SettingExitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setDelegate:self];
        return cell;
    }
    if(indexPath.section == 0 && indexPath.row == 1)
    {
        static NSString *CellIdentifier = @"setWifiCell";
        SettingWifiCell *cell = (SettingWifiCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[SettingWifiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSArray* arr = (NSArray*)[arrNames objectAtIndex:indexPath.section];
        cell.textLabel.text = [arr objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor grayColor];
        return cell;
    }
    if(indexPath.section == 0 && indexPath.row == 2)
    {
        static NSString *CellIdentifier = @"setWifiCell";
        SettingCommonCell *cell = (SettingCommonCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[SettingCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSArray* arr = (NSArray*)[arrNames objectAtIndex:indexPath.section];
        cell.textLabel.text = [arr objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor grayColor];
        
        NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleId];
        CGFloat size = [self folderSizeAtPath:path];
        if(size > 10)
        {
            if(size < 1000)
            {
                [cell setSubText:[NSString stringWithFormat:@"%.0f B",size]];
            }
            else if(size < 1000 * 1000)
            {
                [cell setSubText:[NSString stringWithFormat:@"%.2f KB",size / 1000]];
            }
            else
            {
                [cell setSubText:[NSString stringWithFormat:@"%.2f MB",size / 1000 / 1000]];
            }
        }
        else
            [cell setSubText:@""];
        return cell;
    }
    if(indexPath.section == 0 && indexPath.row == 3)
    {
        static NSString *CellIdentifier = @"setWifiCell";
        SettingCommonCell *cell = (SettingCommonCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[SettingCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSArray* arr = (NSArray*)[arrNames objectAtIndex:indexPath.section];
        cell.textLabel.text = [arr objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor grayColor];
        
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [cell setSubText:[NSString stringWithFormat:@"当前版本：v%@",version]];
        return cell;
    }
    static NSString *CellIdentifier = @"allProItemCell";
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(indexPath.section >= arrNames.count)
    {
        return cell;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSArray* arr = (NSArray*)[arrNames objectAtIndex:indexPath.section];
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            SettingFeedListVC* vc = [[SettingFeedListVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == 2)
        {
            NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleId];
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            
            [[XBToastManager ShardInstance] showtoast:@"缓存清除成功"];
            
            [tbView reloadData];
        }
        else if (indexPath.row == 3)
        {
            [[XBToastManager ShardInstance] showprogress];
            [MobClick checkUpdateWithDelegate:self selector:@selector(checkApp:)];
        }
    }
    else if (indexPath.section == 1)
    {
        SettingServiceVC* vc = [[SettingServiceVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - app update
- (void)checkApp:(NSDictionary*)dicInfo
{
    [[XBToastManager ShardInstance] hideprogress];
    if ([[dicInfo objectForKey:@"update"] boolValue])
    {
        NSString* title = [NSString stringWithFormat:@"新版本来咯 v%@",[dicInfo objectForKey:@"version"]];
        NSString* body = [dicInfo objectForKey:@"update_log"];
        NSString* url = [dicInfo objectForKey:@"path"];
        [[[UIAlertView alloc] initWithTitle:title
                                    message:body
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"下次再更新" action:nil]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"立即更新" action:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }], nil] show];
    }
    else
    {
        [[XBToastManager ShardInstance] showtoast:@"当前已经是最新版本"];
    }
}

#pragma mark - delegate
- (void)btnExitClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - get file size
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}
@end
