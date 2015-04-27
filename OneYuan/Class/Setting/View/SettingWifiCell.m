//
//  SettingWifiCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/2.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "SettingWifiCell.h"

@implementation SettingWifiCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UISwitch* swWifi = [[UISwitch alloc] initWithFrame:CGRectMake(mainWidth - 60, 5, mainWidth - 50, 34)];
        [swWifi setTintColor:mainColor];
        [swWifi setOnTintColor:mainColor];
        [swWifi addTarget:self action:@selector(btnOpenWifi:) forControlEvents:UIControlEventValueChanged];
        BOOL on = [[[NSUserDefaults standardUserDefaults] objectForKey:kNoMapMode] boolValue];
        [swWifi setOn:on];
        [self addSubview:swWifi];
    }
    return self;
}

- (void)btnOpenWifi:(id)sender
{
    UISwitch* btn = (UISwitch*)sender;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:btn.on] forKey:kNoMapMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
