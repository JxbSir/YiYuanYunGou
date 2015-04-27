//
//  CartCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/26.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "CartCell.h"

@interface CartCell ()
{
    __weak id<CartCellDelegate> delegate;
    
    CartItem    *myItem;
    
    UIImageView *imgPro;
    UILabel     *lblTitle;
    __block UILabel     *lblLeft;
    
    UIButton    *btnDown;
    UIButton    *btnAdd;
    UITextField *txtNum;
    
    int         maxNum;
}
@end

@implementation CartCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imgPro = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        imgPro.image = [UIImage imageNamed:@"noimage"];
        imgPro.layer.borderWidth = 0.5;
        imgPro.layer.cornerRadius = 10;
        imgPro.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        imgPro.layer.masksToBounds = YES;
        [self addSubview:imgPro];
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, mainWidth - 110, 35)];
        lblTitle.font = [UIFont systemFontOfSize:14];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.numberOfLines = 2;
        lblTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:lblTitle];
        
        lblLeft = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, mainWidth - 100, 15)];
        lblLeft.font = [UIFont systemFontOfSize:12];
        lblLeft.textColor = [UIColor lightGrayColor];
        lblLeft.text = @"正在统计...";
        [self addSubview:lblLeft];
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 75, mainWidth - 100, 15)];
        lbl.font = [UIFont systemFontOfSize:13];
        lbl.textColor = [UIColor lightGrayColor];
        lbl.text = @"云购人次";
        [self addSubview:lbl];
        
        btnDown = [[UIButton alloc] initWithFrame:CGRectMake(180, 60, 30, 30)];
        [btnDown setImage:[UIImage imageNamed:@"btndown_normal"] forState:UIControlStateNormal];
        [btnDown addTarget:self action:@selector(downnum) forControlEvents:UIControlEventTouchUpInside];
        [btnDown setEnabled:NO];
        [self addSubview:btnDown];
        
        txtNum = [[UITextField alloc] initWithFrame:CGRectMake(220, 60, mainWidth - 280, 30)];
        txtNum.layer.borderWidth = 0.5;
        txtNum.layer.borderColor = [[UIColor hexFloatColor:@"dedede"] CGColor];
        txtNum.layer.cornerRadius = 3;
        txtNum.font = [UIFont systemFontOfSize:13];
        txtNum.textAlignment = NSTextAlignmentCenter;
        txtNum.enabled = NO;
        [self addSubview:txtNum];
        
        btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth - 50, 60, 30, 30)];
        [btnAdd setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [btnAdd addTarget:self action:@selector(addnum) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnAdd];
    }
    return self;
}

- (void)setCart:(CartItem*)item
{
    myItem = item;
    [imgPro setImage_oy:nil image:item.cSrc];
    lblTitle.text = [NSString stringWithFormat:@"(第%@期)%@",[item.cPeriod stringValue],item.cName];
    txtNum.text = [item.cBuyNum stringValue];
    
    maxNum = 0;
    
    __weak typeof (self) wSelf = self;
    [CartModel getCartState:[item.cPid intValue] success:^(AFHTTPRequestOperation* operation, NSObject* result){
        NSString* body = (NSString*)result;
        NSString* curPeriod = [[Jxb_Common_Common sharedInstance] getMidString:body front:@"(第" end:@"期"];
        NSLog(@"curPeriod:%@",curPeriod);
        if([curPeriod isEqualToString:[item.cPeriod stringValue]])
        {
            NSString* buynum = [[Jxb_Common_Common sharedInstance] getMidString:body front:@"<li class=\"P-bar01\"><em>" end:@"<"];
            
            lblLeft.text = [NSString stringWithFormat:@"剩余%d人次",[item.cPrice intValue] - [buynum intValue]];
            
            maxNum = [item.cPrice intValue] - [buynum intValue];
            
            [wSelf setDis:[item.cBuyNum intValue]];
        }
        else
        {
            lblLeft.text = @"剩余0人次";
            [wSelf setDis:0];
        }
    } failure:^(NSError* error){
    
    }];
}

- (void)setDis:(int)num
{
    if(num <=0)
    {
        [btnDown setEnabled:NO];
        [btnAdd setEnabled:NO];
        txtNum.text = @"0";
        myItem.cBuyNum = [NSNumber numberWithInt:0];
        txtNum.text = [myItem.cBuyNum stringValue];
        [CartModel addorUpdateCart:myItem];
        if (delegate)
        {
            [delegate setOpt];
        }
    }
    else
    {
        if(num > 1)
            btnDown.enabled = YES;
        if(num >= maxNum)
        {
            myItem.cBuyNum = [NSNumber numberWithInt:maxNum];
            txtNum.text = [myItem.cBuyNum stringValue];
            [CartModel addorUpdateCart:myItem];
            [btnAdd setEnabled:NO];
        }
        else
        {
            [btnAdd setEnabled:YES];
        }
        
    }
}

- (void)addnum
{
    if([myItem.cBuyNum intValue] >= maxNum - 1)
    {
        [btnAdd setEnabled:NO];
    }
    [btnDown setEnabled:YES];
    myItem.cBuyNum = [NSNumber numberWithInt:[myItem.cBuyNum intValue] + 1];
    txtNum.text = [myItem.cBuyNum stringValue];
    
    [CartModel addorUpdateCart:myItem];
    
    if (delegate)
    {
        [delegate setOpt];
    }
    
}

- (void)downnum
{
    int num = [myItem.cBuyNum intValue];
    if(num <= 2)
    {
        [btnDown setEnabled:NO];
    }
    [btnAdd setEnabled:YES];
    myItem.cBuyNum = [NSNumber numberWithInt:num - 1];
    txtNum.text = [myItem.cBuyNum stringValue];
    
    [CartModel addorUpdateCart:myItem];
    
    if (delegate)
    {
        [delegate setOpt];
    }
}
@end
