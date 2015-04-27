//
//  HomeNewedView.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/19.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "HomeNewedView.h"

@interface HomeNewedView ()
{
    __weak id<HomeNewedViewDelegate> delegate;
    HomeNewed* myNewed;
    UILabel* lblTitle;
    UILabel* lblUser;
    UIImageView *imgProduct;
}
@end

@implementation HomeNewedView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        lblTitle = [[UILabel alloc] init];
        lblTitle.font = [UIFont systemFontOfSize:12];
        lblTitle.textColor = [UIColor grayColor];
        [self addSubview:lblTitle];
        
        
        lblUser = [[UILabel alloc] init];
        lblUser.font = [UIFont systemFontOfSize:14];
        lblUser.textColor = [UIColor hexFloatColor:@"3385ff"];
        [self addSubview:lblUser];
        
        imgProduct = [[UIImageView alloc] init];
        [self addSubview:imgProduct];
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setNewed:(HomeNewed*)newed
{
    myNewed = newed;
    imgProduct.frame = CGRectMake(self.bounds.size.width - 50, 10, 40, self.bounds.size.height - 20);
    [imgProduct setImage_oy:oyImageBaseUrl image:newed.codeGoodsPic];
    
    lblUser.text = newed.userName;
    lblUser.frame = CGRectMake(10, 10, self.bounds.size.width - 60, 15);
    
    lblTitle.text = newed.codeGoodsSName;
    lblTitle.numberOfLines = 2;
    lblTitle.lineBreakMode =  NSLineBreakByTruncatingTail;
    lblTitle.frame = CGRectMake(10, 30, self.bounds.size.width - 60, 30);
}

- (void)tapSelf
{
    if(delegate)
    {
        [delegate doClickGoods:[myNewed.codeGoodsID intValue] codeId:[myNewed.codeID intValue]];
    }
}
@end
