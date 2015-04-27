//
//  HomeAdCell.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/19.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "HomeAdCell.h"
#import "JxbAdPageView.h"
#import "HomeModel.h"

@interface HomeAdCell ()<JxbAdPageViewDelegate>
{
    __weak id<HomeAdCellDelegate> delegate;
    JxbAdPageView      *adPage;
    __block  NSArray            *adArr;
}

@end

@implementation HomeAdCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        adPage = [[JxbAdPageView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 150)];
        adPage.delegate = self;
        [self addSubview:adPage];
    }
    return self;
}

- (void)getAds
{
    [HomeModel getAds:^(AFHTTPRequestOperation* operation,NSObject* result){
        HomeAdList* ads = [[HomeAdList alloc] initWithDictionary:(NSDictionary*)result];
        adArr = ads.Rows;
        NSMutableArray* arrNames = [NSMutableArray array];
        for (HomeAd* ad in ads.Rows) {
            [arrNames addObject:ad.src];
        }
        if([OyTool ShardInstance].bIsForReview)
        {
            [adPage setAds:@[@"http://img.1yyg.com/Poster/20140918182340689.jpg"]];
        }
        else
            [adPage setAds:arrNames];
    } failure:^(NSError* error){
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取首页顶部异常：%@",error]];
    }];
}

- (void)click:(int)index
{
    if(delegate)
    {
        if([OyTool ShardInstance].bIsForReview)
        {
            return;
        }
        HomeAd* ad = [adArr objectAtIndex:index];
        [delegate adClick:ad.url];
    }
}
@end
