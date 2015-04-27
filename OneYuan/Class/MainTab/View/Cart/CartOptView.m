//
//  CartOptView.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/26.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "CartOptView.h"
#import "CartModel.h"
#import "OyTool.h"

#define orY 15

@interface CartOptView ()
{
    __weak id<CartOptViewDelegate> delegate;
    
    UILabel* lblNum;
    UILabel* lbl2;
    UILabel* lblPrice;
    UILabel* lbl3;
}

@end

@implementation CartOptView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
        self.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        self.layer.borderWidth = 0.5;
        
        UILabel* lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(10, orY, 100, 13)];
        lbl1.text = @"共";
        lbl1.font = [UIFont systemFontOfSize:14];
        lbl1.textColor = [UIColor lightGrayColor];
        [self addSubview:lbl1];
        
        lbl2 = [[UILabel alloc] init];
        lbl2.text = @"件商品，合计";
        lbl2.font = [UIFont systemFontOfSize:14];
        lbl2.textColor = [UIColor lightGrayColor];
        [self addSubview:lbl2];
        
        lbl3 = [[UILabel alloc] init];
        lbl3.text = @"元";
        lbl3.font = [UIFont systemFontOfSize:14];
        lbl3.textColor = [UIColor lightGrayColor];
        [self addSubview:lbl3];
        
        lblNum = [[UILabel alloc] initWithFrame:CGRectMake(30, orY, 100, 13)];
        lblNum.font = [UIFont systemFontOfSize:14];
        lblNum.textColor = mainColor;
        [self addSubview:lblNum];
        
        lblPrice = [[UILabel alloc] init];
        lblPrice.font = [UIFont systemFontOfSize:14];
        lblPrice.textColor = mainColor;
        [self addSubview:lblPrice];
        
        UIButton* btnCalc = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth - 70, 7, 60, 30)];
        [btnCalc setBackgroundColor:mainColor];
        [btnCalc setTitle:@"结算" forState:UIControlStateNormal];
        btnCalc.layer.cornerRadius = 5;
        [btnCalc addTarget:self action:@selector(btnCalcAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnCalc];
    }
    return self;
}

- (void)setOpt
{
    [CartModel quertCart:nil value:nil block:^(NSArray* result){
        lblNum.text = [NSString stringWithFormat:@"%d",(int)result.count];
        
        double price = 0;
        for (CartItem* item in result) {
            if([item.cBuyNum intValue] > 0)
            {
                price += [item.cBuyNum intValue];
            }
        }
        
        lblPrice.text = [NSString stringWithFormat:@"%.2f",price];
        
        CGSize s = [lblNum.text textSizeWithFont:lblNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        
        CGSize s2 = [lbl2.text textSizeWithFont:lbl2.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lbl2.frame = CGRectMake(lblNum.frame.origin.x + s.width + 5, orY, s2.width, 13);
        
        
        s = [lblPrice.text textSizeWithFont:lblPrice.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        
        lblPrice.frame = CGRectMake(lbl2.frame.origin.x + lbl2.frame.size.width + 10, orY, s.width, 13);
        
        lbl3.frame = CGRectMake(lblPrice.frame.origin.x + lblPrice.frame.size.width + 10, orY, 100, 13) ;
    }];
}

- (void)btnCalcAction
{
    [[[UIAlertView alloc] initWithTitle:nil
                                message:@"是否确认结算购物车？"
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                       otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
            if(delegate)
            {
                [delegate cartCalcAction];
            }
        
    }], nil] show];


}
@end
