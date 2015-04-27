//
//  ProductModel.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/27.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductPics : OneBaseParser
@property(nonatomic,copy)NSString* picName;
@property(nonatomic,copy)NSString* picRemark;
@end

@interface ProductInfo : OneBaseParser
@property(nonatomic,copy)NSString* goodsName;
@property(nonatomic,copy)NSString* goodsAltName;
@property(nonatomic,copy)NSNumber* codeID;
@property(nonatomic,copy)NSNumber* codePrice;
@property(nonatomic,copy)NSNumber* codeQuantity;
@property(nonatomic,copy)NSNumber* codeSales;
@property(nonatomic,copy)NSNumber* codeState;
@property(nonatomic,copy)NSNumber* codePeriod;
@property(nonatomic,copy)NSNumber* codeType;
@property(nonatomic,copy)NSNumber* seconds;
@property(nonatomic,copy)NSNumber* codeRNO;
@property(nonatomic,copy)NSString* codeRTime;
@property(nonatomic,copy)NSString* codeRBuyTime;
@property(nonatomic,copy)NSString* codeRIpAddr;
@property(nonatomic,copy)NSString* userName;
@property(nonatomic,copy)NSString* userWeb;
@property(nonatomic,copy)NSString* userPhoto;
@property(nonatomic,copy)NSNumber* codeRUserBuyCount;
@end

@interface ProductTopic : OneBaseParser
@property(nonatomic,copy)NSNumber* Topic;
@property(nonatomic,copy)NSNumber* Reply;
@end

@interface ProductDetail : OneBaseParser
@property(nonatomic,copy)NSArray* Rows1;
@property(nonatomic,strong)ProductInfo* Rows2;
@property(nonatomic,strong)ProductTopic* Rows3;
@end

@interface ProductLottery : OneBaseParser
@property(nonatomic,copy)NSNumber* codePeriod;
@property(nonatomic,copy)NSNumber* codeGoodsID;
@property(nonatomic,copy)NSString* goodsName;
@property(nonatomic,copy)NSString* codeGoodsPic;
@property(nonatomic,copy)NSNumber* codePrice;
@property(nonatomic,copy)NSNumber* codeState;
@property(nonatomic,copy)NSNumber* codeRNO;
@property(nonatomic,copy)NSString* codeRTime;
@property(nonatomic,copy)NSNumber* codeType;
@property(nonatomic,copy)NSString* codeRBuyTime;
@property(nonatomic,copy)NSString* codeRIpAddr;
@property(nonatomic,copy)NSNumber* codeRUserBuyCount;
@property(nonatomic,copy)NSString* userName;
@property(nonatomic,copy)NSString* userWeb;
@property(nonatomic,copy)NSString* userPhoto;
@property(nonatomic,copy)NSNumber* codeQuantity;
@property(nonatomic,copy)NSNumber* codeSales;
@end

@interface ProductCodeBuy : OneBaseParser
@property(nonatomic,copy)NSString* buyTime;
@property(nonatomic,copy)NSString* rnoNum;
@end

@interface ProductLotteryDetail : OneBaseParser
@property(nonatomic,copy)NSArray* Rows1;
@property(nonatomic,strong)ProductLottery* Rows2;
@property(nonatomic,strong)ProductTopic* Rows3;
@property(nonatomic,strong)NSArray* Rows4;
@end

@interface ProductModel : NSObject
+ (void)getGoodDetail:(int)goodsId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)getGoodLottery:(int)codeId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
