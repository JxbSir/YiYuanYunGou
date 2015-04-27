//
//  SettingExitCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/2.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "SettingExitCell.h"
#import "UserInstance.h"

@interface SettingExitCell ()
{
    __weak id<SettingExitCellDelegate> delegate;
}
@end

@implementation SettingExitCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton* btnExit = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, mainWidth - 40, 50)];
        [btnExit setBackgroundColor:mainColor];
        [btnExit setTitle:@"退出登录" forState:UIControlStateNormal];
        btnExit.layer.cornerRadius = 6;
        [btnExit addTarget:self action:@selector(btnExitAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnExit];
    }
    return self;
}

- (void)btnExitAction
{
    [[[UIAlertView alloc] initWithTitle:nil
                                message:@"是否确认退出当前用户？"
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                       otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
        
        [[UserInstance ShardInstnce] logout];
        if(delegate)
        {
            [delegate btnExitClick];
        }
        
    }], nil] show];

}

@end
