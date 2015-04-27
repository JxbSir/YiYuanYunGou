//
//  RegModel.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/3.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "RegModel.h"

@implementation RegSms
@synthesize state;
@end

@implementation RegResut
@synthesize state,str;
@end

@implementation RegModel

+ (void)regPhoneSms:(NSString*)phone success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyRegPhoneSms,phone];
    [[XBApi SharedXBApi] requestWithURL:url paras:nil type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)regPhoneCode:(NSString*)phone code:(NSString*)code success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyRegPhoneCode,phone,code];
    NSString* refer = [NSString stringWithFormat:oyRegRefer,phone];
    [[XBApi SharedXBApi] requestWithURL2:url referer:refer paras:nil type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)regPhoneSetPwd:(NSString*)str pwd:(NSString*)pwd success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyRegSetPwd,str,pwd];
    NSString* refer = [NSString stringWithFormat:oyRegSetPwdRefer,str];
    [[XBApi SharedXBApi] requestWithURL2:url referer:refer paras:nil type:XBHttpResponseType_JqueryJson success:success failure:failure];
}

+ (void)regPhoneOK:(NSString*)str success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* refer = [NSString stringWithFormat:oyRegSetPwdRefer,str];
    [[XBApi SharedXBApi] requestWithURL2:oyRegOkUrl referer:refer paras:nil type:XBHttpResponseType_JqueryJson success:success failure:failure];
}

@end
