//
//  HomeInstance.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/20.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeModel.h"

@interface HomeInstance : NSObject

@property(nonatomic,strong) HomeSearchAdList    *listAd1;
@property(nonatomic,strong) HomeSearchAdList    *listAd2;
@property(nonatomic,strong) HomeNewingList      *listNewing;
@property(nonatomic,strong) HomeOrderShowList   *listOrderShows;

+(HomeInstance*)ShardInstnce;
@end
