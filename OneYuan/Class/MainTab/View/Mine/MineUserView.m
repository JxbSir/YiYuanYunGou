//
//  MineUserView.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/23.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineUserView.h"
#import "UserInstance.h"

@interface MineUserView ()
{
    __weak id<MineUserViewDelegate> delegate;
}
@end

@implementation MineUserView
@synthesize  delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView* lineTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 0.5)];
        lineTop.backgroundColor = [UIColor hexFloatColor:@"dedede"];
        [self addSubview:lineTop];
        
        UIImageView* lineBot = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 10, mainWidth, 0.5)];
        lineBot.backgroundColor = [UIColor hexFloatColor:@"dedede"];
        [self addSubview:lineBot];
        
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, mainWidth, frame.size.height - 10.5)];
        v.backgroundColor = [UIColor whiteColor];
        [self addSubview:v];
        
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        img.layer.masksToBounds = YES;
        img.layer.cornerRadius = 30;
        [img setImage_oy:nil image:[UserInstance ShardInstnce].userPhoto];
        [v addSubview:img];
        
        UILabel* lblName = [[UILabel alloc] init];
        lblName.text = [UserInstance ShardInstnce].userName;
        lblName.textColor = [UIColor grayColor];
        lblName.font = [UIFont systemFontOfSize:16];
        [v addSubview:lblName];
        CGSize s = [lblName.text textSizeWithFont:lblName.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        CGFloat maxw = mainWidth - 190;
        lblName.frame = CGRectMake(80, 20, s.width > maxw ? maxw : s.width, 15);
        
        UILabel* lblPhone = [[UILabel alloc] init];
        lblPhone.text = [NSString stringWithFormat:@"(%@)",[UserInstance ShardInstnce].userPhone];
        lblPhone.textColor = [UIColor lightGrayColor];
        lblPhone.font = [UIFont systemFontOfSize:14];
        lblPhone.frame = CGRectMake(lblName.frame.size.width + lblName.frame.origin.x + 5, 20, 200, 14) ;
        [v addSubview:lblPhone];
        
        UIImageView* imgLevel = [[UIImageView alloc] initWithFrame:CGRectMake(85, 50, 12, 12)];
        NSString* level = [NSString stringWithFormat:@"degree%d",[[UserInstance ShardInstnce].userLevel intValue]];
        imgLevel.image = [UIImage imageNamed:level];
        [v addSubview:imgLevel];
        
        UILabel* lblLevel = [[UILabel alloc] initWithFrame:CGRectMake(103, 50, 200, 12)];
        lblLevel.textColor = [UIColor lightGrayColor];
        lblLevel.text = [UserInstance ShardInstnce].userLevelName;
        lblLevel.font = [UIFont systemFontOfSize:12];
        [v addSubview:lblLevel];
        
        UILabel* lblExp = [[UILabel alloc] initWithFrame:CGRectMake(170, 50, 200, 12)];
        lblExp.textColor = [UIColor lightGrayColor];
        lblExp.text = [NSString stringWithFormat:@"经验值:%@",[UserInstance ShardInstnce].userExp];
        lblExp.font = [UIFont systemFontOfSize:12];
        [v addSubview:lblExp];
        
        UILabel* lblFufen1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 200, 12)];
        lblFufen1.textColor = [UIColor lightGrayColor];
        lblFufen1.text = @"可用福分:";
        lblFufen1.font = [UIFont systemFontOfSize:12];
        [v addSubview:lblFufen1];
        
        UILabel* lblFufen2 = [[UILabel alloc] initWithFrame:CGRectMake(75, 90, 200, 12)];
        lblFufen2.textColor = mainColor;
        lblFufen2.text = [UserInstance ShardInstnce].userFuFen;
        lblFufen2.font = [UIFont systemFontOfSize:16];
        [v addSubview:lblFufen2];
        
        UILabel* lblMoney1 = [[UILabel alloc] initWithFrame:CGRectMake(120, 90, 200, 12)];
        lblMoney1.textColor = [UIColor lightGrayColor];
        lblMoney1.text = @"可用余额:";
        lblMoney1.font = [UIFont systemFontOfSize:12];
        [v addSubview:lblMoney1];
        
        UILabel* lblMoney2 = [[UILabel alloc] initWithFrame:CGRectMake(173, 90, 200, 12)];
        lblMoney2.textColor = mainColor;
        lblMoney2.text = [UserInstance ShardInstnce].userMoney;
        lblMoney2.font = [UIFont systemFontOfSize:16];
        [v addSubview:lblMoney2];
        
        UIButton* btnPay = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth - 60, 80, 50, 30)];
        [btnPay setTitle:@"充值" forState:UIControlStateNormal];
        [btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnPay setBackgroundColor:mainColor];
        btnPay.titleLabel.font = [UIFont systemFontOfSize:13];
        btnPay.layer.cornerRadius = 4;
        [btnPay addTarget:self action:@selector(btnPayAction) forControlEvents:UIControlEventTouchUpInside];
        [v  addSubview:btnPay];
    }
    return self;
}

- (void)btnPayAction
{
    if(delegate)
    {
        [delegate btnPayAction];
    }
}
@end
