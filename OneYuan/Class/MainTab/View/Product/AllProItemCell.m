//
//  AllProItemCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/21.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "AllProItemCell.h"
#import "CartModel.h"
#import "AppDelegate.h"
#import "CartInstance.h"

@interface AllProItemCell ()
{
    ProCellType     _type;
    AllProItme      *_myItem;
    
    UIImageView *imgPro;
    
    UILabel     *lblTitle;
    UILabel     *lblPrice;
    
    UIProgressView  *progress;
    
    UILabel         *lblNowNum;
    UILabel         *lblAllNum;
    UILabel         *lblLeftNum;
}

@end

@implementation AllProItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        imgPro.image = [UIImage imageNamed:@"noimage"];
        imgPro.layer.borderWidth = 0.5;
        imgPro.layer.cornerRadius = 10;
        imgPro.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgPro.layer.masksToBounds = YES;
        [self addSubview:imgPro];
        
        lblTitle = [[UILabel alloc] init];
        lblTitle.numberOfLines = 2;
        lblTitle.font = [UIFont systemFontOfSize:15];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblTitle];
        
        lblPrice = [[UILabel alloc] init];
        lblPrice.font = [UIFont systemFontOfSize:12];
        lblPrice.textColor = [UIColor lightGrayColor];
        [self addSubview:lblPrice];
        
        if(![OyTool ShardInstance].bIsForReview)
        {
            UIButton* btnCart = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth - 50, 70, 35, 35)];
            [btnCart setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
            [btnCart addTarget:self action:@selector(addCartAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btnCart];
        }
        
        progress = [[UIProgressView alloc] initWithFrame:CGRectMake(120, 80, mainWidth - 180, 30)];
        progress.progressTintColor = mainColor;
        [self addSubview:progress];
        
        lblNowNum = [[UILabel alloc] initWithFrame:CGRectMake(120, 85, 100, 13)];
        lblNowNum.textColor = mainColor;
        lblNowNum.font = [UIFont systemFontOfSize:10];
        [self addSubview:lblNowNum];
        
        lblAllNum = [[UILabel alloc] init];
        lblAllNum.textColor = [UIColor grayColor];
        lblAllNum.font = [UIFont systemFontOfSize:10];
        [self addSubview:lblAllNum];
        
        lblLeftNum = [[UILabel alloc] init];
        lblLeftNum.textColor = [UIColor hexFloatColor:@"3385ff"];
        lblLeftNum.font = [UIFont systemFontOfSize:10];
        [self addSubview:lblLeftNum];
        
        UILabel* lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(120, 100, 100, 13)];
        lbl1.text = @"已参与";
        lbl1.textColor = [UIColor grayColor];
        lbl1.font = [UIFont systemFontOfSize:8];
        [self addSubview:lbl1];
        
        UILabel* lbl2 = [[UILabel alloc] init];
        lbl2.text = @"总需人次";
        lbl2.textColor = [UIColor grayColor];
        lbl2.font = [UIFont systemFontOfSize:8];
        CGSize s = [lbl2.text textSizeWithFont:lbl2.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lbl2.frame = CGRectMake(120 + (progress.frame.size.width - s.width) / 2, lbl1.frame.origin.y, s.width, 13);
        [self addSubview:lbl2];
        
        UILabel* lbl3 = [[UILabel alloc] init];
        lbl3.text = @"剩余";
        lbl3.textColor = [UIColor grayColor];
        lbl3.font = [UIFont systemFontOfSize:8];
        s = [lbl3.text textSizeWithFont:lbl3.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
        lbl3.frame = CGRectMake(120 + progress.frame.size.width - s.width, lbl1.frame.origin.y, s.width, 13);
        [self addSubview:lbl3];
    }
    return self;
}

- (void)setProItem:(AllProItme*)item type:(ProCellType)type
{
    _type = type;
    _myItem = item;
    [imgPro setImage_oy:oyImageBaseUrl image:item.goodsPic];
    
    lblTitle.text = item.goodsSName;
    CGSize s = [lblTitle.text textSizeWithFont:lblTitle.font constrainedToSize:CGSizeMake(mainWidth - 130, 40) lineBreakMode:NSLineBreakByCharWrapping];
    lblTitle.frame = CGRectMake(120, 15, mainWidth - 130, s.height < 40 ? s.height : 40);
    
    lblPrice.text = [NSString stringWithFormat:@"价值：%@.00",[item.codePrice stringValue]];
    lblPrice.frame = CGRectMake(120, lblTitle.frame.origin.y + lblTitle.frame.size.height + 5, mainWidth - 130, 20);
    
    lblNowNum.text = [item.codeSales stringValue];
    lblAllNum.text = [item.codeQuantity stringValue];
    lblLeftNum.text = [NSString stringWithFormat:@"%d",[item.codeQuantity intValue] - [item.codeSales intValue]];
    
    s = [lblLeftNum.text textSizeWithFont:lblLeftNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblLeftNum.frame = CGRectMake(120 + progress.frame.size.width - s.width , lblNowNum.frame.origin.y, s.width, 13);
    
    s = [lblAllNum.text textSizeWithFont:lblAllNum.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    lblAllNum.frame = CGRectMake(120 + (progress.frame.size.width - s.width)/2, lblNowNum.frame.origin.y, s.width, 13);
    
    progress.progress = [item.codeSales doubleValue]/ [item.codeQuantity doubleValue];
}

-(void)addCartAction
{
    CartItem* item = [[CartItem alloc] init];
    item.cPid = _myItem.goodsID;
    item.cName = _myItem.goodsSName;
    item.cPeriod = _myItem.codePeriod;
    item.cBuyNum = [NSNumber numberWithInt:1];
    item.cCid = _myItem.codeID;
    item.cPrice = _myItem.codePrice;
    item.cSrc = [NSString stringWithFormat:@"%@%@",oyImageBaseUrl,_myItem.goodsPic];
    
    [[CartInstance ShartInstance] addToCart:item imgPro:imgPro type:_type == ProCellType_All ? addCartType_Tab : addCartType_Search];
}
@end
