//
//  UserInstance.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/23.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "UserInstance.h"
#import "UserModel.h"

static UserInstance* user = nil;

@interface UserInstance ()
{
    __block NSString* userName;
    __block NSString* userPhone;
    __block NSString* userId;
    __block NSString* userPhoto;
    __block NSString* userFuFen;
    __block NSString* userExp;
    __block NSString* userMoney;
    __block NSString* userLevel;
    __block NSString* userLevelName;
}

@end

@implementation UserInstance
@synthesize userName,userPhone,userId,userPhoto,userFuFen,userExp,userMoney,userLevel,userLevelName;

+(UserInstance*)ShardInstnce
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[UserInstance alloc] init];
    });
    return user;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doNotifyApns:) name:kDidNotifyApns object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isUserStillOnline) name:kDidReloadUser object:nil];
    }
    return self;
}

- (void)doNotifyApns:(NSNotification*)noti
{
    NSString* alter = noti.object;
    [[[UIAlertView alloc] initWithTitle:@"" message:alter delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
}

- (void)logout
{
    userName = nil;
    userPhone = nil;
    userId = nil;
    userPhoto = nil;
    userFuFen = nil;
    userExp = nil;
    userMoney = nil;
    userLevel = nil;
    userLevelName = nil;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kXBCookie];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)isUserStillOnline
{
    __weak typeof (self) wSelf = self;
    
    NSString* cookie = [[[NSUserDefaults standardUserDefaults] objectForKey:kXBCookie] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(!cookie || cookie.length == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginOk object:nil];
        return;
    }

    [UserModel getUserInfo:^(AFHTTPRequestOperation* operation, NSObject* result){
        OYUser* user = [[OYUser alloc] initWithDictionary:(NSDictionary*)result];
        if ([user.code intValue] == 0)
        {
            userName = user.username;
            [UserModel getUserDetail:^(AFHTTPRequestOperation* operation, NSObject* result){
                NSString* body = [NSString stringWithFormat:@"%@",result];
                userFuFen = [[Jxb_Common_Common sharedInstance] getMidString:body front:@"可用福分 <span class=\"orange\">" end:@"<"];
                userExp = [[Jxb_Common_Common sharedInstance] getMidString:body front:@"经验值 <span class=\"orange\">" end:@"<"];
                userMoney = [[Jxb_Common_Common sharedInstance] getMidString:body front:@"余额 <span class=\"orange\">" end:@"<"];
                userId = [[Jxb_Common_Common sharedInstance] getMidString:body front:@"<a href=\"/userpage/" end:@"\""];
                userPhoto = [[Jxb_Common_Common sharedInstance] getMidString:body front:@"class=\"z-Himg\"><img src=\"" end:@"\""];
                userPhone = [[Jxb_Common_Common sharedInstance] getMidString:body front:[NSString stringWithFormat:@"%@</b><em>(",userName] end:@")"];
                userLevel = [[Jxb_Common_Common sharedInstance] getMidString:body front:@"z-class-icon" end:@" g"];
                NSString* tmp = [[Jxb_Common_Common sharedInstance] getMidString:body front:@"z-class-icon" end:@"</div>"];
                userLevelName = [[Jxb_Common_Common sharedInstance] getMidString:tmp front:@"</s>" end:@"<"];
                if(!userPhone)
                    userPhone = userName;
                [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginOk object:nil];

                
            } failure:^(NSError* error){
            }];
        }
        else
        {
            [wSelf logout];
        }
    } failure:^(NSError* error){
    }];
}

@end
