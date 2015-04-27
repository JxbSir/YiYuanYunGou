//
//  NewestModel.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/22.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "NewestModel.h"

@implementation NewestProItme
@synthesize codeID,codeGoodsID,codePeriod,codeRNO,codePrice,codeRTime,codeGoodsPic,goodsName,codeRUserBuyCount,codeRIpAddr,codeType,userName,userPhoto,userWeb;
@end

@implementation NewestProList
@synthesize count,Rows;
+ (Class)Rows_class {
    return [NewestProItme class];
}
@end

@implementation NewestModel

+(void)getAllNewest:(int)sortId page:(int)page size:(int)size index:(int)index success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyNewestedPage,sortId,page*size,index];
    [[XBApi SharedXBApi] requestWithURL:url paras:nil type:XBHttpResponseType_Json success:success failure:failure];
}

@end
