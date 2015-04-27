//
//  SearchCartView.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/1.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "SearchCartView.h"
#import "CartModel.h"

@interface SearchCartView ()
{
    __weak id<SearchCartViewDelegate> delegate;
    __block UILabel* lblCount;
}
@end

@implementation SearchCartView
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        img.layer.cornerRadius = frame.size.height / 2;
        img.backgroundColor = [UIColor blackColor];
        img.alpha = 0.5;
        [self addSubview:img];
        
        UIButton* btnCart = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width - 30) / 2, (frame.size.height - 25) / 2, 30, 25)];
        [btnCart setImage:[UIImage imageNamed:@"cart_white"] forState:UIControlStateNormal];
        [btnCart setImage:[UIImage imageNamed:@"cart_white"] forState:UIControlStateHighlighted];
        [btnCart setImage:[UIImage imageNamed:@"cart_white"] forState:UIControlStateSelected];
        [btnCart addTarget:self action:@selector(btnGotoCart) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnCart];
        
        lblCount = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 15, 15)];
        lblCount.textColor = [UIColor whiteColor];
        lblCount.font = [UIFont systemFontOfSize:12];
        lblCount.layer.cornerRadius = 7.5;
        lblCount.layer.masksToBounds = YES;
        lblCount.backgroundColor = [UIColor redColor];
        [self addSubview:lblCount];
        [CartModel quertCart:nil value:nil block:^(NSArray* result){
            if(result.count > 0)
            {
                if(result.count < 10)
                    lblCount.text = [NSString stringWithFormat:@" %d",(int)result.count];
                else
                    lblCount.text = [NSString stringWithFormat:@"%d",(int)result.count];
            }
            else
            {
                lblCount.hidden = YES;
            }
        }];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnGotoCart)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setCartNum:(int)count
{
    if(count == 0)
    {
        lblCount.hidden = YES;
    }
    else
    {
        lblCount.hidden = NO;
        if(count < 10)
            lblCount.text = [NSString stringWithFormat:@" %d",count];
        else
            lblCount.text = [NSString stringWithFormat:@"%d",count];
    }
}

- (void)btnGotoCart
{
    if(delegate)
    {
        [delegate gotoCart];
    }
}
@end
