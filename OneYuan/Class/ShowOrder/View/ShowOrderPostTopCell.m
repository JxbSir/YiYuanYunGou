//
//  ShowOrderPostTopCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/28.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "ShowOrderPostTopCell.h"

@interface ShowOrderPostTopCell ()
{
    UIImageView *imgHead;
    UIImageView *imgGet;
    UILabel     *lblName;
    UILabel     *lblNum;
    UILabel     *lblTitle;
    UILabel     *lblFufen;
    
    UILabel     *lblPostTitle;
    UILabel     *lblPostTime;
    UILabel     *lblPostContent;
    
    UIImageView*    imgPro1;
    UIImageView*    imgPro2;
    UIImageView*    imgPro3;
    UIImageView*    imgPro4;
    UIImageView*    imgPro5;
    UIImageView*    imgPro6;
}
@end

@implementation ShowOrderPostTopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView* vTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 80)];
        vTop.backgroundColor = [UIColor hexFloatColor:@"f7f7f7"];
        [self addSubview: vTop];
        
        imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        imgHead.layer.cornerRadius = 30;
        imgHead.layer.borderColor = [[UIColor whiteColor] CGColor];
        imgHead.layer.borderWidth = 2;
        imgHead.layer.masksToBounds = YES;
        [vTop addSubview:imgHead];
        
        lblName = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, mainWidth - 100, 15)];
        lblName.textColor = [UIColor hexFloatColor:@"3385ff"];
        lblName.font = [UIFont systemFontOfSize:15];
        [vTop addSubview:lblName];
        
        lblNum = [[UILabel alloc] initWithFrame:CGRectMake(80, 32.5, mainWidth - 100, 15)];
        lblNum.textColor = [UIColor grayColor];
        lblNum.font = [UIFont systemFontOfSize:12];
        [vTop addSubview:lblNum];
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, mainWidth - 100, 15)];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.font = [UIFont systemFontOfSize:12];
        lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [vTop addSubview:lblTitle];
        
        imgGet = [[UIImageView alloc] initWithFrame:CGRectMake(mainWidth - 90, 0, 80, 40)];
        [imgGet setImage:[UIImage imageNamed:@"award_flag"]];
        [vTop addSubview:imgGet];
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(18, 5, 50, 12)];
        lbl.text = @"奖励福分";
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont systemFontOfSize:11];
        [imgGet addSubview:lbl];
        
        lblFufen = [[UILabel alloc] init];
        lblFufen.text = @"800";
        lblFufen.textColor = [UIColor whiteColor];
        lblFufen.font = [UIFont systemFontOfSize:10];
        [imgGet addSubview:lblFufen];
        
        lblPostTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, mainWidth - 20, 15)];
        lblPostTitle.textColor = [UIColor grayColor];
        lblPostTitle.font = [UIFont systemFontOfSize:14];
        lblPostTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblPostTitle];
        
        lblPostTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, mainWidth - 20, 15)];
        lblPostTime.textColor = [UIColor lightGrayColor];
        lblPostTime.font = [UIFont systemFontOfSize:14];
        [self addSubview:lblPostTime];
        
        lblPostContent = [[UILabel alloc] init];
        lblPostContent.textColor = [UIColor lightGrayColor];
        lblPostContent.font = [UIFont systemFontOfSize:14];
        lblPostContent.lineBreakMode = NSLineBreakByCharWrapping;
        lblPostContent.numberOfLines = 999;
        [self addSubview:lblPostContent];
        
        imgPro1 = [[UIImageView alloc] init];
        imgPro1.image = [UIImage imageNamed:@"noimage"];
        [self addSubview:imgPro1];
        
        imgPro2 = [[UIImageView alloc] init];
        imgPro2.image = [UIImage imageNamed:@"noimage"];
        [self addSubview:imgPro2];
        
        imgPro3 = [[UIImageView alloc] init];
        imgPro3.image = [UIImage imageNamed:@"noimage"];
        [self addSubview:imgPro3];
        
        imgPro4 = [[UIImageView alloc] init];
        imgPro4.image = [UIImage imageNamed:@"noimage"];
        [self addSubview:imgPro4];
        
        imgPro5 = [[UIImageView alloc] init];
        imgPro5.image = [UIImage imageNamed:@"noimage"];
        [self addSubview:imgPro5];
        
        imgPro6 = [[UIImageView alloc] init];
        imgPro6.image = [UIImage imageNamed:@"noimage"];
        [self addSubview:imgPro6];
    }
    return self;
}

- (void)setPost:(ShowOrderPostItem*)item
{
    [imgHead setImage_oy:oyHeadBaseUrl image:item.userPhoto];
    
    lblName.text = item.userName;
    lblNum.text = [NSString stringWithFormat:@"本期云购： %d 人次",[item.codeRUserBuyCount intValue]];
    lblTitle.text = [NSString stringWithFormat:@"(第%d期)%@",[item.codePeriod intValue],item.codeGoodsSName];
    
    lblFufen.text = [item.postPoint stringValue];
    CGSize s = [lblFufen.text textSizeWithFont:lblFufen.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByWordWrapping];
    lblFufen.frame = CGRectMake((imgGet.frame.size.width - s.width) / 2, 18, s.width, 12);
    
    lblPostTitle.text = item.postTitle;
    lblPostTime.text = item.postTime;
    lblPostContent.text = item.postContent;
    
    s = [lblPostContent.text textSizeWithFont:lblPostContent.font constrainedToSize:CGSizeMake(mainWidth - 20, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblPostContent.frame = CGRectMake(10, 130, mainWidth - 20, s.height);
    
    NSArray* arrImg = [[Jxb_Common_Common sharedInstance] getSpiltString:item.postAllPic split:@","];
    
    imgPro1.frame = CGRectMake(10, lblPostContent.frame.origin.y + s.height + 20, mainWidth - 20, 300);
    [imgPro1 setImage_oy:oyImageBigUrl image:[arrImg objectAtIndex:0]];
    
    if(arrImg.count<2)
    {
        [imgPro2 setHidden:YES];
    }
    else
    {
        imgPro2.frame = CGRectMake(10, lblPostContent.frame.origin.y + s.height + 330, mainWidth - 20, 300);
        [imgPro2 setImage_oy:oyImageBigUrl image:[arrImg objectAtIndex:1]];
    }
    
    if(arrImg.count<3)
    {
        [imgPro3 setHidden:YES];
    }
    else
    {
        imgPro3.frame = CGRectMake(10, lblPostContent.frame.origin.y + s.height + 640, mainWidth - 20, 300);
        [imgPro3 setImage_oy:oyImageBigUrl image:[arrImg objectAtIndex:2]];
    }
    
    if(arrImg.count<4)
    {
        [imgPro4 setHidden:YES];
    }
    else
    {
        imgPro4.frame = CGRectMake(10, lblPostContent.frame.origin.y + s.height + 950, mainWidth - 20, 300);
        [imgPro4 setImage_oy:oyImageBigUrl image:[arrImg objectAtIndex:3]];
    }
    
    if(arrImg.count<5)
    {
        [imgPro5 setHidden:YES];
    }
    else
    {
        imgPro5.frame = CGRectMake(10, lblPostContent.frame.origin.y + s.height + 1260, mainWidth - 20, 300);
        [imgPro5 setImage_oy:oyImageBigUrl image:[arrImg objectAtIndex:4]];
    }
    
    if(arrImg.count<6)
    {
        [imgPro6 setHidden:YES];
    }
    else
    {
        imgPro6.frame = CGRectMake(10, lblPostContent.frame.origin.y + s.height + 1570, mainWidth - 20, 300);
        [imgPro6 setImage_oy:oyImageBigUrl image:[arrImg objectAtIndex:5]];
    }
}
@end
