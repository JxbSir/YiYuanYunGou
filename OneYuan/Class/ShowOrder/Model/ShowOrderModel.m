//
//  ShowOrderModel.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/28.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "ShowOrderModel.h"

@implementation ShowOrderItem
@synthesize postID,postAllPic,postTitle,postContent,userPhoto,userName,userWeb,postTime,postHits,postReplyCount;
@end

@implementation ShowOrderList
@synthesize count,Rows;
+(Class)Rows_class
{
    return [ShowOrderItem class];
}
@end

@implementation ShowOrderPostItem
@synthesize codeID,codeGoodsID,codeGoodsPic,codeGoodsSName,codePrice,codePeriod,nowCodePeriod,userName,userPhoto,userWeb,codeRNO,codeRTime,codeType,codeRUserBuyCount,postTitle,postContent,postTime,postAllPic,postHits,postReplyCount,postPoint;
@end

@implementation ShowOrderPostDetail
@synthesize Rows;
+(Class)Rows_class
{
    return [ShowOrderPostItem class];
}
@end

@implementation ShowOrderReplyItem
@synthesize replyID,userName,userWeb,replyRefContent,replyRefUserName,replyContent,replyTime,replyCount,userPhoto;
@end

@implementation ShowOrderReplyList
@synthesize Rows;
@end

@implementation ShowOrderModel
+ (void)getGoodLottery:(int)goodsId page:(int)page size:(int)size success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = nil;
    if(goodsId)
    {
        url = [NSString stringWithFormat:oyShowGoodsList,goodsId,(page-1)*size,page*size-1];
    }
    else
    {
        url = [NSString stringWithFormat:oyShowListUrl,(page-1)*size,page*size-1];
    }
    [[XBApi SharedXBApi] requestWithURL:url paras:nil type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getPostDetail:(int)postId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [NSString stringWithFormat:oyShowGoodsDetail,postId];
    [[XBApi SharedXBApi] requestWithURL:url paras:nil type:XBHttpResponseType_Json success:success failure:failure];
}
@end
