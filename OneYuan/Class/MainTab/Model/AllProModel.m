//
//  AllProModel.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/21.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "AllProModel.h"

@implementation AllProPeriod
@synthesize goodsID,codeID,codeState,codePeriod;
@end

@implementation AllProPeriodList
@synthesize Rows;
+ (Class)Rows_class {
    return [AllProPeriod class];
}
@end

@implementation AllProItme
@synthesize goodsID,goodsSName,goodsPic,codeID,codePrice,codeQuantity,codeSales,codePeriod,codeType,goodsTag;
@end

@implementation AllProList
@synthesize count,Rows;
+ (Class)Rows_class {
    return [AllProItme class];
}
@end

@implementation AllProModel

+(void)getAllProduct:(int)sortId sort:(int)sort page:(int)page size:(int)size success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyGoodsUrl,sortId,(page-1)*size,page*size - 1,sort];
    [[XBApi SharedXBApi] requestWithURL:url paras:nil type:XBHttpResponseType_Json success:success failure:failure];
}

+(void)getGoodsPeriodByCodeId:(int)codeId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyGoodsByCodeId,codeId];
    [[XBApi SharedXBApi] requestWithURL:url paras:nil type:XBHttpResponseType_Json success:success failure:failure];
}

@end
