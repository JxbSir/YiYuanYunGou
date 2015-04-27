//
//  MineShowOrderCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/25.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineShowOrderCell.h"

@interface MineShowOrderCell ()
{
    UIImageView     *imgPro;
    
    UILabel         *lblTitle;
    UILabel         *lblContent;
    UILabel         *lblTime;
    UILabel         *lblState;
    UILabel         *lblFufen;
}
@end

@implementation MineShowOrderCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 100, 100)];
        imgPro.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgPro.layer.borderWidth = 0.5;
        imgPro.layer.cornerRadius = 5;
        imgPro.layer.masksToBounds = YES;
        [self addSubview:imgPro];
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(120, 15, mainWidth - 120, 15)];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.font = [UIFont systemFontOfSize:16];
        lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblTitle];
        
        lblContent = [[UILabel alloc] init];
        lblContent.font = [UIFont systemFontOfSize:12];
        lblContent.textColor = [UIColor lightGrayColor];
        lblContent.frame = CGRectMake(120, 30, mainWidth - 120, 40);
        lblContent.numberOfLines = 2;
        lblContent.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblContent];
        
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(120, 70, mainWidth - 120, 15)];
        lblTime.textColor = [UIColor lightGrayColor];
        lblTime.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblTime];
        
        
        UILabel* lblS = [[UILabel alloc] initWithFrame:CGRectMake(120, 90, mainWidth - 120, 15)];
        lblS.textColor = [UIColor lightGrayColor];
        lblS.font = [UIFont systemFontOfSize:12];
        lblS.text = @"状态：";
        [self addSubview:lblS];
        
        lblState = [[UILabel alloc] initWithFrame:CGRectMake(155, 90, mainWidth - 120, 15)];
        lblState.textColor = [UIColor lightGrayColor];
        lblState.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblState];
        
        lblFufen = [[UILabel alloc] initWithFrame:CGRectMake(120, 110, mainWidth - 120, 15)];
        lblFufen.textColor = [UIColor lightGrayColor];
        lblFufen.font = [UIFont systemFontOfSize:12];
        [self addSubview:lblFufen];

    }
    return self;
}

- (void)setMyPost:(MineShowOrderItem *)item
{
    [imgPro setImage_oy:oyImageBigUrl image:item.postPic];
    
    lblTitle.text = item.postTitle;
    lblContent.text = item.postContent;
    lblTime.text = [NSString stringWithFormat:@"晒单时间：%@",item.postTime];
    lblFufen.text = [NSString stringWithFormat:@"奖励福分：%@",item.postPoint];
    
    if ([item.postState intValue] == 0)
    {
        lblState.text = @"正在审核";
        lblState.textColor = mainColor;
    }
    else if ([item.postState intValue] == 1)
    {
        lblState.text = @"审核失败";
        lblState.textColor = [UIColor grayColor];
    }
    else if ([item.postState integerValue] == 2)
    {
        lblState.text = @"审核通过";
        lblState.textColor = [UIColor hexFloatColor:@"41c012"];
    }
}

@end
