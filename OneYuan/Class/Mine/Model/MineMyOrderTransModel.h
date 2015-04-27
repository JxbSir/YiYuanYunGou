//
//  MineMyOrderTransModel.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/28.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineMyOrderTransInfo : OneBaseParser
@property(nonatomic,copy)NSString* msg;
@property(nonatomic,copy)NSString* time;
@end

@interface MineMyOrderTrans : OneBaseParser
@property(nonatomic,copy)NSString* tranNo;
@property(nonatomic,copy)NSString* tranCompany;
@property(nonatomic,copy)NSString* tranAddress;
@property(nonatomic,copy)NSArray*  tranInfos;
@end

@interface MineMyOrderTransModel : NSObject

+ (void)getUserOrderTrans:(int)transNo success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
