//
//  NewestModel.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/22.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  NewestProItme <NSObject>
@end
@interface NewestProItme : OneBaseParser
@property (nonatomic,copy)NSNumber* codeID;
@property (nonatomic,copy)NSNumber* codeGoodsID;
@property (nonatomic,copy)NSNumber* codePeriod;
@property (nonatomic,copy)NSNumber* codeRNO;
@property (nonatomic,copy)NSNumber* codePrice;
@property (nonatomic,copy)NSString* codeRTime;
@property (nonatomic,copy)NSString* codeGoodsPic;
@property (nonatomic,copy)NSString* goodsName;
@property (nonatomic,copy)NSNumber* codeRUserBuyCount;
@property (nonatomic,copy)NSString* codeRIpAddr;
@property (nonatomic,copy)NSNumber* codeType;
@property (nonatomic,copy)NSString* userName;
@property (nonatomic,copy)NSString* userPhoto;
@property (nonatomic,copy)NSString* userWeb;
@end

@interface NewestProList : OneBaseParser
@property (nonatomic,copy)NSNumber* count;
@property (nonatomic,copy)NSArray* Rows;
@end

@interface NewestModel : NSObject
+(void)getAllNewest:(int)sortId page:(int)page size:(int)size index:(int)index success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
