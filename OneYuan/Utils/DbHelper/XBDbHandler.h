//
//  XBDbHandler.h
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/26.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "XBDbVersionTable.h"
#import "XBDbMigration.h"

@interface XBDbHandler : NSObject

/**
 *  拿取DB操作单例
 *
 *  @return DB操作实例-单例对象
 */
+ (XBDbHandler*)sharedInstance;

/**
 *  返回Entity记录最大的索引值，便于做映射关系
 *
 *  @return Entity记录最大的索引值
 */
//- (NSString *)getModelMaxIndex:(OTBaseParser *)model;

/**
 *  新插入或者更新数据
 *
 *  @return 操作成功还是失败
 */
- (BOOL)insertOrUpdateWithModelArr:(NSArray *)modelArr byPrimaryKey:(NSString *)pKey;

/**
 *  删除符合条件的数据
 *
 *  @param ids 查询的条件
 *  @param sql sql查询语句  两个参数传一个即可
 *
 *  @return 删除记录的结果
 */
- (BOOL)deleteWithIds:(NSArray *)ids sql:(NSString *)sql;

/**
 *  查询符合条件的数据
 *
 *  @param ids 查询的条件
 *  @param sql sql查询语句  两个参数传一个即可
 *
 *  @return 查询到得的数据记录
 */
- (NSArray *)queryWithIds:(NSArray *)ids sql:(NSString *)sql;

/**
 *  查询符合条件的数据
 *
 *  @param modelClass 查询的类 (必须是NSObject的子类)
 *  @param key        查询类中的字段名
 *  @param value      查询类中的字段名的取值
 *  @param oKey       查询结果排序依据字段
 *  @param desc       查询结果是否按照降序排列
 *
 *  @return 查询到得的数据记录
 */
- (NSArray *) queryWithClass: (Class)modelClass key: (NSString *) key value :(NSObject *) value orderByKey:(NSString *)oKey desc:(BOOL)desc;

/**
 *  删除符合条件的数据
 *
 *  @param arrOfmodel 删除model的数组
 *  @param key        删除model类的主键
 *
 *  @return 删除结果
 */
- (BOOL) deleteModels: (NSArray *)arrOfmodel withPrimaryKey: (NSString *)key;

/**
 *  删除该类型所有数据
 *
 *  @param modelClass 删除的目标类型
 *
 *  @return 删除结果
 */
- (BOOL) dropModels: (Class)modelClass;
@end
