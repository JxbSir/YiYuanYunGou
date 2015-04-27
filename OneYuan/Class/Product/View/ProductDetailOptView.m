//
//  ProductDetailOptView.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/1.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "ProductDetailOptView.h"
#import "CartModel.h"

@interface ProductDetailOptView ()
{
    __weak id<ProductDetailOptViewDelegate> delegate;
    __block BTBadgeView* btB;
}
@end

@implementation ProductDetailOptView
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
        
        
        UIButton* btnBuy = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, (mainWidth - 80) / 2 , 30)];
        [btnBuy setTitle:@"立即1元云购" forState:UIControlStateNormal];
        [btnBuy setBackgroundColor:mainColor];
        btnBuy.layer.cornerRadius = 3;
        btnBuy.layer.masksToBounds = YES;
        [btnBuy addTarget:self action:@selector(btnAddGotoCart) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnBuy];
        
        
        UIButton* btnAddCart = [[UIButton alloc] initWithFrame:CGRectMake(btnBuy.frame.size.width + 20, 7, (mainWidth - 80) / 2 , 30)];
        [btnAddCart setTitle:@"加入购物车" forState:UIControlStateNormal];
        [btnAddCart setBackgroundColor:[UIColor hexFloatColor:@"21a6f9"]];
        btnAddCart.layer.cornerRadius = 3;
        btnAddCart.layer.masksToBounds = YES;
        [btnAddCart addTarget:self action:@selector(btnAddtoCart) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnAddCart];
        
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

- (void)btnAddtoCart
{
    if(delegate)
    {
        [delegate addToCartAction];
    }
}


- (void)btnAddGotoCart
{
    if(delegate)
    {
        [delegate addGotoCartAction];
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
@end
