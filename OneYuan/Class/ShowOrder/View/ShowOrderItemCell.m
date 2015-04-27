//
//  ShowOrderItemCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/28.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "ShowOrderItemCell.h"

@interface ShowOrderItemCell ()
{
    UIImageView *imgHead;
    UIImageView *imgLine1;
    //UIImageView *imgLine2;
    
    UILabel     *lblName;
    UILabel     *lblTime;
    UILabel     *lblTitle;
    UILabel     *lblContent;
    
    
    UIImageView *imgPro1;
    UIImageView *imgPro2;
    UIImageView *imgPro3;
}
@end

@implementation ShowOrderItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        imgHead.image = [UIImage imageNamed:@"noimage"];
        imgHead.layer.cornerRadius = 20;
        imgHead.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgHead.layer.borderWidth = 2;
        imgHead.layer.masksToBounds = YES;
        [self addSubview:imgHead];
        
        imgLine1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 55, mainWidth -20, 0.5)];
        imgLine1.backgroundColor = [UIColor hexFloatColor:@"dedede"];
        [self addSubview:imgLine1];
        
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, mainWidth, 14)];
        lblName.textColor = [UIColor hexFloatColor:@"3385ff"];
        lblName.font = [UIFont systemFontOfSize:13];
        [self addSubview:lblName];
        
        lblTime = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, mainWidth, 14)];
        lblTime.textColor = [UIColor lightGrayColor];
        lblTime.font = [UIFont systemFontOfSize:13];
        [self addSubview:lblTime];
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(55, 30, mainWidth - 65, 15)];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.font = [UIFont systemFontOfSize:15];
        [self addSubview:lblTitle];
        
        lblContent = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, mainWidth - 20, 30)];
        lblContent.textColor = [UIColor lightGrayColor];
        lblContent.font = [UIFont systemFontOfSize:12];
        lblContent.numberOfLines = 2;
        lblContent.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblContent];
        
        CGFloat w = (mainWidth - 60) / 3;
        
        imgPro1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100,w, 100)];
        imgPro1.image = [UIImage imageNamed:@"noimage"];
        imgPro1.layer.cornerRadius = 5;
        imgPro1.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgPro1.layer.borderWidth = 0.5;
        imgPro1.layer.masksToBounds = YES;
        [self addSubview:imgPro1];
        
        imgPro2 = [[UIImageView alloc] initWithFrame:CGRectMake(30 + w, 100,w, 100)];
        imgPro2.image = [UIImage imageNamed:@"noimage"];
        imgPro2.layer.cornerRadius = 5;
        imgPro2.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgPro2.layer.borderWidth = 0.5;
        imgPro2.layer.masksToBounds = YES;
        [self addSubview:imgPro2];
        
        imgPro3 = [[UIImageView alloc] initWithFrame:CGRectMake(50 + w + w, 100,w, 100)];
        imgPro3.image = [UIImage imageNamed:@"noimage"];
        imgPro3.layer.cornerRadius = 5;
        imgPro3.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgPro3.layer.borderWidth = 0.5;
        imgPro3.layer.masksToBounds = YES;
        [self addSubview:imgPro3];
        
//        imgLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 210, mainWidth -20, 0.5)];
//        imgLine2.backgroundColor = [UIColor hexFloatColor:@"dedede"];
//        [self addSubview:imgLine2];
    }
    return self;
}

- (void)setShow:(ShowOrderItem*)item
{
    [imgHead setImage_oy:oyHeadBaseUrl image:item.userPhoto];
    
    lblName.text = item.userName;
    lblTime.text = item.postTime;
    CGSize s = [lblName.text textSizeWithFont:lblName.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblTime.frame = CGRectMake(lblName.frame.origin.x + s.width + 10, 10, 200, 14);

    lblTitle.text = item.postTitle;
    lblContent.text = item.postContent;
    
    NSArray* arrPic = [[Jxb_Common_Common sharedInstance] getSpiltString:item.postAllPic split:@","];
    imgPro3.hidden = arrPic.count < 3;
    imgPro2.hidden = arrPic.count < 2;
    [imgPro1 setImage_oy:oyImageBigUrl image:[arrPic objectAtIndex:0]];
    if(arrPic.count > 1)
        [imgPro2 setImage_oy:oyImageBigUrl image:[arrPic objectAtIndex:1]];
    if(arrPic.count > 2)
        [imgPro3 setImage_oy:oyImageBigUrl image:[arrPic objectAtIndex:2]];
}
@end
