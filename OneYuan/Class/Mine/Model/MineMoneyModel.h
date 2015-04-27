//
//  MineMoneyModel.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/25.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MineMoneyInItem <NSObject>
@end
@interface MineMoneyInItem : OneBaseParser
@property(nonatomic,copy)NSString*  logTime;
@property(nonatomic,copy)NSString*  logMoney;
@end

@protocol MineMoneyOutItem <NSObject>
@end
@interface MineMoneyOutItem : MineMoneyInItem
@property(nonatomic,copy)NSString* typeName;
@end

@interface MineMoneyList : OneBaseParser
@property(nonatomic,copy)NSNumber   *count;
@property(nonatomic,copy)NSArray    *listItems;
@end

@interface MineMoneyModel : NSObject
+ (void)getMyMoneylist:(int)page size:(int)size state:(int)state success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)getMyMoneyAll:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
