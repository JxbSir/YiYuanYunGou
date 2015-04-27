//
//  BaseNoDataView.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/25.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "BaseNoDataView.h"

@interface BaseNoDataView ()
{
    
}

@end

@implementation BaseNoDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 80) / 2, 150, 80, 80)];
        img.image = [UIImage imageNamed:@"nodata"];
        [self addSubview:img];
        
        UILabel* lbl = [[UILabel alloc] init];
        lbl.text = @"暂无记录";
        lbl.textColor = [UIColor lightGrayColor];
        lbl.font = [UIFont systemFontOfSize:15];
        CGSize s = [lbl.text textSizeWithFont:lbl.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lbl.frame = CGRectMake((frame.size.width - s.width ) /2, 240, s.width, s.height);
        [self addSubview:lbl];
    }
    return self;
}
@end
