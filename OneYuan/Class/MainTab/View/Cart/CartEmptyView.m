//
//  CartEmptyView.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/26.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "CartEmptyView.h"

@implementation CartEmptyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake((mainWidth - 134 ) / 2, 150, 134, 127)];
        img.image = [UIImage imageNamed:@"empty_cart"];
        [self addSubview:img];
        
        UILabel* lab = [[UILabel alloc] init];
        lab.text = @"购物车为空";
        lab.textColor = [UIColor lightGrayColor];
        lab.font = [UIFont systemFontOfSize:14];
        CGSize s = [lab.text textSizeWithFont:lab.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lab.frame = CGRectMake((mainWidth - s.width) / 2, 285, s.width, s.height);
        [self addSubview:lab];
    }
    return self;
}

@end
