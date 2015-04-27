//
//  ProductDetailGetCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/27.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "ProductDetailGetCell.h"

@interface ProductDetailGetCell ()
{
    UIImageView     *imgUser;
    UILabel         *lblName;
    UILabel         *lblRTime;
    UILabel         *lblBTime;
    UILabel         *lblRNo;
    UILabel         *lblArea;
    UILabel         *lblBuyCount;
}
@end

@implementation ProductDetailGetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel* lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, mainWidth, 14)];
        lblTitle.text = @"上期获得者";
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.font = [UIFont systemFontOfSize:15];
        [self addSubview:lblTitle];
        
        imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(16, 35, 40, 40)];
        imgUser.image = [UIImage imageNamed:@"noimage"];
        imgUser.layer.cornerRadius = imgUser.frame.size.height / 2;
        imgUser.layer.masksToBounds = YES;
        [self addSubview:imgUser];
        
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, mainWidth - 70, 14)];
        lblName.textColor = [UIColor hexFloatColor:@"3385ff"];
        lblName.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblName];
        
        lblRTime = [[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, 50, mainWidth - 70, 14)];
        lblRTime.textColor = [UIColor lightGrayColor];
        lblRTime.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblRTime];
        
        lblBTime = [[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, 65, mainWidth - 70, 14)];
        lblBTime.textColor = [UIColor lightGrayColor];
        lblBTime.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblBTime];
        
        lblBuyCount = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 200, 14)];
        lblBuyCount.textColor = mainColor;
        lblBuyCount.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblBuyCount];
        
        
        UILabel* lblno = [[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, 80, 100, 14)];
        lblno.text = @"幸运云购码：";
        lblno.textColor = [UIColor lightGrayColor];
        lblno.font = [UIFont systemFontOfSize:12];
        [self addSubview: lblno];
        
        lblRNo = [[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x + 70, 80, mainWidth - 70, 14)];
        lblRNo.textColor = mainColor;
        lblRNo.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblRNo];
        
        lblArea = [[UILabel alloc] init];
        lblArea.textColor = [UIColor lightGrayColor];
        lblArea.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblArea];
    }
    return self;
}

- (void)setProDetail:(ProductDetail*)detail
{
    if(!detail)
        return;
    [imgUser setImage_oy:oyHeadBaseUrl image:detail.Rows2.userPhoto];
    
    lblName.text = detail.Rows2.userName;
    NSString* rtime = detail.Rows2.codeRTime;
    lblRTime.text = [NSString stringWithFormat:@"揭晓时间：%@", rtime];
    NSString* btime = detail.Rows2.codeRBuyTime;
    lblBTime.text = [NSString stringWithFormat:@"云购时间：%@", btime];
    lblRNo.text = [detail.Rows2.codeRNO stringValue];
    
    lblBuyCount.text = [NSString stringWithFormat:@"总云购 %d 人次",[detail.Rows2.codeRUserBuyCount intValue]];
    
    CGSize s = [lblName.text textSizeWithFont:lblName.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblArea.text = [NSString stringWithFormat:@"(%@)",detail.Rows2.codeRIpAddr];
    lblArea.frame = CGRectMake(lblName.frame.origin.x + s.width, lblName.frame.origin.y, 200, 14);
}
@end
