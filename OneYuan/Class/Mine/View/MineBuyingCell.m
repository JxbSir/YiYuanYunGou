//
//  MineBuyingCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/24.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineBuyingCell.h"
#import "ProBuyingProgress.h"

@interface MineBuyingCell ()
{
    UIImageView     *imgPro;
    UILabel         *lblTitle;
    ProBuyingProgress   *progress;
    
    UILabel         *lblNum;
    UILabel         *lblRC;
    
    UILabel         *lbl;
}

@end

@implementation MineBuyingCell
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
        imgProBg.backgroundColor = mainColor;
        imgProBg.alpha = 0.5;
        [imgPro addSubview:imgProBg];
        
        lbl = [[UILabel alloc] init];
        lbl.text = @"进行中";
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
        
        progress = [[ProBuyingProgress alloc] initWithFrame:CGRectMake(110, 75, mainWidth - 120, 50)];
        [self addSubview:progress];
        
        UILabel* lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(110, 58, 100, 13)];
        lbl1.text = @"您已参与";
        lbl1.textColor = [UIColor lightGrayColor];
        lbl1.font = [UIFont systemFontOfSize:11];
        [self addSubview:lbl1];
        
        lblNum = [[UILabel alloc] initWithFrame:CGRectMake(160, 58, 100, 13)];
        lblNum.textColor = mainColor;
        lblNum.font = [UIFont systemFontOfSize:11];
        [self addSubview:lblNum];
        
        lblRC = [[UILabel alloc] init];
        lblRC.text = @"人次";
        lblRC.textColor = [UIColor lightGrayColor];
        lblRC.font = [UIFont systemFontOfSize:11];
        [self addSubview:lblRC];
    }
    return self;
}

- (void)setBuying:(MineMyBuyItem*)item
{
    if(!item || !item.goodsPic)
        return;
    
    [imgPro setImage_oy:oyImageBaseUrl image:item.goodsPic];
    
    if([item.codeState intValue] == 2)
    {
        lbl.text = @"揭晓中";
    }
    else
    {
        lbl.text = @"进行中";
    }
    
    lblTitle.text = [NSString stringWithFormat:@"(第%d期)%@",[item.codePeriod intValue],item.goodsName];
    
    [progress setProgress:[item.codeQuantity doubleValue] now:[item.codeSales doubleValue]];
    
    lblNum.text = [NSString stringWithFormat:@"%d",[item.buyNum intValue]];
    CGSize s = [lblNum.text textSizeWithFont:lblNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    
    lblRC.frame = CGRectMake(160 + s.width + 5, 58, 100, 13);
}
@end
