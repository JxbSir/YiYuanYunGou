//
//  ProdcutBuyModel.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/1.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "ProdcutBuyModel.h"

@implementation ProdcutBuyItem
@end

@implementation ProdcutBuyList
+(Class)Rows_class
{
    return [ProdcutBuyItem class];
}
@end

@implementation ProdcutBuyModel

+ (void)getGoodBuyList:(int)codeId page:(int)page size:(int)size success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyGoodsBuyList,codeId,(page-1)*size + 1, page*size];
    [[XBApi SharedXBApi] requestWithURL:url paras:nil type:XBHttpResponseType_Json success:success failure:failure];
}

@end
