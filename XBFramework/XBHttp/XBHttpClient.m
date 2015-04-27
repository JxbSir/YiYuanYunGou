//
//  XBHttpClient.m
//  XBHttpClient
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/1/30.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "XBHttpClient.h"
#import "XBHttpCache.h"
#import "XBGlobal.h"
#import "TouchJSON/NSDictionary_JSONExtensions.h"

@interface XBHttpClient()
{
}
@end

@implementation XBHttpClient

#pragma mark - request
- (void)requestWithURL:(NSString *)url
                 paras:(NSDictionary *)parasDict
                  type:(XBHttpResponseType)type
               success:(void(^)(AFHTTPRequestOperation* operation, NSObject *resultObject))success
               failure:(void(^)(NSError *requestErr))failure
{
    
    // 加入允许读缓存则
    if ([[parasDict objectForKey:kHttpAllowFetchCache] boolValue]) {
        // check cache
        id cacheObj = [[XBHttpCache sharedInstance]fetchResponseForUrl:url byParam:parasDict];
        if (cacheObj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(nil,cacheObj);
            });
            return;
        }
    }
    int allowSaveCache = [[parasDict objectForKey:kHttpAllowSaveCache] intValue];

    // 检查是否是xml解析
    // 已指定何种格式解析，无需重复相同实例化，否则http多线程会引起内存问题
    if (type == XBHttpResponseType_XML) {
        if (![self.responseSerializer isMemberOfClass:[AFXMLParserResponseSerializer class]])
        {
            AFXMLParserResponseSerializer *xmlParserSerializer = [[AFXMLParserResponseSerializer alloc] init];
            self.responseSerializer = xmlParserSerializer;
        }
    }
    else if (type == XBHttpResponseType_Json) {
        if(![self.responseSerializer isMemberOfClass:[AFJSONResponseSerializer class]])
        {
            AFJSONResponseSerializer *jsonParserSerializer = [[AFJSONResponseSerializer alloc] init];
            self.responseSerializer = jsonParserSerializer;
        }
    }
    else {
        if (![self.responseSerializer isMemberOfClass:[AFHTTPResponseSerializer class]])
        {
            AFHTTPResponseSerializer *httpParserSerializer = [[AFHTTPResponseSerializer alloc] init];
            self.responseSerializer = httpParserSerializer;
        }
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kXBCookie])
    {
        [self.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:kXBCookie] forHTTPHeaderField:@"Cookie"];
    }
    
    NSMutableDictionary *transferParas = [NSMutableDictionary dictionaryWithDictionary:parasDict];
    // 检查BaseURL
    NSString *requestURL = url;
    NSDictionary *baseParas = nil;
    // 添加共同的请求参数
    if (baseParas && baseParas.allKeys.count > 0) {
        [transferParas setValuesForKeysWithDictionary:baseParas];
    }
    
    // 开始请求
    __weak typeof(self) wSelf = self;
    [self POST:requestURL parameters:transferParas success:^(AFHTTPRequestOperation *operation, id responseObject){
            if (!wSelf) {
                return ;
            }
            
            if(type == XBHttpResponseType_Common)
            {
                responseObject = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            }
            else if (type == XBHttpResponseType_JqueryJson)
            {
                NSError* error = nil;
                NSString* result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSString* r = nil;
                NSRange r1 = [result rangeOfString:@"("];
                if (r1.location == 0)
                {
                    r = [result substringFromIndex:1];
                    r = [[r substringToIndex:r.length - 1] stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
                }
                else if(r1.length > 0)
                {
                    r = [result substringFromIndex:r1.location+1];
                    NSRange r2 = [r rangeOfString:@")"];
                    r = [[r substringToIndex:r2.location] stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
                }
                else
                {
                    r = [result stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
                }
                responseObject = [NSDictionary dictionaryWithJSONString:r error:&error];
            }
            
    #ifdef DEBUG
            NSLog(@"url:%@\r\nbody:%@", url, responseObject);
    #endif
            if (allowSaveCache == XBHttpCacheMemory || allowSaveCache == XBHttpCacheDisk) {
                [[XBHttpCache sharedInstance] storeResponse:responseObject forUrl:requestURL byParam:transferParas toDisk:allowSaveCache == XBHttpCacheMemory? NO:YES];
            }
            success(operation, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error);
        }];
}


@end
