//
//  NewestedCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/22.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "NewestedCell.h"

@interface NewestedCell ()
{
    UIImageView *imgProduct;
    UIImageView *imgHead;
    UILabel     *lblName;
    UILabel     *lblCode;
    UILabel     *lblPrice;
    UILabel     *lblTime;
}
@end

@implementation NewestedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        
        imgProduct = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        imgProduct.image = [UIImage imageNamed:@"noimage"];
        imgProduct.layer.borderWidth = 0.5;
        imgProduct.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgProduct.layer.cornerRadius = 10;
        [self addSubview:imgProduct];
        
        imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(mainWidth - 50, 10, 40, 40)];
        imgHead.image = [UIImage imageNamed:@"noimage"];
        imgHead.layer.cornerRadius = 20;
        imgHead.layer.masksToBounds = YES;
        [self addSubview:imgHead];
        
        UILabel* lblName1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 100, 15)];
        lblName1.text = @"获得者：";
        lblName1.textColor = [UIColor grayColor];
        lblName1.font = [UIFont systemFontOfSize:14];
        [self addSubview:lblName1];
        
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, mainWidth - 200, 15)];
        lblName.textColor = [UIColor hexFloatColor:@"3385ff"];
        lblName.font = [UIFont systemFontOfSize:14];
        [self addSubview:lblName];
        
        UILabel* lblCode1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 100, 15)];
        lblCode1.text = @"本期云购：";
        lblCode1.textColor = [UIColor lightGrayColor];
        lblCode1.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblCode1];
        
        lblCode = [[UILabel alloc] initWithFrame:CGRectMake(155, 30, mainWidth - 200, 15)];
        lblCode.textColor = mainColor;
        lblCode.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblCode];
        
        lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, mainWidth - 200, 15)];
        lblPrice.textColor = [UIColor lightGrayColor];
        lblPrice.font = [UIFont systemFontOfSize:11];
        [self addSubview:lblPrice];
        
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(100, 75, mainWidth - 200, 15)];
        lblTime.textColor = [UIColor lightGrayColor];
        lblTime.font = [UIFont systemFontOfSize:11];
        [self addSubview:lblTime];
        
    }
    return self;
}

- (void)setNewed:(NewestProItme*)newed
{
    [imgProduct setImage_oy:oyImageBaseUrl image:newed.codeGoodsPic];
    
    [imgHead setImage_oy:oyHeadBaseUrl image:newed.userPhoto];
    
    lblName.text = newed.userName;
    lblCode.text = [NSString stringWithFormat:@"%d 人次", [newed.codeRUserBuyCount intValue]];
    
    lblPrice.text = [NSString stringWithFormat:@"价值：￥%.2f", [newed.codePrice doubleValue]];
    lblTime.text = [NSString stringWithFormat:@"揭晓时间：%@", newed.codeRTime];
}
@end
