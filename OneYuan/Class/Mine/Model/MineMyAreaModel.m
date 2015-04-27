//
//  MineMyAreaModel.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/4.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineMyAreaModel.h"

@implementation MineMyAreaItem
@end

@implementation MineMyAreaList
+(Class)regions_class
{
    return [MineMyAreaItem class];
}
@end

@implementation MineMyAreaInfo
@end

@implementation MineMyAreaModel

+ (void)getArea:(int)aid success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyAreaGetUrl,aid];
    [[XBApi SharedXBApi] requestWithURL2:url referer:oyAddressRefer paras:nil type:XBHttpResponseType_JqueryJson success:success failure:failure];
}
@end
