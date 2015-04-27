//
//  MineOrderHeadView.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/24.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineOrderHeadView.h"

@interface MineOrderHeadView ()
{
    UILabel* lblNum;
    UILabel* lblP;
}
@end

@implementation MineOrderHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 15)];
        lbl.text = @"您总共获得了";
        lbl.textColor = [UIColor grayColor];
        lbl.font = [UIFont systemFontOfSize:15];
        [self addSubview:lbl];
        
        lblNum = [[UILabel alloc] initWithFrame:CGRectMake(105, 10, 100, 15)];
        lblNum.text = @"-";
        lblNum.textColor = mainColor;
        lblNum.font = [UIFont systemFontOfSize:15];
        [self addSubview:lblNum];
        
        lblP = [[UILabel alloc] init];
        lblP.text = @"个商品";
        lblP.textColor = [UIColor grayColor];
        lblP.font = [UIFont systemFontOfSize:15];
        [self addSubview:lblP];
    }
    return self;
}

- (void)setNum:(int)num
{
    lblNum.text = [NSString stringWithFormat:@"%d",num];
    
    CGSize s = [lblNum.text textSizeWithFont:lblNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    
    lblP.frame = CGRectMake(lblNum.frame.origin.x + s.width + 5, 10, 100, 15);
}
@end
