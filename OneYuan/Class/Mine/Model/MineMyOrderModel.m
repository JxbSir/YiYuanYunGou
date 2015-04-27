//
//  MineMyOrderModel.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/24.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineMyOrderModel.h"

@implementation MineMyOrderItem
@synthesize codeID,goodsPic,goodsSName,codeRNO,codeRTime,codePeriod,orderNo,IsPostSingle;
@end

@implementation MineMyOrderList
@synthesize count,listItems;
+ (Class)listItems_class {
    return [MineMyOrderItem class];
}
@end

@implementation MineMyOrderModel

+ (void)getUserOrderlist:(int)page size:(int)size success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyMineOrderList,(page - 1)*size+1,page*size];
    [[XBApi SharedXBApi] requestWithURL:url paras:nil type:XBHttpResponseType_JqueryJson success:success failure:failure];
}

+ (void)doConfirmOrder:(int)orderId addressId:(int)addressId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyComfirmOrder,orderId,addressId];
    NSString* refer = [NSString stringWithFormat:oyTransUrl,orderId];
    [[XBApi SharedXBApi] requestWithURL2:url referer:refer paras:nil type:XBHttpResponseType_JqueryJson success:success failure:failure];
}

+ (void)doConfirmShip:(int)orderId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyComfirmShip,orderId];
    NSString* refer = [NSString stringWithFormat:oyTransUrl,orderId];
    [[XBApi SharedXBApi] requestWithURL2:url referer:refer paras:nil type:XBHttpResponseType_JqueryJson success:success failure:failure];
}

@end
