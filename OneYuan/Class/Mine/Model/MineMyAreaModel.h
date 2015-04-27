//
//  MineMyAreaModel.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/3/4.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineMyAreaItem : OneBaseParser
@property(nonatomic,copy)NSString*   name;
@property(nonatomic,copy)NSNumber*   id;
@property(nonatomic,copy)NSNumber*   zip;
@end

@interface MineMyAreaList : OneBaseParser
@property(nonatomic,copy)NSArray*   regions;
@end

@interface MineMyAreaInfo : OneBaseParser
@property(nonatomic,strong)MineMyAreaList*   str;
@end

@interface MineMyAreaModel : NSObject
+ (void)getArea:(int)aid success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
