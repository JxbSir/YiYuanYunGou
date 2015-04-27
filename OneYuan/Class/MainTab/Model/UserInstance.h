//
//  UserInstance.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/23.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInstance : NSObject

@property(nonatomic,readonly) NSString* userName;
@property(nonatomic,readonly) NSString* userPhone;
@property(nonatomic,readonly) NSString* userId;
@property(nonatomic,readonly) NSString* userPhoto;
@property(nonatomic,readonly) NSString* userFuFen;
@property(nonatomic,readonly) NSString* userExp;
@property(nonatomic,readonly) NSString* userMoney;
@property(nonatomic,readonly) NSString* userLevel;
@property(nonatomic,readonly) NSString* userLevelName;

+(UserInstance*)ShardInstnce;
- (void)logout;
- (void)isUserStillOnline;
@end
