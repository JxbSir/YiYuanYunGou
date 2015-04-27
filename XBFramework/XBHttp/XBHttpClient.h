//
//  XBHttpClient.h
//  XBHttpClient
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/1/30.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef enum
{
    XBHttpResponseType_Json,
    XBHttpResponseType_JqueryJson,
    XBHttpResponseType_XML,
    XBHttpResponseType_Common
}XBHttpResponseType;

@interface XBHttpClient : AFHTTPRequestOperationManager


- (void)requestWithURL:(NSString *)url
                 paras:(NSDictionary *)parasDict
                  type:(XBHttpResponseType)type
               success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
               failure:(void(^)(NSError *requestErr))failure ;

@end
