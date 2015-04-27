//
//  MineMyBuyModel.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/24.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineMyBuyModel.h"

@implementation MineMyBuyItem
@synthesize codeState,codeID,goodsName,goodsPic,buyNum,codePeriod,userName,codeSales,codeQuantity,userWeb,codeRTime;
@end

@implementation MineMyBuyList
@synthesize count,listItems;
+ (Class)listItems_class {
    return [MineMyBuyItem class];
}
@end

@implementation MineMyBuyModel

+ (void)getUserBuylist:(int)page size:(int)size state:(int)state success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyMineBuyList,(page - 1)*size+1,page*size,state];
    [[XBApi SharedXBApi] requestWithURL:url paras:nil type:XBHttpResponseType_JqueryJson success:success failure:failure];
}
@end
