//
//  MineShowOrderModel.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/25.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  MineShowOrderItem <NSObject>
@end
@interface MineShowOrderItem : OneBaseParser
@property (nonatomic,copy)NSString  *postID;
@property (nonatomic,copy)NSNumber  *postState;
@property (nonatomic,copy)NSString  *postPic;
@property (nonatomic,copy)NSString  *postTitle;
@property (nonatomic,copy)NSString  *postContent;
@property (nonatomic,copy)NSString  *postTime;
@property (nonatomic,copy)NSString  *postFailReason;
@property (nonatomic,copy)NSString  *postPoint;
@end

@interface MineShowOrderList : OneBaseParser
@property (nonatomic,copy)NSNumber  *postCount;
@property (nonatomic,copy)NSNumber  *unPostCount;
@property (nonatomic,copy)NSArray   *listItems;
@end

@interface MineShowOrderModel : NSObject
+ (void)getShowOrderlist:(int)page size:(int)size success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
