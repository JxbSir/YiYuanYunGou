//
//  MineBuyCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/24.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineBuyCell.h"

@interface MineBuyCell ()
{
    UIImageView     *imgPro;
    UILabel         *lblTitle;
    UILabel         *lblName;
    UILabel         *lblTime;
}
@end

@implementation MineBuyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 90, 90)];
        imgPro.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgPro.layer.borderWidth = 0.5;
        imgPro.layer.cornerRadius = 5;
        imgPro.layer.masksToBounds = YES;
        [self addSubview:imgPro];
        
        UIImageView  *imgProBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, imgPro.frame.size.height - 20, 90, 20)];
        imgProBg.backgroundColor = [UIColor blackColor];
        imgProBg.alpha = 0.5;
        [imgPro addSubview:imgProBg];
        
        UILabel *lbl = [[UILabel alloc] init];
        lbl.text = @"已揭晓";
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont systemFontOfSize:11];
        CGSize s = [lbl.text textSizeWithFont:lbl.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByWordWrapping];
        lbl.frame = CGRectMake((90 - s.width) / 2, 90-(20 - s.height )/2 - s.height, s.width, s.height);
        [imgPro addSubview:lbl];
        
        lblTitle = [[UILabel alloc] init];
        lblTitle.font = [UIFont systemFontOfSize:14];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.frame = CGRectMake(110, 10, mainWidth - 120, 40);
        lblTitle.numberOfLines = 2;
        lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblTitle];
        
        UILabel *lbln = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, mainWidth - 100, 15)];
        lbln.text = @"获得者：";
        lbln.textColor = [UIColor lightGrayColor];
        lbln.font = [UIFont systemFontOfSize:12];
        [self addSubview:lbln];
        
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(155, 60, mainWidth - 100, 15)];
        lblName.textColor = [UIColor hexFloatColor:@"3385ff"];
        lblName.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblName];
        
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(110, 80, mainWidth - 100, 15)];
        lblTime.textColor = [UIColor lightGrayColor];
        lblTime.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblTime];
    }
    return self;
}

- (void)setBuyed:(MineMyBuyItem*)item
{
    [imgPro setImage_oy:oyImageBaseUrl image:item.goodsPic];
    
    lblTitle.text = [NSString stringWithFormat:@"(第%d期)%@",[item.codePeriod intValue],item.goodsName];
    lblName.text = item.userName;
    NSString* time = [item codeRTime];
    if([time rangeOfString:@"."].length>0)
        time = [time substringToIndex:[time rangeOfString:@"."].location];
    lblTime.text = [NSString stringWithFormat:@"揭晓时间：%@",time];
}
@end
