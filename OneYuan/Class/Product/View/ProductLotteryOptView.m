//
//  ProductLotteryOptView.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/3.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "ProductLotteryOptView.h"
#import "CartModel.h"

@interface ProductLotteryOptView ()
{
    __weak id<ProductLotteryOptViewDelegate> delegate;
    __block BTBadgeView                     *btB;
    UIButton                                *btnBuy;
}
@end

@implementation ProductLotteryOptView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView* line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 0.5)];
        line1.backgroundColor = [UIColor hexFloatColor:@"dedede"];
        [self addSubview:line1];
        
        UIImageView* line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 0.5, mainWidth, 0.5)];
        line2.backgroundColor = [UIColor hexFloatColor:@"dedede"];
        [self addSubview:line2];
        
        btnBuy = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, mainWidth - 70 , 30)];
        [btnBuy setTitle:@"正在加载..." forState:UIControlStateNormal];
        [btnBuy setBackgroundColor:mainColor];
        btnBuy.titleLabel.font = [UIFont systemFontOfSize:13];
        btnBuy.layer.cornerRadius = 3;
        btnBuy.layer.masksToBounds = YES;
        [btnBuy addTarget:self action:@selector(btnGotoDetail) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnBuy];
        
        UIButton* btnCart = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth - 50, 10, 30, 25)];
        [btnCart setImage:[UIImage imageNamed:@"cart2"] forState:UIControlStateNormal];
        [btnCart addTarget:self action:@selector(btnGotoCart) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnCart];
        
        
        btB = [[BTBadgeView alloc] init];
        btB.shine = NO;
        btB.shadow = NO;
        [CartModel quertCart:nil value:nil block:^(NSArray* result){
            if(result.count > 0)
                btB.value = [NSString stringWithFormat:@"%d",(int)result.count];
        }];
        if([btB.value intValue]< 10)
        {
            btB.frame = CGRectMake(mainWidth - 30, 0, 22, 22);
        }
        else if([btB.value intValue] < 100)
        {
            btB.frame = CGRectMake(mainWidth - 30, 0, 30, 22);
        }
        [self addSubview:btB];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnGotoCart)];
        [btB addGestureRecognizer:tap];
    }
    return self;
}


- (void)btnGotoDetail
{
    if(delegate)
    {
        [delegate gotoDetailAction];
    }
}

- (void)btnGotoCart
{
    if(delegate)
    {
        [delegate gotoCartAction];
    }
}

- (void)setCartNum:(int)count
{
    if(count <=0)
        btB.value = @"";
    else
        btB.value  = [NSString stringWithFormat:@"%d",count];
    
    if([btB.value intValue]< 10)
    {
        btB.frame = CGRectMake(mainWidth - 30, 0, 22, 22);
    }
    else if([btB.value intValue] < 100)
    {
        btB.frame = CGRectMake(mainWidth - 30, 0, 30, 22);
    }
}

- (void)setBtnPeriod:(AllProPeriod*)period
{
    if([period.codeState intValue] == 1)
    {
        [btnBuy setTitle:[NSString stringWithFormat:@"第%d期(正在进行中...)",[period.codePeriod intValue]] forState:UIControlStateNormal];
    }
    else if([period.codeState intValue] == 2){
        [btnBuy setTitle:[NSString stringWithFormat:@"第%d期(正在揭晓中...)",[period.codePeriod intValue]] forState:UIControlStateNormal];
    }
    else{
        [btnBuy setTitle:[NSString stringWithFormat:@"暂时还没有新的一期"] forState:UIControlStateNormal];
        [btnBuy removeTarget:self action:@selector(btnGotoDetail) forControlEvents:UIControlEventTouchUpInside];
    }
}
@end
