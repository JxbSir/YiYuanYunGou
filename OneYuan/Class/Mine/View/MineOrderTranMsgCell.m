//
//  MineOrderTranMsgCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/28.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineOrderTranMsgCell.h"

@interface MineOrderTranMsgCell ()
{
    UILabel* lblMsg;
    UILabel* lblTime;
    
    UIImageView* imgline;
    UIImageView* imgDot;
}
@end

@implementation MineOrderTranMsgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgline = [[UIImageView alloc] init];
        [self addSubview:imgline];
        
        imgDot = [[UIImageView alloc] init];
        imgDot.layer.borderWidth = 2;
        imgDot.layer.cornerRadius = 5;
        imgDot.layer.borderColor  = [[UIColor whiteColor] CGColor];
        [self addSubview:imgDot];
        
        lblMsg = [[UILabel alloc] init];
        lblMsg.font = [UIFont systemFontOfSize:12];
        lblMsg.textColor = [UIColor grayColor];
        lblMsg.lineBreakMode = NSLineBreakByCharWrapping;
        lblMsg.numberOfLines = 0;
        [self addSubview:lblMsg];
        
        lblTime = [[UILabel alloc] init];
        lblTime.font = [UIFont systemFontOfSize:12];
        lblTime.textColor = [UIColor lightGrayColor];
        [self addSubview:lblTime];
    }
    return self;
}

- (void)setTrans:(MineMyOrderTransInfo *)info index:(int)index last:(BOOL)last
{
    lblMsg.text = info.msg;
    CGSize s = [lblMsg.text textSizeWithFont:lblMsg.font constrainedToSize:CGSizeMake(mainWidth - 60, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblMsg.frame = CGRectMake(30, 5, mainWidth - 40, s.height);
    
    lblTime.text = info.time;
    lblTime.frame = CGRectMake(30, 10 + s.height, mainWidth - 40, 13);
    
    if(index == 0)
    {
        imgline.frame = CGRectMake(12, (s.height + 30)/ 2, 3, (s.height + 30) / 2);
        imgline.backgroundColor = mainColor;
        imgDot.backgroundColor = mainColor;
    }
    else if (last)
    {
        imgline.frame = CGRectMake(12, 0, 3, (s.height + 30) / 2);
        imgline.backgroundColor = [UIColor hexFloatColor:@"dedede"];
        imgDot.backgroundColor = [UIColor hexFloatColor:@"dedede"];
    }
    else
    {
        imgline.frame = CGRectMake(12, 0, 3, s.height + 30);
        imgline.backgroundColor = [UIColor hexFloatColor:@"dedede"];
        imgDot.backgroundColor = [UIColor hexFloatColor:@"dedede"];
    }
    imgDot.frame = CGRectMake(8.5, (s.height + 30) / 2 - 5, 10, 10);
}
@end
