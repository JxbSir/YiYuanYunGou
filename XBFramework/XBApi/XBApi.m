//
//  XBApi.m
//  XBHttpClient
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/1/30.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "XBApi.h"

@interface XBApi()
{
    XBHttpClient *http_common ;
    XBHttpClient *http_json ;
}

@end

@implementation XBApi

+ (instancetype)SharedXBApi
{
    static XBApi* xb = nil;
    static dispatch_once_t once ;
    dispatch_once(&once, ^{
        xb = [[XBApi alloc] init];
    });
    return xb;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        http_json = [[XBHttpClient alloc] init];
        AFJSONRequestSerializer* request_json = [[AFJSONRequestSerializer alloc] init];
        [request_json setValue:@"Android4.4" forHTTPHeaderField:@"User-Agent"];
        [http_json setRequestSerializer:request_json];
        
        http_common = [[XBHttpClient alloc] init];
        AFHTTPRequestSerializer* request_common = [[AFHTTPRequestSerializer alloc] init];
        [request_common setValue:@"Android4.4" forHTTPHeaderField:@"User-Agent"];
        [http_common setRequestSerializer:request_common];
    }
    return self;
}

- (void)requestWithURL:(NSString *)url
                 paras:(NSDictionary *)parasDict
                  type:(XBHttpResponseType)type
               success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
               failure:(void(^)(NSError *requestErr))failure
{
    if(type == XBHttpResponseType_Common)
        [http_common requestWithURL:url paras:parasDict type:type success:success failure:failure];
    else
        [http_json requestWithURL:url paras:parasDict type:type success:success failure:failure];
        
}

- (void)requestWithURL2:(NSString *)url
               referer:(NSString *)refer
                 paras:(NSDictionary *)parasDict
                  type:(XBHttpResponseType)type
               success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
               failure:(void(^)(NSError *requestErr))failure
{
    if(type == XBHttpResponseType_Common)
    {
        [http_common.requestSerializer setValue:refer forHTTPHeaderField:@"Referer"];
        [http_common requestWithURL:url paras:parasDict type:type success:success failure:failure];
    }
    else
    {
        [http_json.requestSerializer setValue:refer forHTTPHeaderField:@"Referer"];
        [http_json requestWithURL:url paras:parasDict type:type success:success failure:failure];
    }
}
@end
