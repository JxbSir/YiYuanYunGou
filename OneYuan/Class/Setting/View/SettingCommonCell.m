//
//  SettingCommonCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/2.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "SettingCommonCell.h"

@interface SettingCommonCell ()
{
    UILabel *lbl;
}
@end

@implementation SettingCommonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 200, 15)];
        lbl.textColor =[UIColor lightGrayColor];
        lbl.font = [UIFont systemFontOfSize:12];
        [self addSubview:lbl];
    }
    return self;
}

- (void)setSubText:(NSString*)str
{
    lbl.text = str;
}
@end
