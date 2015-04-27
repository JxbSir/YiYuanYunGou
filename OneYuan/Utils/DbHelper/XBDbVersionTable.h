//
//  XBDbVersionTable.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/26.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XBDbVersionTable : NSObject
@property(nonatomic,copy)NSString* tablename;
@property(nonatomic,copy)NSNumber* version;
@end
