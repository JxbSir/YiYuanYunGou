//
//  HomeAdBtnCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/19.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "HomeAdBtnCell.h"

@interface HomeAdBtnCell ()
{
    __weak id<HomeAdBtnCellDelegate> delegate;
    
    UIButton    *btnNew;
    UILabel     *lblNew;
    
    UIButton    *btnShow;
    UILabel     *lblShow;

    UIButton    *btnBuy;
    UILabel     *lblBuy;
}

@end

@implementation HomeAdBtnCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat width = 60;
        CGFloat perW = (mainWidth - width * 3) / 6;
        
        btnNew = [[UIButton alloc] initWithFrame:CGRectMake(perW, 10, width, width)];
        [btnNew setImage:[UIImage imageNamed:@"home_btn_new"] forState:UIControlStateNormal];
        [btnNew addTarget:self action:@selector(newAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnNew];
        
        lblNew = [[UILabel alloc] init];
        lblNew.text = @"新品";
        lblNew.font = [UIFont systemFontOfSize:14];
        lblNew.textColor = [UIColor grayColor];
        CGSize snew = [lblNew.text textSizeWithFont:lblNew.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lblNew.frame = CGRectMake(perW + (60 - snew.width) / 2, 75, snew.width, snew.height);
        [self addSubview:lblNew];
        
        btnShow = [[UIButton alloc] initWithFrame:CGRectMake(perW * 3 + width, 10, width, width)];
        [btnShow setImage:[UIImage imageNamed:@"home_btn_show"] forState:UIControlStateNormal];
        [btnShow addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnShow];
        
        lblShow = [[UILabel alloc] init];
        lblShow.text = @"晒单";
        lblShow.font = [UIFont systemFontOfSize:14];
        lblShow.textColor = [UIColor grayColor];
        CGSize sshow = [lblShow.text textSizeWithFont:lblShow.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lblShow.frame = CGRectMake(perW * 3 + width + (60 - sshow.width) / 2, 75, sshow.width, sshow.height);
        [self addSubview:lblShow];
        
        btnBuy = [[UIButton alloc] initWithFrame:CGRectMake(perW * 5 + width * 2, 10, width, width)];
        [btnBuy setImage:[UIImage imageNamed:@"home_btn_buy"] forState:UIControlStateNormal];
        [btnBuy addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnBuy];
        
        lblBuy = [[UILabel alloc] init];
        lblBuy.text = @"云购记录";
        lblBuy.font = [UIFont systemFontOfSize:14];
        lblBuy.textColor = [UIColor grayColor];
        CGSize sbuy = [lblBuy.text textSizeWithFont:lblBuy.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lblBuy.frame = CGRectMake(perW * 5 + width * 2 + (60 - sbuy.width) / 2, 75, sbuy.width, sbuy.height);
        [self addSubview:lblBuy];
        
    }
    return self;
}


- (void)newAction
{
    if(delegate)
    {
        [delegate btnHomeClick:0];
    }
}

- (void)showAction
{
    if(delegate)
    {
        [delegate btnHomeClick:1];
    }
}

- (void)buyAction
{
    if(delegate)
    {
        [delegate btnHomeClick:2];
    }
}
@end
