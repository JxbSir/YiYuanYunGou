//
//  ProBuyingProgress.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/24.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "ProBuyingProgress.h"

@interface ProBuyingProgress ()
{
    UIProgressView  *progress;
    
    UILabel         *lblNowNum;
    UILabel         *lblAllNum;
    UILabel         *lblLeftNum;
}

@end

@implementation ProBuyingProgress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        progress.progressTintColor = mainColor;
        [self addSubview:progress];
        
        lblNowNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, frame.size.width - 20, 13)];
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
        
        UILabel* lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0,17, 100, 13)];
        lbl1.text = @"已参与";
        lbl1.textColor = [UIColor grayColor];
        lbl1.font = [UIFont systemFontOfSize:8];
        [self addSubview:lbl1];
        
        UILabel* lbl2 = [[UILabel alloc] init];
        lbl2.text = @"总需人次";
        lbl2.textColor = [UIColor grayColor];
        lbl2.font = [UIFont systemFontOfSize:8];
        CGSize s = [lbl2.text textSizeWithFont:lbl2.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lbl2.frame = CGRectMake((frame.size.width - s.width) / 2, lbl1.frame.origin.y, s.width, 13);
        [self addSubview:lbl2];
        
        UILabel* lbl3 = [[UILabel alloc] init];
        lbl3.text = @"剩余";
        lbl3.textColor = [UIColor grayColor];
        lbl3.font = [UIFont systemFontOfSize:8];
        s = [lbl3.text textSizeWithFont:lbl3.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lbl3.frame = CGRectMake(frame.size.width - s.width, lbl1.frame.origin.y, s.width, 13);
        [self addSubview:lbl3];
    }
    return self;
}

- (void)setProgress:(double)all now:(double)now
{
    lblNowNum.text = [NSString stringWithFormat:@"%.0f",now];
    lblAllNum.text = [NSString stringWithFormat:@"%.0f",all];
    lblLeftNum.text = [NSString stringWithFormat:@"%.0f",all - now];
    
    CGSize s = [lblLeftNum.text textSizeWithFont:lblLeftNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblLeftNum.frame = CGRectMake(self.bounds.size.width - s.width, lblNowNum.frame.origin.y, s.width, 13);
    
    s = [lblAllNum.text textSizeWithFont:lblAllNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblAllNum.frame = CGRectMake((self.bounds.size.width - s.width)/2, lblNowNum.frame.origin.y, s.width, 13);
    
    progress.progress = now / all;
}
@end
