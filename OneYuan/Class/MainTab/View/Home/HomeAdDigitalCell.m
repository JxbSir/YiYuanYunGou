//
//  HomeAdDigitalCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/20.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "HomeAdDigitalCell.h"
#import "HomeModel.h"
#import "HomeInstance.h"

@interface HomeAdDigitalCell ()
{
    __weak id<HomeAdDigitalCellDelegate> delegate;
    
    UIImageView     *imgMain;
    UIImageView     *imgCom;
    UIImageView     *imgPhone;
    UIImageView     *imgCar;
    UIImageView     *imgCamera;
}
@end

@implementation HomeAdDigitalCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
  
        UIImageView* line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 180, mainWidth, 0.5)];
        line1.backgroundColor = [UIColor hexFloatColor:@"dedede"];
        [self addSubview:line1];
        
        UIImageView* line2 = [[UIImageView alloc] initWithFrame:CGRectMake(mainWidth / 2, 90, mainWidth / 2, 0.5)];
        line2.backgroundColor = [UIColor hexFloatColor:@"dedede"];
        [self addSubview:line2];
        
        UIImageView* line3 = [[UIImageView alloc] initWithFrame:CGRectMake(mainWidth / 2, 0, 0.5, 270)];
        line3.backgroundColor = [UIColor hexFloatColor:@"dedede"];
        [self addSubview:line3];
        
        imgMain = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainWidth/2-0.5, 179.5)];
        imgMain.image = [UIImage imageNamed:@"noimage"];
        imgMain.userInteractionEnabled = YES;
        UITapGestureRecognizer* gMain = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagMain)];
        [imgMain addGestureRecognizer:gMain];
        [self addSubview:imgMain];
        
        imgCom = [[UIImageView alloc] initWithFrame:CGRectMake(mainWidth/2+0.5, 0, mainWidth/2, 89.5)];
        imgCom.image = [UIImage imageNamed:@"noimage"];
        imgCom.userInteractionEnabled = YES;
        UITapGestureRecognizer* gCom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagCom)];
        [imgCom addGestureRecognizer:gCom];
        [self addSubview:imgCom];
        
        imgPhone = [[UIImageView alloc] initWithFrame:CGRectMake(mainWidth/2+0.5, 90.5, mainWidth/2, 89.5)];
        imgPhone.image = [UIImage imageNamed:@"noimage"];
        imgPhone.userInteractionEnabled = YES;
        UITapGestureRecognizer* gPhone = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagPhone)];
        [imgPhone addGestureRecognizer:gPhone];
        [self addSubview:imgPhone];
        
        imgCar = [[UIImageView alloc] initWithFrame:CGRectMake(mainWidth/2+0.5, 180.5, mainWidth/2, 89.5)];
        imgCar.image = [UIImage imageNamed:@"noimage"];
        imgCar.userInteractionEnabled = YES;
        UITapGestureRecognizer* gCar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagCar)];
        [imgCar addGestureRecognizer:gCar];
        [self addSubview:imgCar];
        
        imgCamera = [[UIImageView alloc] initWithFrame:CGRectMake(0, 180.5, mainWidth/2-0.5, 89.5)];
        imgCamera.image = [UIImage imageNamed:@"noimage"];
        imgCamera.userInteractionEnabled = YES;
        UITapGestureRecognizer* g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagCamera)];
        [imgCamera addGestureRecognizer:g];
        [self addSubview:imgCamera];
        
    }
    return self;
}

- (void)tagMain
{
    if(delegate)
    {
        HomeSearchAd* ad = [[HomeInstance ShardInstnce].listAd1.Rows objectAtIndex:0];
        [delegate adClick:ad.url];
    }
}

- (void)tagCom
{
    if(delegate)
    {
        HomeSearchAd* ad = [[HomeInstance ShardInstnce].listAd2.Rows objectAtIndex:0];
        [delegate adClick:ad.url];
    }
}

- (void)tagPhone
{
    if(delegate)
    {
        HomeSearchAd* ad = [[HomeInstance ShardInstnce].listAd2.Rows objectAtIndex:1];
        [delegate adClick:ad.url];
    }
}

- (void)tagCamera
{
    if(delegate)
    {
        HomeSearchAd* ad = [[HomeInstance ShardInstnce].listAd2.Rows objectAtIndex:2];
        [delegate adClick:ad.url];
    }
}
- (void)tagCar
{
    if(delegate)
    {
        HomeSearchAd* ad = [[HomeInstance ShardInstnce].listAd2.Rows objectAtIndex:3];
        [delegate adClick:ad.url];
    }
}

- (void)doLoadAds
{
    if([HomeInstance ShardInstnce].listAd1)
    {
        [imgMain setImage_oy:nil image:[[[HomeInstance ShardInstnce].listAd1.Rows objectAtIndex:0] src]];
    }
    if([HomeInstance ShardInstnce].listAd2)
    {
        [imgCom setImage_oy:nil image:[[[HomeInstance ShardInstnce].listAd2.Rows objectAtIndex:0] src]];
        [imgPhone setImage_oy:nil image:[[[HomeInstance ShardInstnce].listAd2.Rows objectAtIndex:1] src]];
        [imgCamera setImage_oy:nil image:[[[HomeInstance ShardInstnce].listAd2.Rows objectAtIndex:2] src]];
        [imgCar setImage_oy:nil image:[[[HomeInstance ShardInstnce].listAd2.Rows objectAtIndex:3] src]];
    }
}
@end
