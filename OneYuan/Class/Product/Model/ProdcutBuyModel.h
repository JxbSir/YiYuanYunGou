//
//  ProdcutBuyModel.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/1.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProdcutBuyItem : OneBaseParser
@property(nonatomic,copy)NSString* userName;
@property(nonatomic,copy)NSString* userPhoto;
@property(nonatomic,copy)NSString* userWeb;
@property(nonatomic,copy)NSString* buyNum;
@property(nonatomic,copy)NSString* buyIP;
@property(nonatomic,copy)NSString* buyIPAddr;
@property(nonatomic,copy)NSString* buyTime;
@property(nonatomic,copy)NSString* buyDevice;
@property(nonatomic,copy)NSString* buyID;
@end

@interface ProdcutBuyList : OneBaseParser
@property(nonatomic,copy)NSNumber* Count;
@property(nonatomic,copy)NSArray*  Rows;
@end

@interface ProdcutBuyModel : NSObject
+ (void)getGoodBuyList:(int)codeId page:(int)page size:(int)size success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
