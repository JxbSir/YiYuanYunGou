//
//  OyTool.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/24.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OyTool : NSObject
@property(nonatomic,readonly)BOOL          bIsForReview;
@property(nonatomic,readonly)NSString      *libDownUrl;
@property(nonatomic,readonly)NSString      *libVersion;
+ (instancetype)ShardInstance;
- (void)getUmengParam;
@end
