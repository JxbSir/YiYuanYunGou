//
//  ProductLotteryCodeCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/28.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "ProductLotteryCodeCell.h"

@interface ProductLotteryCodeCell ()
{
    UILabel* lblTime;
    UILabel* lblCode;
}
@end

@implementation ProductLotteryCodeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, mainWidth, 13)];
        lblTime.font = [UIFont systemFontOfSize:13];
        lblTime.textColor = [UIColor grayColor];
        [self addSubview:lblTime];
        
        lblCode = [[UILabel alloc] init];
        lblCode.font = [UIFont systemFontOfSize:13];
        lblCode.textColor = [UIColor lightGrayColor];
        lblCode.numberOfLines = 9999;
        lblCode.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:lblCode];
    }
    return self;
}

- (void)setCodes:(ProductCodeBuy*)codes
{
    NSArray* codeCount = [[Jxb_Common_Common sharedInstance] getSpiltString:codes.rnoNum split:@","];
    lblTime.text = [NSString stringWithFormat:@"%@   -   %d 人次",codes.buyTime,(int)codeCount.count];
    
    lblCode.text = codes.rnoNum;
    CGSize s = [lblCode.text textSizeWithFont:lblCode.font constrainedToSize:CGSizeMake(mainWidth - 30, 999) lineBreakMode:NSLineBreakByWordWrapping];
    lblCode.frame = CGRectMake(16, 30, mainWidth - 30, s.height);
}
@end
