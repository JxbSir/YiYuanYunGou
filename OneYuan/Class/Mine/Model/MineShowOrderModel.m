//
//  MineShowOrderModel.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/25.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "MineShowOrderModel.h"

@implementation MineShowOrderItem
@synthesize postID,postState,postPic,postTitle,postContent,postTime,postFailReason,postPoint;
@end

@implementation MineShowOrderList
@synthesize postCount,unPostCount,listItems;
+ (Class)listItems_class {
    return [MineShowOrderItem class];
}
@end

@implementation MineShowOrderModel

+ (void)getShowOrderlist:(int)page size:(int)size success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyMineShowOrderList,(page - 1)*size+1,page*size];
    [[XBApi SharedXBApi] requestWithURL:url paras:nil type:XBHttpResponseType_JqueryJson success:success failure:failure];
}
@end