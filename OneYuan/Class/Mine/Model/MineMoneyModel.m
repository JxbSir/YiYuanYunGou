//
//  MineMoneyModel.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/25.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineMoneyModel.h"

@implementation MineMoneyInItem
@synthesize logTime,logMoney;

@end

@implementation MineMoneyOutItem
@synthesize typeName;
@end

@implementation MineMoneyList
@synthesize count,listItems;
+ (Class)listItems_class {
    return [MineMoneyOutItem class];
}
@end

@implementation MineMoneyModel
+ (void)getMyMoneylist:(int)page size:(int)size state:(int)state success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:state == 0 ? oyMineMoneyIn : oyMineMoneyOut,(page - 1)*size+1,page*size];
    [[XBApi SharedXBApi] requestWithURL:url paras:nil type:XBHttpResponseType_JqueryJson success:success failure:failure];
}

+ (void)getMyMoneyAll:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    [[XBApi SharedXBApi] requestWithURL:oyMineMoneyUrl paras:nil type:XBHttpResponseType_Common success:success failure:failure];
}
@end
