//
//  MineMoneyCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/25.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineMoneyCell.h"

@interface MineMoneyCell ()
{
    UILabel* lblTime;
    UILabel* lblSource;
    UILabel* lblMoney;
}

@end

@implementation MineMoneyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 16, 200, 13)];
        lblTime.textColor = [UIColor lightGrayColor];
        lblTime.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblTime];
        
        lblSource = [[UILabel alloc] initWithFrame:CGRectMake(mainWidth / 2, 16, 200, 13)];
        lblSource.textColor = [UIColor lightGrayColor];
        lblSource.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblSource];
        
        lblMoney = [[UILabel alloc] initWithFrame:CGRectMake(mainWidth - 80, 16, 200, 13)];
        lblMoney.textColor = [UIColor lightGrayColor];
        lblMoney.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblMoney];
        
    }
    return self;
}

- (void)setMoney:(MineMoneyOutItem *)money
{
    lblTime.text = money.logTime;
    [lblSource setHidden:!money.typeName];
    lblSource.text = money.typeName;
    lblMoney.text = [NSString stringWithFormat:@"￥%@",money.logMoney];
}
@end
