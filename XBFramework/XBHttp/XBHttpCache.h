//
//  XBHttpCache.h
//  JXBFramework
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/19.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, XBHttpResponseCacheOption){
    XBHttpCacheNone        = 1 << 0,
    XBHttpCacheMemory      = 1 << 1,
    XBHttpCacheDisk        = 1 << 2,
};

typedef void(^XBHttpCacheNoParamsBlock)();
typedef void(^XBHttpCalculateSizeBlock)(NSUInteger fileCount, NSUInteger totalSize);

@interface XBHttpCache : NSObject

/**
 * The maximum "total cost" of the in-memory image cache. The cost function is the number of pixels held in memory.
 */
@property (assign, nonatomic) NSUInteger maxMemoryCost;

/**
 * The maximum length of time to keep an image in the cache, in seconds
 */
@property (assign, nonatomic) NSInteger maxCacheAge;

/**
 * The maximum size of the cache, in bytes.
 */
@property (assign, nonatomic) NSUInteger maxCacheSize;

+ (XBHttpCache*) sharedInstance;

/**
 * Cache main functions
 * response can be
 */
- (void) storeResponse: (id)response forUrl: (NSString *) url byParam:(NSDictionary *)params toDisk: (BOOL)toDisk;
- (id)   fetchResponseForUrl: (NSString *) url byParam: (NSDictionary *) params;

/**
 * Clear all memory cached images
 */
- (void)clearMemory;

/**
 * Clear all disk cached images. Non-blocking method - returns immediately.
 * @param completionBlock An block that should be executed after cache expiration completes (optional)
 */
- (void)clearDiskOnCompletion:(XBHttpCacheNoParamsBlock)completion;

/**
 * Clear all disk cached images
 * @see clearDiskOnCompletion:
 */
- (void)clearDisk;

/**
 * Remove all expired cached image from disk. Non-blocking method - returns immediately.
 * @param completionBlock An block that should be executed after cache expiration completes (optional)
 */
- (void)cleanDiskWithCompletionBlock:(XBHttpCacheNoParamsBlock)completionBlock;

/**
 * Remove all expired cached image from disk
 * @see cleanDiskWithCompletionBlock:
 */
- (void)cleanDisk;

/**
 * Get the size used by the disk cache
 */
- (NSUInteger)getSize;

/**
 * Get the number of images in the disk cache
 */
- (NSUInteger)getDiskCount;

/**
 * Asynchronously calculate the disk cache's size.
 */
- (void)calculateSizeWithCompletionBlock:(XBHttpCalculateSizeBlock)completionBlock;

@end
