//
//  MineMyOrderModel.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/24.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  MineMyOrderItem <NSObject>
@end
@interface MineMyOrderItem : OneBaseParser
@property (nonatomic,copy)NSNumber  *codeID;
@property (nonatomic,copy)NSString  *goodsPic;
@property (nonatomic,copy)NSString  *goodsSName;
@property (nonatomic,copy)NSNumber  *codeRNO;
@property (nonatomic,copy)NSString  *codeRTime;
@property (nonatomic,copy)NSNumber  *codePeriod;
@property (nonatomic,copy)NSNumber  *orderState;
@property (nonatomic,copy)NSNumber  *orderNo;
@property (nonatomic,copy)NSNumber  *IsPostSingle;
@end

@interface MineMyOrderList : OneBaseParser
@property (nonatomic,copy)NSNumber  *count;
@property (nonatomic,copy)NSArray  *listItems;
@end

@interface MineMyOrderModel : NSObject
+ (void)getUserOrderlist:(int)page size:(int)size success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)doConfirmOrder:(int)orderId addressId:(int)addressId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)doConfirmShip:(int)orderId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
