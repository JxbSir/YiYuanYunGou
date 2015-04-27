//
//  HomeHotView.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/19.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "HomeHotView.h"

@interface HomeHotView ()
{
    UIImageView     *imgPro;
    UILabel         *lblPrice;
    
    UIProgressView  *progress;
    
    UILabel         *lblNowNum;
    UILabel         *lblAllNum;
    UILabel         *lblLeftNum;
}

@end

@implementation HomeHotView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width - 20, 100)];
        imgPro.image = [UIImage imageNamed:@"noimage"];
        [self addSubview:imgPro];
        
        lblPrice = [[UILabel alloc] init];
        lblPrice.textColor = [UIColor grayColor];
        lblPrice.font = [UIFont systemFontOfSize:13];
        [self addSubview:lblPrice];
        
        progress = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 150, self.bounds.size.width - 20, 30)];
        progress.progressTintColor = mainColor;
        [self addSubview:progress];
        
        lblNowNum = [[UILabel alloc] initWithFrame:CGRectMake(10, 165, self.bounds.size.width - 20, 13)];
        lblNowNum.textColor = mainColor;
        lblNowNum.font = [UIFont systemFontOfSize:10];
        [self addSubview:lblNowNum];
        
        lblAllNum = [[UILabel alloc] init];
        lblAllNum.textColor = [UIColor grayColor];
        lblAllNum.font = [UIFont systemFontOfSize:10];
        [self addSubview:lblAllNum];
        
        lblLeftNum = [[UILabel alloc] init];
        lblLeftNum.textColor = [UIColor hexFloatColor:@"3385ff"];
        lblLeftNum.font = [UIFont systemFontOfSize:10];
        [self addSubview:lblLeftNum];
        
        UILabel* lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 100, 13)];
        lbl1.text = @"已参与";
        lbl1.textColor = [UIColor grayColor];
        lbl1.font = [UIFont systemFontOfSize:8];
        [self addSubview:lbl1];
        
        UILabel* lbl2 = [[UILabel alloc] init];
        lbl2.text = @"总需人次";
        lbl2.textColor = [UIColor grayColor];
        lbl2.font = [UIFont systemFontOfSize:8];
        CGSize s = [lbl2.text textSizeWithFont:lbl2.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lbl2.frame = CGRectMake((self.bounds.size.width - s.width) / 2, lbl1.frame.origin.y, s.width, 13);
        [self addSubview:lbl2];
        
        UILabel* lbl3 = [[UILabel alloc] init];
        lbl3.text = @"剩余";
        lbl3.textColor = [UIColor grayColor];
        lbl3.font = [UIFont systemFontOfSize:8];
        s = [lbl3.text textSizeWithFont:lbl3.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lbl3.frame = CGRectMake(self.bounds.size.width - s.width - 10, lbl1.frame.origin.y, s.width, 13);
        [self addSubview:lbl3];
    }
    return self;
}

- (void)setHot:(HomeHostest*)hot
{
    if(hot)
    {
        [imgPro setImage_oy:oyImageBaseUrl image:hot.goodsPic];
    }
    else
        [imgPro setImage:[UIImage imageNamed:@"noimage"]];
    
    lblPrice.text = [NSString stringWithFormat:@"价值:￥%@",hot.codePrice];
    CGSize s = [lblPrice.text textSizeWithFont:lblPrice.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblPrice.frame = CGRectMake((120 - s.width) / 2, 120, s.width, s.height);
    
    lblNowNum.text = [hot.codeSales stringValue];
    lblAllNum.text = [hot.codeQuantity stringValue];
    lblLeftNum.text = [NSString stringWithFormat:@"%d",[hot.codeQuantity intValue] - [hot.codeSales intValue]];
    
    s = [lblLeftNum.text textSizeWithFont:lblLeftNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblLeftNum.frame = CGRectMake(self.bounds.size.width - 10 - s.width, lblNowNum.frame.origin.y, s.width, 13);
    
    s = [lblAllNum.text textSizeWithFont:lblAllNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblAllNum.frame = CGRectMake((self.bounds.size.width - s.width)/2, lblNowNum.frame.origin.y, s.width, 13);
    
    progress.progress = [hot.codeSales doubleValue]/ [hot.codeQuantity doubleValue];
}
@end
