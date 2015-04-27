//
//  Jxb_Common_Common.h
//  Jxb_Sdk
//
//  Created by Peter Jin on 14/12/5.
//  Copyright (c) 2014年 Peter Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Jxb_Common_Common : NSObject

+ (Jxb_Common_Common *)sharedInstance;

- (NSString*)urlEncode:(NSString*)str encode:(NSInteger)encode;
- (NSString*)urlDecode:(NSString*)str encode:(NSInteger)encode;

- (NSString*)getTimeSecSince1970;
- (NSString*)getTimeMillSince1970;
- (NSDate*)convertDateFromString:(NSString*)dateString;
- (NSDate*)convertDateTimeFromString:(NSString *)dateString;

- (BOOL)containString:(NSString*)body cStr:(NSString*)cStr;
- (NSString*)getMidString:(NSString*)body front:(NSString*)front end:(NSString*)end;
- (NSArray*)getSpiltString:(NSString*)body split:(NSString*)split;
- (CGRect)getMainSceen;
- (NSString*)getDeviceVersion;
- (CGFloat)getStringHeight:(NSString*)str fontSize:(CGFloat)fontSize width:(CGFloat)width;

- (void)doInChildThread:(dispatch_block_t)doBlock;
- (void)doInMainThread:(dispatch_block_t)doBlock;

- (BOOL)validatePhone:(NSString *)phonestr;
@end
