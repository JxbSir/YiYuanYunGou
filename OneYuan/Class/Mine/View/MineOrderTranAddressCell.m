//
//  MineOrderTranAddressCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/28.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineOrderTranAddressCell.h"

@interface MineOrderTranAddressCell()
{
    UILabel* lblCom;
    UILabel* lblNo;
    UILabel* lblAddress;
}
@end

@implementation MineOrderTranAddressCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        lblCom = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, mainWidth - 32, 14)];
        lblCom.textColor = [UIColor grayColor];
        lblCom.font = [UIFont systemFontOfSize:15];
        [self addSubview:lblCom];
        
        lblNo = [[UILabel alloc] init];
        lblNo.textColor = mainColor;
        lblNo.font = [UIFont systemFontOfSize:15];
        [self addSubview:lblNo];
        
        UIImageView* imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, mainWidth - 20, 0.5)];
        imgLine.backgroundColor = [UIColor hexFloatColor:@"dedede"];
        [self addSubview:imgLine];
        
        lblAddress = [[UILabel alloc] init];
        lblAddress.textColor = [UIColor lightGrayColor];
        lblAddress.font = [UIFont systemFontOfSize:13];
        lblAddress.numberOfLines = 0;
        lblAddress.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblAddress];
        
    }
    return self;
}

- (void)setTrans:(MineMyOrderTrans*)trans
{
    if(trans.tranNo)
    {
        lblCom.text = [trans.tranCompany stringByAppendingString:@":"];
        lblNo.text = trans.tranNo;
        CGSize s = [lblCom.text textSizeWithFont:lblCom.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lblNo.frame = CGRectMake(lblCom.frame.origin.x + s.width + 10, 10, 200, 14);
    }
    else
    {
        lblCom.text = @"仓库正在紧急备货";
    }
    
    
    lblAddress.text = [NSString stringWithFormat:@"配送地址：%@" , trans.tranAddress];
    CGSize s1 = [lblAddress.text textSizeWithFont:lblAddress.font constrainedToSize:CGSizeMake(mainWidth - 32, 999) lineBreakMode:NSLineBreakByWordWrapping];
    lblAddress.frame = CGRectMake(16, 35, mainWidth - 32, s1.height);
}
@end
