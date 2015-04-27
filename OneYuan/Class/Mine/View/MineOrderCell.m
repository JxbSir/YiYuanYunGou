//
//  MineOrderCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/24.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineOrderCell.h"

@interface MineOrderCell ()
{
    __weak id<MineMyOrderCellDelegate> delegate;
    
    UIImageView     *imgPro;
    UILabel         *lblTitle;
    
    UILabel         *lblCode;
    UILabel         *lblTime;
    
    UIButton        *btnState;
    UIButton        *btnOpt;
    
    int             myOrderId;
}
@end

@implementation MineOrderCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 90, 90)];
        imgPro.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgPro.layer.borderWidth = 0.5;
        imgPro.layer.cornerRadius = 5;
        imgPro.layer.masksToBounds = YES;
        [self addSubview:imgPro];
        
        
        lblTitle = [[UILabel alloc] init];
        lblTitle.font = [UIFont systemFontOfSize:14];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.frame = CGRectMake(110, 10, mainWidth - 120, 40);
        lblTitle.numberOfLines = 2;
        lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblTitle];
        
        UILabel* lblC = [[UILabel alloc] initWithFrame:CGRectMake(110, 50, 100, 15)];
        lblC.text = @"幸运云购码：";
        lblC.textColor = [UIColor lightGrayColor];
        lblC.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblC];
        
        lblCode = [[UILabel alloc] initWithFrame:CGRectMake(180, 50, 100, 15)];
        lblCode.textColor = mainColor;
        lblCode.font = lblC.font;
        [self addSubview:lblCode];
        
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(110, 65, mainWidth - 100, 15)];
        lblTime.textColor = [UIColor lightGrayColor];
        lblTime.font = lblC.font;
        [self addSubview:lblTime];
        
        btnState = [[UIButton alloc] initWithFrame:CGRectMake(110, 85, 100, 25)];
        btnState.layer.cornerRadius = 3;
        btnState.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:btnState];
        
        btnOpt = [[UIButton alloc] initWithFrame:CGRectMake(220, 85, 80, 25)];
        btnOpt.layer.cornerRadius = 3;
        btnOpt.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:btnOpt];
        
    }
    return self;
}

- (void)setMyOrder:(MineMyOrderItem *)item
{
    if(!item)
        return;
    myOrderId = [item.orderNo intValue];
    [imgPro setImage_oy:oyImageBaseUrl image:item.goodsPic];
    
    NSString* goodname = [item.goodsSName stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    lblTitle.text = [NSString stringWithFormat:@"(第%d期)%@",[item.codePeriod intValue],goodname];
    
    lblCode.text = [item.codeRNO stringValue];
    
    NSString* time = item.codeRTime;
    if([[Jxb_Common_Common sharedInstance] containString:time cStr:@"."])
        time = [time substringToIndex:[time rangeOfString:@"."].location];
    lblTime.text = [NSString stringWithFormat:@"揭晓时间：%@",time];
    
    
    btnState.hidden = YES;
    btnOpt.hidden = YES;
    [btnOpt removeTarget:self action:@selector(confirmOrder) forControlEvents:UIControlEventTouchUpInside];
    [btnOpt removeTarget:self action:@selector(confirmShip) forControlEvents:UIControlEventTouchUpInside];
    [btnOpt removeTarget:self action:@selector(showOrder) forControlEvents:UIControlEventTouchUpInside];
    
    if([item.orderState intValue] == 1)
    {
        [btnOpt setHidden:NO];
        [btnOpt setTitle:@"完善收货信息" forState:UIControlStateNormal];
        [btnOpt setBackgroundColor:mainColor];
        [btnOpt addTarget:self action:@selector(confirmOrder) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([item.orderState intValue] == 2)
    {
        [btnState setHidden:NO];
        [btnState setTitle:@"正在备货" forState:UIControlStateNormal];
        [btnState setBackgroundColor:[UIColor lightGrayColor]];
    }
    else if([item.orderState intValue] == 3)
    {
        [btnState setHidden:NO];
        [btnState setTitle:@"已发货" forState:UIControlStateNormal];
        [btnState setBackgroundColor:[UIColor lightGrayColor]];
        
        [btnOpt setHidden:NO];
        [btnOpt setTitle:@"确认收货" forState:UIControlStateNormal];
        [btnOpt setBackgroundColor:mainColor];
        [btnOpt addTarget:self action:@selector(confirmShip) forControlEvents:UIControlEventTouchUpInside];
    }
    else if([item.orderState intValue] == 10)
    {
        [btnState setHidden:NO];
        [btnState setTitle:@"订单已完成" forState:UIControlStateNormal];
        [btnState setBackgroundColor:[UIColor lightGrayColor]];
        
        int ps = [item.IsPostSingle intValue];
        if(ps == 0)
        {
            [btnOpt setHidden:NO];
            [btnOpt setTitle:@"已晒单" forState:UIControlStateNormal];
            [btnOpt setBackgroundColor:[UIColor lightGrayColor]];
        }
        else if (ps == -1)
        {
            [btnOpt setHidden:NO];
            [btnOpt setTitle:@"去晒单" forState:UIControlStateNormal];
            [btnOpt setBackgroundColor:mainColor];
            [btnOpt addTarget:self action:@selector(showOrder) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    if([btnState isHidden])
    {
        btnOpt.frame = CGRectMake(110, 85, 100, 25);
    }
    else
    {
        btnOpt.frame = CGRectMake(220, 85, 80, 25);
    }
}

#pragma delegate;
- (void)confirmOrder
{
    if(delegate)
    {
        [delegate confirmOrder:myOrderId];
    }
}
- (void)confirmShip
{
    if(delegate)
    {
        [delegate confirmShip:myOrderId];
    }
}

- (void)showOrder
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请前往官方网站进行晒单！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [alert show];
}
@end
