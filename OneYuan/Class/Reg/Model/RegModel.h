//
//  RegModel.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/3.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegSms : OneBaseParser
@property(nonatomic,copy)NSNumber* state;
@end

@interface RegResut : OneBaseParser
@property(nonatomic,copy)NSNumber* state;
@property(nonatomic,copy)NSString* str;
@end

@interface RegModel : NSObject
+ (void)regPhoneSms:(NSString*)phone success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)regPhoneCode:(NSString*)phone code:(NSString*)code success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)regPhoneSetPwd:(NSString*)str pwd:(NSString*)pwd success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)regPhoneOK:(NSString*)str success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
