//
//  HomeModel.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/19.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "HomeModel.h"

@implementation HomeAd
@synthesize type,src,url,alt,width,height;
@end

@implementation HomeAdList
@synthesize Rows;

+ (Class)Rows_class {
    return [HomeAd class];
}
@end

@implementation HomeNewing
@synthesize goodsPic,goodsSName,seconds,codeID,price,period,codeQuantity,codeSales;
@end

@implementation HomeNewingList
@synthesize errorCode,maxSeconds,listItems;
+ (Class)listItems_class {
    return [HomeNewing class];
}
@end


@implementation HomeNewed
@synthesize codeGoodsID,codeGoodsPic,codeGoodsSName,codeID,codePeriod,codeState,userName,userWeb;
@end

@implementation HomeHostest
@synthesize codePrice,codeQuantity,codeSales,goodsID,goodsPic,goodsSName;
@end

@implementation HomeShowOrder
@synthesize postID,postImg,postTime,postTitle;
@end

@implementation HomePageList
@synthesize Rows1,Rows2,Rows3;
+ (Class)Rows1_class {
    return [HomeNewed class];
}
+ (Class)Rows2_class {
    return [HomeHostest class];
}
+ (Class)Rows3_class {
    return [HomeShowOrder class];
}
@end

@implementation HomeSearchAd
@synthesize type,src,url,alt,width,height;
@end

@implementation HomeSearchAdList
@synthesize Rows;

+ (Class)Rows_class {
    return [HomeSearchAd class];
}
@end

@implementation HomeOrderShowItem
@synthesize postID,postAllPic,postTitle,postContent,userPhoto,userName,userWeb,postTime,postHits,postReplyCount;
@end

@implementation HomeOrderShowList
@synthesize count,listItems;

+ (Class)listItems_class {
    return [HomeOrderShowItem class];
}

@end

@implementation HomeModel

+ (void)getAds:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    [[XBApi SharedXBApi] requestWithURL:oyAdTop paras:nil type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getNewing:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    [[XBApi SharedXBApi] requestWithURL:oyNewest paras:nil type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getHomePage:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    [[XBApi SharedXBApi] requestWithURL:oyHomePage paras:nil type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getSearchAd1:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    [[XBApi SharedXBApi] requestWithURL:oyAdSearch1 paras:nil type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getSearchAd2:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    [[XBApi SharedXBApi] requestWithURL:oyAdSearch2 paras:nil type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getOrderShow:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    [[XBApi SharedXBApi] requestWithURL:oyOrderShow paras:nil type:XBHttpResponseType_JqueryJson success:success failure:failure];
}

@end
