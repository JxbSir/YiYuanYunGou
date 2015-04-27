//
//  Jxb_Common_Common.m
//  Jxb_Sdk
//
//  Created by Peter Jin on 14/12/5.
//  Copyright (c) 2014年 Peter Jin. All rights reserved.
//

#import <UIKit/UIView.h>
#import <UIKit/UIScreen.h>
#import "Jxb_Common_Common.h"

#define phonePrefix   @"1[3|4|5|7|8|][0-9]{9}"

@implementation Jxb_Common_Common

+ (instancetype)sharedInstance
{
    static Jxb_Common_Common *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[Jxb_Common_Common alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark - Common
- (NSString*)urlEncode:(NSString*)str encode:(NSInteger)encode
{
    NSString* escapedUrlString= (NSString*) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)str, NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return escapedUrlString;
}

- (NSString*)urlDecode:(NSString*)str encode:(NSInteger)encode
{
    return [str stringByReplacingPercentEscapesUsingEncoding:encode];
}

- (NSString*)getTimeSecSince1970
{
    NSDate* date = [NSDate date];
    double tick = [date timeIntervalSince1970];
    NSString* _t = [NSString stringWithFormat:@"%.0f",tick];
    return _t;
}

- (NSString*)getTimeMillSince1970
{
    NSDate* date = [NSDate date];
    double tick = [date timeIntervalSince1970] * 1000;
    NSString* _t = [NSString stringWithFormat:@"%.0f",tick];
    return _t;
}

- (NSDate*)convertDateFromString:(NSString*)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}

- (NSDate *)convertDateTimeFromString:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}

- (CGRect)getMainSceen
{
    return [UIScreen mainScreen].applicationFrame;
}

- (NSString*)getDeviceVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

#pragma mark - string
- (BOOL)containString:(NSString*)body cStr:(NSString*)cStr
{
    return [body rangeOfString:cStr].length > 0;
}

- (NSString*)getMidString:(NSString*)body front:(NSString*)front end:(NSString*)end
{
    if(![self containString:body cStr:front])
        return nil;
    if(![self containString:body cStr:end])
        return nil;
    int fIndex = (int)[body rangeOfString:front].location;
    NSString* tmp = [body substringFromIndex:fIndex + front.length];
    int eIndex = (int)[tmp rangeOfString:end].location;
    tmp = [tmp substringToIndex:eIndex];
    return tmp;
}

- (NSArray*)getSpiltString:(NSString*)body split:(NSString*)split
{
    return [body componentsSeparatedByString:split];
}

- (CGFloat)getStringHeight:(NSString*)str fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize =  [str boundingRectWithSize:CGSizeMake(width, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return labelSize.height;
}
#pragma mark - Thread
- (void)doInChildThread:(dispatch_block_t)doBlock {
    dispatch_async(dispatch_get_global_queue(0, 0), doBlock);
}

- (void)doInMainThread:(dispatch_block_t)doBlock {
    dispatch_async(dispatch_get_main_queue(), doBlock);
}

- (BOOL)validatePhone:(NSString *)phonestr {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phonePrefix];
    BOOL isphoneValidate = [predicate evaluateWithObject:phonestr];
    return isphoneValidate;
}

@end
