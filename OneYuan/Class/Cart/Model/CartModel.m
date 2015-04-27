//
//  CartModel.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/26.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "CartModel.h"

@implementation CartItem
@synthesize cPid,cPeriod,cPrice,cSrc,cBuyNum,cCid;
@end

@implementation CartResult
@synthesize state,str;
@end

@implementation CartResultAsnyc
@synthesize state;
@end

@implementation CartModel

+ (void)addorUpdateCart:(CartItem*)item
{
    [[XBDbHandler sharedInstance] insertOrUpdateWithModelArr:@[item] byPrimaryKey:@"cPid"];
}

+ (void)quertCart:(NSString*)key value:(NSObject*)value block:(void (^)(NSArray* result))block
{
   NSArray* arr = [[XBDbHandler sharedInstance] queryWithClass:[CartItem class] key:key value:value orderByKey:nil desc:NO];
    if(block != NULL)
        block(arr);
}

+ (NSArray*)quertCart2:(NSString*)key value:(NSObject*)value
{
    NSArray* arr = [[XBDbHandler sharedInstance] queryWithClass:[CartItem class] key:key value:value orderByKey:nil desc:NO];
    return arr;
}

+ (void)removeCart:(CartItem*)item
{
    [[XBDbHandler sharedInstance] deleteModels:@[item] withPrimaryKey:@"cPid"];
}

+ (void)removeAllCart
{
    NSArray* arr = [[XBDbHandler sharedInstance] queryWithClass:[CartItem class] key:nil value:nil orderByKey:nil desc:NO];
    for (CartItem* item in arr) {
        [[XBDbHandler sharedInstance] deleteModels:@[item] withPrimaryKey:@"cPid"];
    }
}

+ (void)getCartState:(int)goodsId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyCartStateUrl,goodsId];
    [[XBApi SharedXBApi] requestWithURL:url paras:nil type:XBHttpResponseType_Common success:success failure:failure];
}

#pragma mark - server
+ (void)getCartInServer:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    [[XBApi SharedXBApi] requestWithURL:oyCartDetail paras:nil type:XBHttpResponseType_Common success:success failure:failure];
}

+ (void)postCartInServer:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    [[XBApi SharedXBApi] requestWithURL2:oyCartPostPay referer:oyCartPayRefer paras:nil type:XBHttpResponseType_JqueryJson success:success failure:failure];
}

+ (void)queryCartResultInServer:(NSString*)rid success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyCartPayResult,rid];
    [[XBApi SharedXBApi] requestWithURL2:url referer:oyCartPayRefer paras:nil type:XBHttpResponseType_JqueryJson success:success failure:failure];
}

+ (BOOL)delCartInServer:(int)codeId
{
    NSString* url = [NSString stringWithFormat:oyCartDelUrl,codeId];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:kXBCookie] forHTTPHeaderField:@"Cookie"];
    NSURLResponse* reponse = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&reponse error:&error];
    if(error)
    {
        return false;
    }
    NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"delCartInServer:%@",result);
    return [[Jxb_Common_Common sharedInstance] containString:result cStr:@"code':0"];
}

+ (CartAddResult)addCartInServer:(CartItem*)item
{
    NSString* url = [NSString stringWithFormat:oyCartAddUrl,[item.cBuyNum intValue],[item.cCid intValue]];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:kXBCookie] forHTTPHeaderField:@"Cookie"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    NSURLResponse* reponse = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&reponse error:&error];
    if(error)
    {
        return false;
    }
    NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if([[Jxb_Common_Common sharedInstance] containString:result cStr:@"code':0"])
        return CartAddResult_Success;
    if([[Jxb_Common_Common sharedInstance] containString:result cStr:@"code':2"])
        return CartAddResult_Full;
    return CartAddResult_Failed;
}

@end
