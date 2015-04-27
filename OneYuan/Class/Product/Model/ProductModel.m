//
//  ProductModel.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/27.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "ProductModel.h"

@implementation ProductPics
@synthesize picName,picRemark;
@end

@implementation ProductTopic
@synthesize Topic,Reply;
@end

@implementation ProductInfo
@synthesize  goodsName,goodsAltName,codeID,codePrice,codeQuantity,codeSales,codeState,codePeriod,codeType,seconds,codeRNO,codeRTime,codeRBuyTime,codeRIpAddr,userName,userWeb,userPhoto,codeRUserBuyCount;
@end

@implementation ProductDetail
@synthesize Rows1,Rows2,Rows3;
+(Class)Rows1_class
{
    return [ProductPics class];
}
@end


@implementation ProductLottery
@synthesize codePeriod,codeGoodsID,goodsName,codeGoodsPic,codePrice,codeState,codeRNO,codeRTime,codeType,codeRBuyTime,codeRIpAddr,codeRUserBuyCount,userName,userWeb,userPhoto,codeQuantity,codeSales;
@end

@implementation ProductCodeBuy
@synthesize buyTime,rnoNum;
@end

@implementation ProductLotteryDetail
@synthesize Rows1,Rows2,Rows3,Rows4;
+(Class)Rows1_class
{
    return [ProductPics class];
}
+(Class)Rows4_class
{
    return [ProductCodeBuy class];
}
@end

@implementation ProductModel

+ (void)getGoodDetail:(int)goodsId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyGoodsDetail,goodsId];
    [[XBApi SharedXBApi] requestWithURL:url paras:nil type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getGoodLottery:(int)codeId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyGoodsLottery,codeId];
    [[XBApi SharedXBApi] requestWithURL:url paras:nil type:XBHttpResponseType_Json success:success failure:failure];
}
@end
