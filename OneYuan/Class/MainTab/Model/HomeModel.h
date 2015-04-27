//
//  HomeModel.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/19.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol  HomeAd <NSObject>
@end
@interface HomeAd : OneBaseParser
@property (nonatomic,copy)NSNumber* type;
@property (nonatomic,copy)NSString* src;
@property (nonatomic,copy)NSString* url;
@property (nonatomic,copy)NSString* alt;
@property (nonatomic,copy)NSNumber* width;
@property (nonatomic,copy)NSNumber* height;
@end

@interface HomeAdList : OneBaseParser
@property (nonatomic,copy)NSArray* Rows;
@end

@protocol  HomeNewing <NSObject>
@end
@interface HomeNewing : OneBaseParser
@property (nonatomic,copy)NSString* goodsPic;
@property (nonatomic,copy)NSString* goodsSName;
@property (nonatomic,copy)NSString* seconds;
@property (nonatomic,copy)NSNumber* codeID;
@property (nonatomic,copy)NSString* price;
@property (nonatomic,copy)NSNumber* period;
@property (nonatomic,copy)NSNumber* codeQuantity;
@property (nonatomic,copy)NSNumber* codeSales;
@end

@interface HomeNewingList : OneBaseParser
@property (nonatomic,copy)NSNumber* errorCode;
@property (nonatomic,copy)NSNumber* maxSeconds;
@property (nonatomic,copy)NSArray*  listItems;
@end

@protocol  HomeNewed <NSObject>
@end
@interface HomeNewed : OneBaseParser
@property (nonatomic,copy)NSNumber* codeGoodsID;
@property (nonatomic,copy)NSString* codeGoodsPic;
@property (nonatomic,copy)NSString* codeGoodsSName;
@property (nonatomic,copy)NSNumber* codeID;
@property (nonatomic,copy)NSNumber* codePeriod;
@property (nonatomic,copy)NSNumber* codeState;
@property (nonatomic,copy)NSString* userName;
@property (nonatomic,copy)NSString* userWeb;
@end

@protocol  HomeHostest <NSObject>
@end
@interface HomeHostest : OneBaseParser
@property (nonatomic,copy)NSNumber* codePrice;
@property (nonatomic,copy)NSNumber* codeQuantity;
@property (nonatomic,copy)NSNumber* codeSales;
@property (nonatomic,copy)NSNumber* goodsID;
@property (nonatomic,copy)NSString* goodsPic;
@property (nonatomic,copy)NSString* goodsSName;
@end

@protocol  HomeShowOrder <NSObject>
@end
@interface HomeShowOrder : OneBaseParser
@property (nonatomic,copy)NSNumber* postID;
@property (nonatomic,copy)NSString* postImg;
@property (nonatomic,copy)NSString* postTime;
@property (nonatomic,copy)NSString* postTitle;
@end

@interface HomePageList : OneBaseParser
@property (nonatomic,copy)NSArray* Rows1;
@property (nonatomic,copy)NSArray* Rows2;
@property (nonatomic,copy)NSArray* Rows3;
@end

@protocol  HomeSearchAd <NSObject>
@end
@interface HomeSearchAd : OneBaseParser
@property (nonatomic,copy)NSNumber* type;
@property (nonatomic,copy)NSString* src;
@property (nonatomic,copy)NSString* url;
@property (nonatomic,copy)NSString* alt;
@property (nonatomic,copy)NSNumber* width;
@property (nonatomic,copy)NSNumber* height;
@end

@interface HomeSearchAdList : OneBaseParser
@property (nonatomic,copy)NSArray* Rows;
@end

@protocol  HomeOrderShowItem <NSObject>
@end
@interface HomeOrderShowItem : OneBaseParser
@property (nonatomic,copy)NSNumber* postID;
@property (nonatomic,copy)NSString* postAllPic;
@property (nonatomic,copy)NSString* postTitle;
@property (nonatomic,copy)NSString* postContent;
@property (nonatomic,copy)NSString* userPhoto;
@property (nonatomic,copy)NSString* userName;
@property (nonatomic,copy)NSString* userWeb;
@property (nonatomic,copy)NSString* postTime;
@property (nonatomic,copy)NSNumber* postHits;
@property (nonatomic,copy)NSNumber* postReplyCount;
@end

@interface HomeOrderShowList : OneBaseParser
@property (nonatomic,copy)NSNumber* count;
@property (nonatomic,copy)NSArray*  listItems;
@end

@interface HomeModel : UITableViewCell
+ (void)getAds:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)getNewing:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)getHomePage:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)getSearchAd1:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)getSearchAd2:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)getOrderShow:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
