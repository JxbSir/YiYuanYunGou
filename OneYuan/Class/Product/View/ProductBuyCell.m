//
//  ProductBuyCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/1.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "ProductBuyCell.h"

@interface ProductBuyCell ()
{
    UIImageView* imgHead;
    UILabel*     lblName;
    UILabel*     lblArea;
    UILabel*     lblNum;
    UILabel*     lblRc;
    UILabel*     lblTime;
}
@end

@implementation ProductBuyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        imgHead.image = [UIImage imageNamed:@"noimage"];
        imgHead.layer.cornerRadius = 30;
        imgHead.layer.borderWidth = 3;
        imgHead.layer.masksToBounds = YES;
        imgHead.layer.borderColor = [[UIColor hexFloatColor:@"f8f8f8"] CGColor];
        [self addSubview:imgHead];
        
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, mainWidth - 100, 15)];
        lblName.textColor = [UIColor hexFloatColor:@"3385ff"];
        lblName.font = [UIFont systemFontOfSize:14];
        [self addSubview:lblName];
        
        lblArea = [[UILabel alloc] init];
        lblArea.textColor = [UIColor lightGrayColor];
        lblArea.font = [UIFont systemFontOfSize:14];
        [self addSubview:lblArea];
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, 100, 15)];
        lbl.textColor = [UIColor grayColor];
        lbl.text = @"云购了";
        lbl.font = [UIFont systemFontOfSize:13];
        [self addSubview:lbl];
        
        lblNum = [[UILabel alloc] initWithFrame:CGRectMake(120, lbl.frame.origin.y, 100, 15)];
        lblNum.textColor = mainColor;
        lblNum.font = [UIFont systemFontOfSize:13];
        [self addSubview:lblNum];
        
        lblRc = [[UILabel alloc] init];
        lblRc.text = @"人次";
        lblRc.textColor = [UIColor grayColor];
        lblRc.font = [UIFont systemFontOfSize:13];
        [self addSubview:lblRc];
        
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(75, 50, mainWidth - 80, 15)];
        lblTime.textColor = [UIColor grayColor];
        lblTime.font = [UIFont systemFontOfSize:13];
        [self addSubview:lblTime];
        
    }
    return self;
}

- (void)setBuy:(ProdcutBuyItem*)item
{
    [imgHead setImage_oy:oyHeadBaseUrl image:item.userPhoto];
    
    lblName.text = item.userName;
    lblArea.text = [NSString stringWithFormat:@"(%@)",item.buyIPAddr];
    
    CGSize s = [lblName.text textSizeWithFont:lblName.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblArea.frame = CGRectMake(lblName.frame.origin.x + s.width, 10, mainWidth - 100, 15);
    
    lblNum.text = item.buyNum;
    s = [lblNum.text textSizeWithFont:lblNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    
    lblRc.frame = CGRectMake(lblNum.frame.origin.x + s.width + 10, lblNum.frame.origin.y, 100, 15);
    
    lblTime.text = item.buyTime;
}

@end
