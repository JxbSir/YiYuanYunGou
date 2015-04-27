//
//  SearchModel.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/27.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel

+ (void)searchItems:(NSString*)key success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oySearchUrl,[key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[XBApi SharedXBApi] requestWithURL:url paras:nil type:XBHttpResponseType_Json success:success failure:failure];
}
@end
