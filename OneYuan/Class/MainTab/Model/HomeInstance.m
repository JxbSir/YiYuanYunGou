//
//  HomeInstance.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/20.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "HomeInstance.h"

@interface HomeInstance()
{
    HomeSearchAdList    *listAd1;
    HomeSearchAdList    *listAd2;
    HomeNewingList      *listNewing;
    HomeOrderShowList   *listOrderShows;
}
@end


static HomeInstance* home;

@implementation HomeInstance
@synthesize listAd1,listAd2,listNewing,listOrderShows;

+(HomeInstance*)ShardInstnce
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        home = [[HomeInstance alloc] init];
    });
    return home;
}

@end
