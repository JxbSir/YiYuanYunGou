//
//  ShowOrderModel.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/28.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowOrderItem : OneBaseParser
@property(nonatomic,copy)NSNumber   *postID;
@property(nonatomic,copy)NSString   *postAllPic;
@property(nonatomic,copy)NSString   *postTitle;
@property(nonatomic,copy)NSString   *postContent;
@property(nonatomic,copy)NSString   *userPhoto;
@property(nonatomic,copy)NSString   *userName;
@property(nonatomic,copy)NSString   *userWeb;
@property(nonatomic,copy)NSString   *postTime;
@property(nonatomic,copy)NSNumber   *postHits;
@property(nonatomic,copy)NSNumber   *postReplyCount;
@end

@interface ShowOrderList : OneBaseParser
@property(nonatomic,copy)NSNumber   *count;
@property(nonatomic,copy)NSArray    *Rows;
@end

@interface ShowOrderPostItem : OneBaseParser
@property(nonatomic,copy)NSNumber   *codeID;
@property(nonatomic,copy)NSNumber   *codeGoodsID;
@property(nonatomic,copy)NSString   *codeGoodsPic;
@property(nonatomic,copy)NSString   *codeGoodsSName;
@property(nonatomic,copy)NSNumber   *codePrice;
@property(nonatomic,copy)NSNumber   *codePeriod;
@property(nonatomic,copy)NSNumber   *nowCodePeriod;
@property(nonatomic,copy)NSString   *userName;
@property(nonatomic,copy)NSString   *userPhoto;
@property(nonatomic,copy)NSString   *userWeb;
@property(nonatomic,copy)NSNumber   *codeRNO;
@property(nonatomic,copy)NSString   *codeRTime;
@property(nonatomic,copy)NSNumber   *codeType;
@property(nonatomic,copy)NSNumber   *codeRUserBuyCount;
@property(nonatomic,copy)NSString   *postTitle;
@property(nonatomic,copy)NSString   *postContent;
@property(nonatomic,copy)NSString   *postTime;
@property(nonatomic,copy)NSString   *postAllPic;
@property(nonatomic,copy)NSNumber   *postHits;
@property(nonatomic,copy)NSNumber   *postReplyCount;
@property(nonatomic,copy)NSNumber   *postPoint;
@end

@interface ShowOrderPostDetail : OneBaseParser
@property(nonatomic,strong)ShowOrderPostItem    *Rows;
@end

@interface ShowOrderReplyItem : OneBaseParser
@property(nonatomic,copy)NSNumber   *replyID;
@property(nonatomic,copy)NSString   *userName;
@property(nonatomic,copy)NSString   *userWeb;
@property(nonatomic,copy)NSString   *replyRefUserName;
@property(nonatomic,copy)NSString   *replyRefContent;
@property(nonatomic,copy)NSString   *replyContent;
@property(nonatomic,copy)NSString   *replyTime;
@property(nonatomic,copy)NSNumber   *replyCount;
@property(nonatomic,copy)NSString   *userPhoto;
@end

@interface ShowOrderReplyList : OneBaseParser
@property(nonatomic,copy)NSArray    *Rows;
@end

@interface ShowOrderModel : NSObject
+ (void)getGoodLottery:(int)goodsId page:(int)page size:(int)size success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getPostDetail:(int)postId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
