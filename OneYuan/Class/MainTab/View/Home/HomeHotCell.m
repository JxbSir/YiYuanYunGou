//
//  HomeHotCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/19.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "HomeHotCell.h"
#import "HomeHotView.h"
#import "HomeModel.h"

#define perWidth    120
#define perHeight   200

@interface HomeHotCell ()
{
    __weak id<HomeHotCellDelegate> delegate;
    
    UIScrollView    *svView;
    NSArray         *myData;
}
@end

@implementation HomeHotCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        svView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, perHeight)];
        svView.bounces = NO;
        svView.contentSize = CGSizeMake(perWidth*6, perHeight);
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tap];
        [self addSubview:svView];
        
        for (int i = 0 ;i < 6; i++)
        {
            if(i > 0 && i < 6)
            {
                UIImageView* imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(i*perWidth, 0, 1, perHeight)];
                imgLine.backgroundColor = [UIColor hexFloatColor:@"dedede"];
                [svView addSubview:imgLine];
            }
            HomeHotView* v = [[HomeHotView alloc] initWithFrame:CGRectMake(perWidth*i, 0, perWidth, perHeight)];
            v.stringTag = [@"HomeHotView" stringByAppendingFormat:@"_%d",i];
            [svView addSubview:v];
        }
    }
    return self;
}

- (void)setHots:(NSArray*)arrOfHots
{
    myData = arrOfHots;
    for (int i = 0; i < 6; i++)
    {
        NSString* stringTag = [@"HomeHotView" stringByAppendingFormat:@"_%d",i];
        HomeHotView* v = (HomeHotView*)[svView viewWithStringTag:stringTag];
        HomeHostest* hot = [arrOfHots objectAtIndex:i];
        [v setHot:hot];
    }
}

- (void)tapClick:(UITapGestureRecognizer*)tap
{
    CGPoint point = [tap locationInView:svView];
    int page = point.x / perWidth;
    HomeHostest* hot = [myData objectAtIndex:page];
    if(delegate)
    {
        [delegate adClick:[NSString stringWithFormat:@"goodsdetail,%@",[hot.goodsID stringValue]]];
    }
}
@end
