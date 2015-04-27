//
//  MineMyAddressModel.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/26.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineMyAddressModel.h"

@implementation MineMyAddressItem
@end

@implementation MineMyAddressItemList
+ (Class)list_class
{
    return [MineMyAddressItem class];
}
@end

@implementation MineMyAddressModel

+ (void)getMyAddress:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    [[XBApi SharedXBApi] requestWithURL2:oyAddressUrl referer:oyAddressRefer paras:nil type:XBHttpResponseType_Common success:success failure:failure];
}

+ (void)delMyAddress:(int)addressId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyAddressDel,addressId];
    [[XBApi SharedXBApi] requestWithURL2:url referer:oyAddressRefer paras:nil type:XBHttpResponseType_JqueryJson success:success failure:failure];
}

+ (void)addMyAddress:(NSDictionary*)paras success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    [[XBApi SharedXBApi] requestWithURL2:oyAddreasAddUrl referer:oyAddressRefer paras:paras type:XBHttpResponseType_Common success:success failure:failure];
}

+ (void)setDefault:(int)addressId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyAreaDefaultUrl,addressId];
    [[XBApi SharedXBApi] requestWithURL2:url referer:oyAddressRefer paras:nil type:XBHttpResponseType_JqueryJson success:success failure:failure];
}

@end
