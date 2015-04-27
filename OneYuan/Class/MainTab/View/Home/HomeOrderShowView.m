//
//  HomeOrderShowView.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/20.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "HomeOrderShowView.h"

@interface HomeOrderShowView ()
{
    UIImageView     *imgPro;
    UILabel         *lblTitle;
}

@end

@implementation HomeOrderShowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imgPro.image = [UIImage imageNamed:@"noimage"];
        [self addSubview:imgPro];
        
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
        v.backgroundColor = [UIColor blackColor];
        v.alpha = 0.5;
        [self addSubview:v];
        
        lblTitle = [[UILabel alloc] init];
        lblTitle.font = [UIFont systemFontOfSize:11];
        lblTitle.textColor = [UIColor whiteColor];
        [self addSubview:lblTitle];
         
    }
    return self;
}

- (void)setOrderShow:(HomeOrderShowItem *)order
{
    NSString* name = order.postAllPic;
    if ([name rangeOfString:@","].location > 0)
        name = [name substringToIndex:[name rangeOfString:@","].location];
    [imgPro setImage_oy:oyImageBigUrl image:name];
    
    [lblTitle setText:[order.postTitle stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "]];
    CGSize s = [lblTitle.text textSizeWithFont:lblTitle.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat w = s.width;
    if(w > self.bounds.size.width)
        w = self.bounds.size.width;
    lblTitle.frame = CGRectMake((self.bounds.size.width - w) / 2, self.bounds.size.height - s.height - 5, w, s.height);
    
}
@end
