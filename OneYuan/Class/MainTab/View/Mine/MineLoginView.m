//
//  MineLoginView.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/23.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineLoginView.h"
#import "LoginVC.h"

@interface MineLoginView ()
{
    __weak id<MineLoginViewDelegate> delegate;
}
@end

@implementation MineLoginView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UILabel* lbl = [[UILabel alloc] init];
        lbl.text = @"欢迎来到1元云购";
        lbl.textColor = [UIColor grayColor];
        lbl.font = [UIFont systemFontOfSize:16];
        CGSize s = [lbl.text textSizeWithFont:lbl.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lbl.frame = CGRectMake((mainWidth - s.width)/2, 30, s.width, s.height);
        [self addSubview:lbl];
        
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake((mainWidth -150 )/2, 60, 150, 44)];
        [btn setTitle:@"登录" forState:UIControlStateNormal];
        [btn setTitleColor:mainColor forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [UIColor hexFloatColor:@"dedede"].CGColor;
        [btn addTarget:self action:@selector(btnLoginAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

- (void)btnLoginAction
{
    [delegate doLogin];
}
@end
