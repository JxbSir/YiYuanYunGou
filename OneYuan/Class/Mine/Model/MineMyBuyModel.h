//
//  MineMyBuyModel.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/24.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  MineMyBuyItem <NSObject>
@end
@interface MineMyBuyItem : OneBaseParser
@property (nonatomic,copy)NSNumber  *codeState;
@property (nonatomic,copy)NSNumber  *codeID;
@property (nonatomic,copy)NSString  *goodsName;
@property (nonatomic,copy)NSString  *goodsPic;
@property (nonatomic,copy)NSNumber  *buyNum;
@property (nonatomic,copy)NSNumber  *codePeriod;
@property (nonatomic,copy)NSString  *userName;
@property (nonatomic,copy)NSNumber  *codeSales;
@property (nonatomic,copy)NSNumber  *codeQuantity;
@property (nonatomic,copy)NSString  *userWeb;
@property (nonatomic,copy)NSString  *codeRTime;
@end

@interface MineMyBuyList : OneBaseParser
@property (nonatomic,copy)NSNumber  *count;
@property (nonatomic,copy)NSArray  *listItems;
@end

@interface MineMyBuyModel : NSObject

+ (void)getUserBuylist:(int)page size:(int)size state:(int)state success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
