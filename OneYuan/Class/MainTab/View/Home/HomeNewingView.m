//
//  HomeNewingView.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/19.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "HomeNewingView.h"
#import "AllProModel.h"

@interface HomeNewingView ()
{
    __weak id<HomeNewingViewDelegate> delegate;
    HomeNewing  *myNew;
    
    UILabel     *lblTitle;
    UILabel     *lblTime;
    UIImageView *imgProduct;
    
    NSTimer     *timer;
    NSInteger   nowSeconds;
}
@end

@implementation HomeNewingView
@synthesize delegate;


- (void)removeFromSuperview
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    [super removeFromSuperview];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        lblTitle = [[UILabel alloc] init];
        lblTitle.font = [UIFont systemFontOfSize:12];
        lblTitle.textColor = [UIColor grayColor];
        [self addSubview:lblTitle];
        
        
        lblTime = [[UILabel alloc] init];
        lblTime.font = [UIFont systemFontOfSize:12];
        lblTime.textColor = mainColor;
        [self addSubview:lblTime];
        
        imgProduct = [[UIImageView alloc] init];
        [self addSubview:imgProduct];
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [mainColor CGColor];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setNewing:(HomeNewing*)newing
{
    myNew = newing;
    
    imgProduct.frame = CGRectMake(self.bounds.size.width - 50, 10, 40, self.bounds.size.height - 20);
    [imgProduct setImage_oy:oyImageBaseUrl image:newing.goodsPic];
    
    lblTitle.text = newing.goodsSName;
    lblTitle.numberOfLines = 2;
    lblTitle.lineBreakMode =  NSLineBreakByTruncatingTail;
    CGSize s = [lblTitle.text textSizeWithFont:lblTitle.font constrainedToSize:CGSizeMake(self.bounds.size.width - 20, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblTitle.frame = CGRectMake(10, 10, self.bounds.size.width - 60, s.height);
    
    lblTime.frame = CGRectMake(10, self.bounds.size.height - 20, self.bounds.size.width - 60, 15);
    
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
        return;
    }
    int m = (int)nowSeconds / 6000;
    int s = (int)(nowSeconds/100) - m*60;
    NSString* f1 = s > 9 ? [NSString stringWithFormat:@"%d",s] : [@"0" stringByAppendingFormat:@"%d",s];
    int ms = nowSeconds % 100;
    NSString* f2 = ms > 9 ? [NSString stringWithFormat:@"%d",ms] : [@"0" stringByAppendingFormat:@"%d",ms];
    lblTime.text = [NSString stringWithFormat:@"0%d:%@:%@",m,f1,f2];
}

- (void)tapSelf
{
    if(delegate)
    {
        [delegate doClickGoods:0 codeId:[myNew.codeID intValue]];
    }
}
@end
