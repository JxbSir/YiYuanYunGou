//
//  MineMyAddressModel.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/26.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineMyAddressItem : OneBaseParser
@property(nonatomic,copy)NSNumber   *ID;
@property(nonatomic,copy)NSNumber   *UserID;
@property(nonatomic,copy)NSString   *Name;
@property(nonatomic,copy)NSString   *Address;
@property(nonatomic,copy)NSString   *Zip;
@property(nonatomic,copy)NSString   *Mobile;
@property(nonatomic,copy)NSNumber   *Default;
@property(nonatomic,copy)NSNumber   *AID;
@property(nonatomic,copy)NSNumber   *BID;
@property(nonatomic,copy)NSNumber   *CID;
@property(nonatomic,copy)NSNumber   *DID;
@property(nonatomic,copy)NSString   *AName;
@property(nonatomic,copy)NSString   *BName;
@property(nonatomic,copy)NSString   *CName;
@property(nonatomic,copy)NSString   *DName;
@end

@interface MineMyAddressItemList : OneBaseParser
@property(nonatomic,copy)NSArray* list;
@end

@interface MineMyAddressModel : NSObject

+ (void)getMyAddress:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)delMyAddress:(int)addressId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)addMyAddress:(NSDictionary*)paras success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)setDefault:(int)addressId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
