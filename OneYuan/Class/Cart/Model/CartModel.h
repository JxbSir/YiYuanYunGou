//
//  CartModel.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/26.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    CartAddResult_Success,
    CartAddResult_Full,
    CartAddResult_Failed
}CartAddResult;

@interface CartItem : OneBaseParser
@property (nonatomic,copy)NSNumber  *cPid;
@property (nonatomic,copy)NSString  *cName;
@property (nonatomic,copy)NSNumber  *cPeriod;
@property (nonatomic,copy)NSNumber  *cPrice;
@property (nonatomic,copy)NSString  *cSrc;
@property (nonatomic,copy)NSNumber  *cBuyNum;
@property (nonatomic,copy)NSNumber  *cCid;
@end

@interface CartResult : OneBaseParser
@property (nonatomic,copy)NSNumber  *state;
@property (nonatomic,copy)NSString  *str;
@end

@interface CartResultAsnyc : OneBaseParser
@property (nonatomic,copy)NSNumber  *state;
@end

@interface CartModel : NSObject
+ (void)addorUpdateCart:(CartItem*)item;
+ (void)quertCart:(NSString*)key value:(NSObject*)value block:(void (^)(NSArray* result))block;
+ (NSArray*)quertCart2:(NSString*)key value:(NSObject*)value;
+ (void)removeCart:(CartItem*)item;
+ (void)removeAllCart;
+ (void)getCartState:(int)goodsId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;


#pragma mark - server
+ (void)getCartInServer:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)postCartInServer:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)queryCartResultInServer:(NSString*)rid success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (BOOL)delCartInServer:(int)codeId;
+ (CartAddResult)addCartInServer:(CartItem*)item;
@end
