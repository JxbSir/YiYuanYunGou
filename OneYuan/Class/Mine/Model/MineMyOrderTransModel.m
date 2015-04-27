//
//  MineMyOrderTransModel.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/28.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineMyOrderTransModel.h"

@implementation MineMyOrderTransInfo
@end

@implementation MineMyOrderTrans
@end

@implementation MineMyOrderTransModel

+ (void)getUserOrderTrans:(int)transNo success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyTransUrl,transNo];
    [[XBApi SharedXBApi] requestWithURL:url paras:nil type:XBHttpResponseType_Common success:success failure:failure];
}
@end
