//
//  ProductLotteryTopCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/28.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "ProductLotteryTopCell.h"

@interface ProductLotteryTopCell ()
{
    UIImageView *imgPro;
    UIImageView *imgHead;
    UIImageView *imgline;
    UILabel     *lblName;
    UILabel     *lblArea;
    UILabel     *lblBtime;
    UILabel     *lblRtime;
}
@end

@implementation ProductLotteryTopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        imgPro.image = [UIImage imageNamed:@"noimage"];
        imgPro.layer.cornerRadius = 5;
        imgPro.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgPro.layer.borderWidth = 0.5;
        imgPro.layer.masksToBounds = YES;
        [self addSubview:imgPro];
        
        UIImageView *imgGet = [[UIImageView alloc] initWithFrame:CGRectMake(mainWidth - 60, 0, 50, 30)];
        [imgGet setImage:[UIImage imageNamed:@"award_flag"]];
        [self addSubview:imgGet];
        
        UILabel* lblGet = [[UILabel alloc] init];
        lblGet.font = [UIFont systemFontOfSize:10];
        lblGet.text = @"获得者";
        lblGet.textColor = [UIColor whiteColor];
        [imgGet addSubview:lblGet];
        
        CGSize s = [lblGet.text textSizeWithFont:lblGet.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lblGet.frame = CGRectMake((imgGet.frame.size.width - s.width ) /2, 5, s.width, s.height);
        
        
        imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(100, 10, 40, 40)];
        imgHead.layer.cornerRadius = imgHead.frame.size.height/ 2;
        imgHead.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgHead.layer.borderWidth = 2;
        imgHead.layer.masksToBounds = YES;
        [self addSubview:imgHead];
        
        imgline = [[UIImageView alloc] initWithFrame:CGRectMake(100, 60, mainWidth - 110, 0.5)];
        imgline.backgroundColor = [UIColor hexFloatColor:@"dedede"];
        [self addSubview:imgline];
        
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(145, 10, mainWidth - 200, 15)];
        lblName.textColor = [UIColor hexFloatColor:@"3385ff"];
        lblName.font = [UIFont systemFontOfSize:14];
        [self addSubview:lblName];
        
        lblArea = [[UILabel alloc] initWithFrame:CGRectMake(145, 30, mainWidth - 200, 15)];
        lblArea.textColor = [UIColor grayColor];
        lblArea.font = [UIFont systemFontOfSize:13];
        [self addSubview:lblArea];
        
        lblRtime = [[UILabel alloc] initWithFrame:CGRectMake(100, 65, mainWidth - 100, 15)];
        lblRtime.textColor = [UIColor lightGrayColor];
        lblRtime.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblRtime];
        
        lblBtime = [[UILabel alloc] initWithFrame:CGRectMake(100, 80, mainWidth - 100, 15)];
        lblBtime.textColor = [UIColor lightGrayColor];
        lblBtime.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblBtime];
    }
    return self;
}

- (void)setLottery:(ProductLotteryDetail *)lottery
{
    if(!lottery)
        return;
    
    [imgPro setImage_oy:oyImageBaseUrl image:lottery.Rows2.codeGoodsPic];
    [imgHead setImage_oy:oyHeadBaseUrl image:lottery.Rows2.userPhoto];
    lblName.text = lottery.Rows2.userName;
    lblArea.text = lottery.Rows2.codeRIpAddr;
    
    lblRtime.text = [NSString stringWithFormat:@"揭晓时间：%@",lottery.Rows2.codeRTime];
    lblBtime.text = [NSString stringWithFormat:@"云购时间：%@",lottery.Rows2.codeRBuyTime];
}
@end
