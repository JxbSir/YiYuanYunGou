//
//  AllProModel.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/21.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllProPeriod : OneBaseParser
@property (nonatomic,copy)NSNumber* goodsID;
@property (nonatomic,copy)NSNumber* codeID;
@property (nonatomic,copy)NSNumber* codeState;
@property (nonatomic,copy)NSNumber* codePeriod;
@end

@interface AllProPeriodList : OneBaseParser
@property (nonatomic,copy)NSArray* Rows;
@end

@interface AllProItme : OneBaseParser
@property (nonatomic,copy)NSNumber* goodsID;
@property (nonatomic,copy)NSString* goodsSName;
@property (nonatomic,copy)NSString* goodsPic;
@property (nonatomic,copy)NSNumber* codeID;
@property (nonatomic,copy)NSNumber* codePrice;
@property (nonatomic,copy)NSNumber* codeQuantity;
@property (nonatomic,copy)NSNumber* codeSales;
@property (nonatomic,copy)NSNumber* codePeriod;
@property (nonatomic,copy)NSNumber* codeType;
@property (nonatomic,copy)NSNumber* goodsTag;
@end

@interface AllProList : OneBaseParser
@property (nonatomic,copy)NSNumber* count;
@property (nonatomic,copy)NSArray* Rows;
@end

@interface AllProModel : NSObject
+(void)getAllProduct:(int)sortId sort:(int)sort page:(int)page size:(int)size success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+(void)getGoodsPeriodByCodeId:(int)codeId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
