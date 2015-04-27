//
//  XBApi.h
//  XBHttpClient
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/1/30.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBHttpClient.h"


@interface XBApi : NSObject

+ (instancetype)SharedXBApi;

- (void)requestWithURL:(NSString *)url
                 paras:(NSDictionary *)parasDict
                  type:(XBHttpResponseType)type
               success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
               failure:(void(^)(NSError *requestErr))failure ;
- (void)requestWithURL2:(NSString *)url
                referer:(NSString *)refer
                  paras:(NSDictionary *)parasDict
                   type:(XBHttpResponseType)type
                success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
                failure:(void(^)(NSError *requestErr))failure;
@end
