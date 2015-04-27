//
//  NewestingCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/22.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "NewestingCell.h"

#define imgHeight   80

@interface NewestingCell ()
{
    UIImageView *imgProduct;
    UILabel     *lblTitle;
    UILabel     *lblPrice;
    
    NSTimer     *timer;
    UILabel     *lblTime;
    UIImageView *imgTimeBG;
    
    NSInteger    nowSeconds;
}

@end

@implementation NewestingCell

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = mainColor.CGColor;
        
        imgProduct = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, imgHeight, imgHeight)];
        imgProduct.image = [UIImage imageNamed:@"noimage"];
        imgProduct.layer.borderWidth = 0.5;
        imgProduct.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgProduct.layer.cornerRadius = 10;
        [self addSubview:imgProduct];
        
        
        lblTitle = [[UILabel alloc] init];
        lblTitle.font = [UIFont systemFontOfSize:14];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.numberOfLines = 2;
        lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblTitle];
        
        lblPrice = [[UILabel alloc] init];
        lblPrice.font = [UIFont systemFontOfSize:12];
        lblPrice.textColor = [UIColor lightGrayColor];
        [self addSubview:lblPrice];
        
        imgTimeBG = [[UIImageView alloc] initWithFrame:CGRectMake(imgHeight + 20, 70, mainWidth - imgHeight - 30, 25)];
        imgTimeBG.backgroundColor = mainColor;
        imgTimeBG.layer.cornerRadius = 5;
        [self addSubview:imgTimeBG];
        
        lblTime = [[UILabel alloc] init];
        lblTime.font = [UIFont systemFontOfSize:11];
        lblTime.textColor = [UIColor whiteColor];
        lblTime.text = @"揭晓倒计时  00:00:00";
        [imgTimeBG addSubview:lblTime];
    }
    return self;
}

- (void)setNewesting:(HomeNewing*)newing
{
    [imgProduct setImage_oy:oyImageBaseUrl image:newing.goodsPic];
    
    NSString* title = [NSString stringWithFormat:@"(第%d期)%@",[newing.period intValue],newing.goodsSName];
    lblTitle.text = title;
    CGSize s = [lblTitle.text textSizeWithFont:lblTitle.font constrainedToSize:CGSizeMake(mainWidth - imgHeight - 30, 40) lineBreakMode:NSLineBreakByCharWrapping];
    lblTitle.frame = CGRectMake(imgHeight + 20, 10, mainWidth - imgHeight - 30, s.height < 35 ? s.height : 35);
    
    lblPrice.text = [NSString stringWithFormat:@"价值:￥%.2f",[newing.price doubleValue]];
    lblPrice.frame = CGRectMake(imgHeight + 20, lblTitle.frame.origin.y + lblTitle.frame.size.height + 5, mainWidth - imgHeight - 30, 15);
    
    if ([newing.seconds isEqualToString:@"-1"])
    {
        lblTime.text = @"正在揭晓...";
        return;
    }
    
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    nowSeconds = [newing.seconds integerValue] * 100;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction
{
    if(nowSeconds<0)
    {
        [timer invalidate];
        timer = nil;
        return;
    }
    nowSeconds--;
    if(nowSeconds<=0)
    {
        lblTime.text = @"正在揭晓...";
        
        CGSize sss = [lblTime.text textSizeWithFont:lblTime.font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];
        lblTime.frame = CGRectMake((imgTimeBG.frame.size.width - sss.width) / 2, (imgTimeBG.frame.size.height - sss.height) /2, sss.width, sss.height);
        
        return;
    }
    int m = (int)nowSeconds / 6000;
    int s = (int)(nowSeconds/100) - m*60;
    NSString* f1 = s > 9 ? [NSString stringWithFormat:@"%d",s] : [@"0" stringByAppendingFormat:@"%d",s];
    int ms = nowSeconds % 100;
    NSString* f2 = ms > 9 ? [NSString stringWithFormat:@"%d",ms] : [@"0" stringByAppendingFormat:@"%d",ms];
    lblTime.text = [NSString stringWithFormat:@"揭晓倒计时  0%d:%@:%@",m,f1,f2];
    
    CGSize sss = [lblTime.text textSizeWithFont:lblTime.font constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    lblTime.frame = CGRectMake((imgTimeBG.frame.size.width - sss.width) / 2, (imgTimeBG.frame.size.height - sss.height) /2, sss.width, sss.height);
}

@end
