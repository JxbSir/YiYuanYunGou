//
//  ProductDetailTopCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/27.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "ProductDetailTopCell.h"
#import "ProBuyingProgress.h"

@interface ProductDetailTopCell ()
{
    UIImageView *imgPro;
    UILabel     *lblTitle;
    UILabel     *lblSubTitle;
    UILabel     *lblPrice;
    
    ProBuyingProgress   *progress;
}
@end

@implementation ProductDetailTopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 120)];
        imgPro.image = [UIImage imageNamed:@"noimage"];
        imgPro.layer.cornerRadius = 5;
        imgPro.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgPro.layer.borderWidth = 0.5;
        imgPro.layer.masksToBounds = YES;
        [self addSubview:imgPro];
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(115, 10, mainWidth - 120, 50)];
        lblTitle.font = [UIFont systemFontOfSize:13];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.numberOfLines = 3;
        lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblTitle];
        
        lblSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(115, 60, mainWidth - 120, 50)];
        lblSubTitle.font = [UIFont systemFontOfSize:13];
        lblSubTitle.textColor = [UIColor redColor];
        lblSubTitle.numberOfLines = 3;
        lblSubTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblSubTitle];
        
        lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(115, 115, mainWidth - 120, 14)];
        lblPrice.font = [UIFont systemFontOfSize:13];
        lblPrice.textColor = [UIColor lightGrayColor];
        [self addSubview:lblPrice];
        
        progress = [[ProBuyingProgress alloc] initWithFrame:CGRectMake(10, 145, mainWidth - 20, 20)];
        [self addSubview:progress];
    }
    return self;
}

- (void)setProDetail:(ProductDetail*)detail img:(UIImageView**)img
{
    if(!detail)
        return;
    
    [imgPro setImage_oy:oyImageBaseUrl image:[[detail.Rows1 objectAtIndex:0] picName]];
    *img = imgPro;
    lblTitle.text = [NSString stringWithFormat:@"(第%d期)%@",[detail.Rows2.codePeriod intValue],detail.Rows2.goodsName];
    
    CGSize s  = [lblTitle.text textSizeWithFont:lblTitle.font constrainedToSize:CGSizeMake(mainWidth - 120, 999) lineBreakMode:NSLineBreakByCharWrapping];
    
    lblSubTitle.text = detail.Rows2.goodsAltName;
    
    if(s.height < 50)
    {
        lblTitle.frame = CGRectMake(115, 10, mainWidth - 120, s.height);
        
        lblSubTitle.numberOfLines = 4;
        lblSubTitle.frame  = CGRectMake(115, 10 + s.height, mainWidth - 120, 100 - s.height);
    }
    
    lblPrice.text = [NSString stringWithFormat:@"价值：￥%.2f",[detail.Rows2.codeQuantity doubleValue]];
    
    [progress setProgress:[detail.Rows2.codeQuantity doubleValue] now:[detail.Rows2.codeSales doubleValue]];
}

@end
