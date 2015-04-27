//
//  LoginModel.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/18.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginParser : OneBaseParser
@property (nonatomic,copy)NSNumber* state;
@end

@interface LoginOkParser : OneBaseParser
@end

@interface LoginModel : NSObject

+ (void)doLogin:(NSString*)name pwd:(NSString*)pwd success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)doLoginOK:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
