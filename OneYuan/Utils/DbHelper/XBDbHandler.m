//
//  XBDbHandler.m
//  OneYuan
//
//  Created by Peter Jin (https://github.com/JxbSir) on  15/2/26.
//  Copyright (c) 2015年 PeterJin.   Email:i@jxb.name      All rights reserved.
//

#import "XBDbHandler.h"
#import <objc/runtime.h>

#define db_name @"db.sqlite"

@implementation NSMutableDictionary (SetOperation)

- (NSMutableDictionary *) addDic : (NSDictionary *) addDictionary
{
    if (addDictionary == nil || [addDictionary count] ==0) {
        return self;
    }
    
    [addDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        __block BOOL foundmatch = NO;
        [self enumerateKeysAndObjectsUsingBlock:^(id tmpKey, id tmpObj, BOOL *stop) {
            if ( [(NSString *)tmpObj isEqualToString:key]) {
                foundmatch = YES;
                *stop = YES;
                [self setObject:obj forKey:tmpKey];
            }
        }];
        
        if (!foundmatch)
            [self setObject:obj forKey:key];
    }];
    
    return self;
}

- (NSMutableDictionary *) minusDic : (NSDictionary *) minusDictionary
{
    if (minusDictionary == nil || [minusDictionary count] ==0) {
        return self;
    }
    
    [minusDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self removeObjectForKey:key];
    }];
    
    return self;
}

- (NSMutableDictionary *) addByKeyArray : (NSArray *) keyArray
{
    if (keyArray == nil || [keyArray count] ==0) {
        return self;
    }
    
    [keyArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [self setObject:@"" forKey:obj];
        }
    }];
    
    return self;
}

- (NSMutableDictionary *) minusByKeyArray : (NSMutableArray *) keyArray modifyInput: (BOOL) mInput
{
    if (keyArray == nil || [keyArray count] ==0) {
        return self;
    }
    
    for (int i=0; i< [keyArray count]; i++) {
        id obj = [keyArray objectAtIndex:i];
        if ([obj isKindOfClass:[NSString class]]) {
            if ([self objectForKey:obj] != nil) {
                [self removeObjectForKey:obj];
                if (mInput) {
                    [keyArray removeObjectAtIndex:i];
                    i--;
                }
            }
        }
    }
    
    return self;
}

- (NSMutableDictionary *) mergeWithUpdateDic: (NSMutableDictionary *)updateDic
{
    if (updateDic == nil || [updateDic count] ==0) {
        return self;
    }
    
    [updateDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([self objectForKey:key] != nil) {
            [self removeObjectForKey:key];
            [self setObject:@"" forKey:obj];
            [updateDic removeObjectForKey:key];
        }
    }];
    
    return self;
}

- (NSMutableDictionary *) minusByKeyArrayUseValue: (NSMutableArray *) keyArray modifyInput:(BOOL)mInput
{
    for (int i=0; i<[keyArray count]; i++) {
        id arraykey = [keyArray objectAtIndex:i];
        [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([(NSString *)obj isEqualToString:arraykey]) {
                [self removeObjectForKey:key];
                [keyArray replaceObjectAtIndex:i withObject:key];
            }
        }];
    }
    
    return self;
}

@end


typedef NS_ENUM(NSInteger, TZSDbTableCmpResult) {
    TZSDbTableNotExist       = 1,
    TZSDbTableChanged        = 2,
    TZSDbTableTheSame        = 3,
    TZSDbTableMigratable     = 4,
};

@interface XBDbHandler () {
    FMDatabaseQueue *xbDbQueue;
}
@end

static XBDbHandler *dbHandler = nil;
@implementation XBDbHandler

#pragma mark -dbFilePath
+ (NSString *)dbFilePath {
    NSArray *documentArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPath = [[documentArr objectAtIndex:0] stringByAppendingPathComponent:db_name];
    return dbPath;
}

#pragma mark -sharedInstance
+ (XBDbHandler *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbHandler = [[XBDbHandler alloc] init];
    });
    return dbHandler;
}

+(BOOL) canPropertyBeStored: (NSString *) attrOfProperty
{
    if ([attrOfProperty rangeOfString:@"Array"].location == NSNotFound) {
        
        if ([attrOfProperty rangeOfString:@"NSNumber"].location != NSNotFound) {
            return YES;
        }
        else if ([attrOfProperty rangeOfString:@"NSString"].location != NSNotFound) {
            return YES;
        }
    }
    
    return NO;
}

+ (NSString *)createTableSQLWithModel:(NSObject *)model inDb:(FMDatabase *)db{
    //NSString *modelName = NSStringFromClass(model.class);
    unsigned int propertyCount;
    objc_property_t *properties = class_copyAllPropertyList(model.class, &propertyCount);
    NSMutableArray *propertyArr = [NSMutableArray arrayWithCapacity:propertyCount];
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        
        // 属性
        const char *propertyName = property_getName(property);
        NSString *propertyStr = [NSString stringWithUTF8String:propertyName];
        
        // 拆解分析属性
        const char *attributeOfProperty = property_getAttributes(property);
        NSString *strOfAttribute = [NSString stringWithUTF8String:attributeOfProperty];
        
        if ([self canPropertyBeStored:strOfAttribute]) {
            if ([strOfAttribute rangeOfString:@"NSNumber"].location != NSNotFound) {
                [propertyArr addObject:[NSString stringWithFormat:@"%@ double",propertyStr]];
            }
            else if ([strOfAttribute rangeOfString:@"NSString"].location != NSNotFound) {
                [propertyArr addObject:[NSString stringWithFormat:@"%@ text",propertyStr]];
            }
        }
        // TODOTODOTODO extend the relationship layer
        /*
         NSString *createRelationSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@ text,%@ text,%@ text,%@ text)",@"RELATIONTABLE",@"PARIENTTABLENAME",@"PARIENTID",@"SONTABLENAME",@"SONID"];
         if ([strOfAttribute rangeOfString:@"&,N"].location != NSNotFound) {
         [db executeUpdate:createRelationSQL];
         } else {
         
         }
         */
    }
    
    NSString *createTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)",NSStringFromClass(model.class),[propertyArr componentsJoinedByString:@","]];
    free(properties);
    return createTableSQL;
}

#pragma mark -init
- (instancetype)init {
    if (self = [super init]) {
        xbDbQueue = [FMDatabaseQueue databaseQueueWithPath:[XBDbHandler dbFilePath]];
        [self createTableVersionDb];
    }
    return self;
}

/*
 #pragma mark -getModelMaxIndex
 - (NSString *)getModelMaxIndex:(OTBaseParser *)model {
 __block NSString *maxIndex = @"0";
 [xbDbQueue inDatabase:^(FMDatabase *db) {
 @try {
 if (![db open]) {
 NSLog(@"DBError:open failed");
 return ;
 }
 NSString *querySQL = [NSString stringWithFormat:@"SELECT MAX(index) Index From %@",NSStringFromClass(model.class)];
 FMResultSet *maxSet = [db executeQuery:querySQL];
 if (maxSet.next) {
 maxIndex = [maxSet stringForColumn:@"Index"];
 }
 }
 @catch (NSException *exception) {
 NSLog(@"DBError:%@",exception.userInfo.description);
 }
 @finally {
 [db close];
 }
 }];
 return maxIndex;
 }
 */

#pragma mark -insertOrUpdateWithModelArr
- (BOOL)insertOrUpdateWithModelArr:(NSArray *)modelArr byPrimaryKey:(NSString *)pKey{
    if (modelArr.count > 0) {
        // 检测建表逻辑
        NSObject *model = modelArr.lastObject;
        TZSDbTableCmpResult cmpResult = [self verifyCompatibilyForTable:model];
        // for now - if the class property type is not compatible with the current database table
        if (cmpResult == TZSDbTableMigratable) {
            // do the migration
            BOOL migrateResult = [self migrateClassTable:model];
            if (migrateResult) {
                // if migration success the means the table are the same as current class
                cmpResult = TZSDbTableTheSame;
            }
            else{
                // for the migration failure case, the only left option is to drop the table and create a new version
                cmpResult = TZSDbTableChanged;
            }
        }
        
        if (cmpResult == TZSDbTableChanged) {
            [self dropModels:[model class]];
        }
        
        if (cmpResult != TZSDbTableTheSame) {
            [xbDbQueue inDatabase:^(FMDatabase *db) {
                @try {
                    if (![db open]) {
                        NSLog(@"DBError:open failed");
                        return ;
                    }
                    NSString *createSQL = [XBDbHandler createTableSQLWithModel:(NSObject *)model inDb:db];
                    db.shouldCacheStatements = YES;
                    if (![db executeUpdate:createSQL]) {
                        NSLog(@"create DB fail - %@", createSQL);
                    };
                }
                @catch (NSException *exception) {
                    NSLog(@"DBError:%@",exception.userInfo.description);
                }
                @finally {
                    [db close];
                }
            }];
        }
    }
    
    // insert or update the data
    for (int i=0; i<modelArr.count; i++) {
        NSObject * model = [modelArr objectAtIndex:i];
        
        // check if this model exists in the db
        // not sure if this might be a potential efficiency problem, but querying everytime for every object feels pretty weird, so list this as TODO
        BOOL recordExists = NO;
        NSObject * pKeyValue = nil;
        if (pKey != nil) {
            pKeyValue = [self fetchValueFrom:model forKey:pKey];
            if (pKeyValue != nil) {
                NSArray * existingObjs = [self queryWithClass:[model class] key:pKey value:pKeyValue orderByKey:nil desc:NO];
                // TODO - shall we change this to == 1 ?
                if (existingObjs.count > 0) {
                    recordExists = YES;
                }
            }
        }
        
        if (recordExists) {
            [self updateModel:model primaryKey:pKey pKeyValue:pKeyValue];
        }
        else{
            [self insertModel:model];
        }
    }
    
    return YES;
}

#pragma mark -deleteWithIds
- (BOOL)deleteWithIds:(NSArray *)ids sql:(NSString *)sql {
    
    return YES;
}

#pragma mark -queryWithIds
- (NSArray *)queryWithIds:(NSArray *)ids sql:(NSString *)sql {
    
    return nil;
}

- (BOOL) deleteModels: (NSArray *)arrOfmodel withPrimaryKey: (NSString *)key
{
    __block BOOL deleteRst = NO;
    // first get table name & set up the sql command
    NSObject * model = arrOfmodel.lastObject;
    NSString * tableName = NSStringFromClass([model class]);
    NSString * sqlString = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",tableName,key];
    
    NSObject * pKeyValue = [self fetchValueFrom:model forKey:key];
    if ([pKeyValue isKindOfClass:[NSString class]]) {
        // binding the like parameter doesn't need ''
        sqlString = [sqlString stringByAppendingString:@" LIKE ?"];
    }
    else if ([pKeyValue isKindOfClass:[NSNumber class]]) {
        sqlString = [sqlString stringByAppendingString:@" = ?"];
    }
    else{
        NSLog(@"parameter error");
        return NO;
    }
    
    // execute it
    for (NSObject * delModel in arrOfmodel) {
        NSObject * delMKeyValue = [self fetchValueFrom:delModel forKey:key];
        [xbDbQueue inDatabase:^(FMDatabase *db) {
            @try {
                if (![db open]) {
                    NSLog(@"DBError:open failed");
                    return ;
                }
                //NSLog(@"executing insert sql - %@",sqlString);
                deleteRst = [db executeUpdate:sqlString, delMKeyValue];
            }
            @catch (NSException *exception) {
                NSLog(@"DBError:%@",exception.userInfo.description);
            }
            @finally {
                [db close];
            }
        }];
    }
    return deleteRst;
}

- (NSArray *) queryWithClass: (Class)modelClass key: (NSString *) key value :(NSObject *) value orderByKey:(NSString *)oKey desc:(BOOL)desc
{
    NSMutableArray * resultObjArray = [NSMutableArray array];
    NSString * tableName = NSStringFromClass(modelClass);
    
    NSString* sqlString = @"";
    
    // table
    sqlString = [NSString stringWithFormat:@"SELECT * FROM %@ ",tableName];
    
    // condition
    if (key != nil && value != nil) {
        if ([value isKindOfClass:[NSString class]]) {
            // TODO - currently it's a full match under the case of string scenario, need to consider pattern match by %
            // NOTE - binding the like parameter doesn't need ''
            sqlString = [sqlString stringByAppendingString:[NSString stringWithFormat:@"where %@ LIKE ? ", key]];
        }
        else if([value isKindOfClass:[NSNumber class]]){
            sqlString = [sqlString stringByAppendingString:[NSString stringWithFormat:@"where %@=? ", key]];
        }
        else
        {
            // object other than nsstring nsnumber is not supported for now
            return resultObjArray;
        }
    }
    
    // sort
    if (oKey != nil) {
        sqlString = [sqlString stringByAppendingString:[NSString stringWithFormat:@"order by %@ %@", oKey, desc ? @"DESC" : @"ASC"]];
    }
    
    [xbDbQueue inDatabase:^(FMDatabase *db) {
        @try {
            if (![db open]) {
                NSLog(@"DBError:open failed");
                return ;
            }
            FMResultSet* result = [db executeQuery:sqlString,value];
            //FMResultSet* result = [db executeQuery:@"SELECT * FROM TZSUser where usrId LIKE 'r817k5d6'"];
            while ([result next]) {
                id<NSObject> obj = [self objectFromFMResult:result byClass:modelClass];
                if (obj != nil) {
                    [resultObjArray addObject:obj];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"DBError:%@",exception.userInfo.description);
        }
        @finally {
            [db close];
        }
    }];
    return resultObjArray;
}

- (BOOL) dropModels: (Class)modelClass
{
    NSString *createTableSQL = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",NSStringFromClass(modelClass.class)];
    
    __block BOOL dropResult = NO;
    [xbDbQueue inDatabase:^(FMDatabase *db) {
        @try {
            if (![db open]) {
                NSLog(@"DBError:open failed");
                return ;
            }
            dropResult = [db executeUpdate:createTableSQL];
        }
        @catch (NSException *exception) {
            NSLog(@"DBError:%@",exception.userInfo.description);
        }
        @finally {
            [db close];
        }
    }];
    
    return dropResult;
}



#pragma mark private funcitons - shall NOT be public
- (BOOL) insertModel: (NSObject *)model
{
    __block BOOL insertResult = NO;
    // first get table name
    NSString * tableName = NSStringFromClass([model class]);
    NSString * sqlString = [NSString stringWithFormat:@"INSERT INTO %@ VALUES(",tableName];
    
    // enum through the properties and set up 1 sql command 2 parameter array
    unsigned int propertyCount;
    objc_property_t *properties = class_copyAllPropertyList([model class], &propertyCount);
    NSMutableArray * arrOfValue = [[NSMutableArray alloc]init];
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        // 属性
        const char *propertyName = property_getName(property);
        NSString *propertyStr = [NSString stringWithUTF8String:propertyName];
        
        const char *attributeOfProperty = property_getAttributes(property);
        NSString *strOfAttribute = [NSString stringWithUTF8String:attributeOfProperty];
        
        if (![[self class]canPropertyBeStored:strOfAttribute]) {
            continue;
        }
        
        sqlString = [sqlString stringByAppendingString:@"?,"];
        
        NSObject * pKeyValue = [self fetchValueFrom:model forKey:propertyStr];
        [arrOfValue addObject:pKeyValue == nil? @"":pKeyValue];
    }
    
    sqlString = [sqlString substringToIndex:[sqlString length]-1];
    
    sqlString = [sqlString stringByAppendingString:@")"];
    
    // execute it
    [xbDbQueue inDatabase:^(FMDatabase *db) {
        @try {
            if (![db open]) {
                NSLog(@"DBError:open failed");
                return ;
            }
            //NSLog(@"executing insert sql - %@",sqlString);
            insertResult = [db executeUpdate:sqlString withArgumentsInArray:arrOfValue];
        }
        @catch (NSException *exception) {
            NSLog(@"DBError:%@",exception.userInfo.description);
        }
        @finally {
            [db close];
        }
    }];
    
    free(properties);
    return insertResult;
}


- (BOOL) updateModel: (NSObject *)model primaryKey: (NSString *)pkey pKeyValue: (NSObject *)value
{
    __block BOOL insertResult = NO;
    // first get table name
    NSString * tableName = NSStringFromClass([model class]);
    NSString * sqlString = [NSString stringWithFormat:@"UPDATE %@ set ",tableName];
    
    NSMutableArray * keyValuePairArr = [NSMutableArray array];
    // enum through the properties and set up 1 sql command 2 parameter array
    unsigned int propertyCount;
    objc_property_t *properties = class_copyAllPropertyList([model class], &propertyCount);
    NSMutableArray * arrOfValue = [[NSMutableArray alloc]init];
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        // 属性
        const char *propertyName = property_getName(property);
        NSString *propertyStr = [NSString stringWithUTF8String:propertyName];
        
        const char *attributeOfProperty = property_getAttributes(property);
        NSString *strOfAttribute = [NSString stringWithUTF8String:attributeOfProperty];
        
        if (![[self class]canPropertyBeStored:strOfAttribute]) {
            continue;
        }
        
        [keyValuePairArr addObject:[NSString stringWithFormat:@"%@ = ?",propertyStr]];
        
        NSObject * pKeyValue = [self fetchValueFrom:model forKey:propertyStr];
        [arrOfValue addObject:pKeyValue == nil? @"":pKeyValue];
    }
    sqlString = [sqlString stringByAppendingString:[keyValuePairArr componentsJoinedByString:@","]];
    sqlString = [sqlString stringByAppendingString:[NSString stringWithFormat:@"where %@ = ?", pkey]];
    [arrOfValue addObject:value];
    
    // execute it
    [xbDbQueue inDatabase:^(FMDatabase *db) {
        @try {
            if (![db open]) {
                NSLog(@"DBError:open failed");
                return ;
            }
            
            //NSLog(@"executing insert sql - %@",sqlString);
            insertResult = [db executeUpdate:sqlString withArgumentsInArray:arrOfValue];
            // do we need to close FMResultSet? or DB close is sufficient?
        }
        @catch (NSException *exception) {
            NSLog(@"DBError:%@",exception.userInfo.description);
        }
        @finally {
            [db close];
        }
    }];
    free(properties);
    return insertResult;
}

#pragma mark -buildSetSelectorWithProperty
+ (SEL) buildSelectorWithProperty:(NSString *)property {
    NSString *propertySEL = [NSString stringWithFormat:@"set%@%@:",[property substringToIndex:1].uppercaseString,[property substringFromIndex:1]];
    SEL setSelector = NSSelectorFromString(propertySEL);
    return setSelector;
}

+ (SEL) buildGetSelectorWithProperty:(NSString *)property {
    SEL getSelector = NSSelectorFromString(property);
    return getSelector;
}


- ( id<NSObject>) objectFromFMResult: (FMResultSet *)resultSet byClass: (Class)modelClass
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    // first create the target class object
    if (![modelClass isSubclassOfClass:[NSObject class]]) {
        return nil;
    }
    
    id<NSObject> resultObj = [[modelClass alloc]init];
    
    // them map data from result to the target class object
    unsigned int propertyCount;
    objc_property_t *properties = class_copyAllPropertyList(modelClass, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        
        // 属性
        const char *propertyName = property_getName(property);
        NSString *propertyStr = [NSString stringWithUTF8String:propertyName];
        
        // 拆解分析属性
        const char *attributeOfProperty = property_getAttributes(property);
        NSString *strOfAttribute = [NSString stringWithUTF8String:attributeOfProperty];
        
        if ([[self class]canPropertyBeStored:strOfAttribute]) {
            SEL setSEL = [[self class] buildSelectorWithProperty:propertyStr];
            // put the valide property into the class
            if ([strOfAttribute rangeOfString:@"NSNumber"].location != NSNotFound) {
                NSNumber *number = nil;
                
                NSString *resultStr = (NSString *)[resultSet stringForColumn:propertyStr];
                if (resultStr.length > 0) {
                    number = [NSNumber numberWithDouble:resultStr.doubleValue];
                }
                //double rstDoulbleValue = [resultSet doubleForColumn:propertyStr];
                if ([resultObj respondsToSelector:setSEL]) {
                    [resultObj performSelector:setSEL withObject:number];
                }
            }
            else if ([strOfAttribute rangeOfString:@"NSString"].location != NSNotFound) {
                NSString * rstStringValue = [resultSet stringForColumn:propertyStr];
                if ([resultObj respondsToSelector:setSEL]) {
                    [resultObj performSelector:setSEL withObject:rstStringValue];
                }
            }
            
        }
    }
    free(properties);
    // let's give it back
    return resultObj;
}

- (NSObject *) fetchValueFrom: (NSObject *)model forKey:(NSString *)key
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    SEL getterSel = [[self class] buildGetSelectorWithProperty:key];
    if ([model respondsToSelector:getterSel]) {
        return [model performSelector:getterSel];
    }
    return nil;
}

// currently the compatibility check is quite weak, only check for the number of columns
// for future implementation of compatibility and data migration, check .h file header corresponding section
- (TZSDbTableCmpResult) verifyCompatibilyForTable: (NSObject *) model
{
    if (![self isTableExist:NSStringFromClass(model.class)]) {
        return TZSDbTableNotExist;
    }
    
    // try the migration version first
    if ([model.class conformsToProtocol:@protocol(XBDbMigrationProtocol)]) {
        NSNumber * currentVersion = (NSNumber *)[model performSelector:@selector(dataVersionOfClass)];
        NSUInteger dbVersion = [self getInDbClassVersion:model.class];
        
        if (currentVersion.unsignedIntegerValue != dbVersion) {
            return TZSDbTableMigratable;
        }
    }
    
    unsigned int propertyCount;
    unsigned int storePropertyCount = 0;
    objc_property_t *properties = class_copyAllPropertyList(model.class, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        // 拆解分析属性
        const char *attributeOfProperty = property_getAttributes(property);
        NSString *strOfAttribute = [NSString stringWithUTF8String:attributeOfProperty];
        
        if ([[self class] canPropertyBeStored:strOfAttribute]) {
            storePropertyCount++;
        }
    }
    free(properties);
    
    int currentTableColNo = [self tableColumnCount:NSStringFromClass(model.class)];
    if (currentTableColNo != storePropertyCount) {
        return TZSDbTableChanged;
    }
    return  TZSDbTableTheSame;
}

- (BOOL) isTableExist: (NSString *)tableName
{
    NSString * checkSql = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@' ", tableName];
    __block BOOL exist = NO;
    
    [xbDbQueue inDatabase:^(FMDatabase *db) {
        @try {
            if (![db open]) {
                NSLog(@"DBError:open failed");
                return ;
            }
            FMResultSet * resultSet =  [db executeQuery:checkSql];
            if (resultSet.next) {
                exist = YES;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"DBError:%@",exception.userInfo.description);
        }
        @finally {
            [db close];
        }
    }];
    
    return  exist;
}

- (unsigned int) tableColumnCount:(NSString *)tableName
{
    NSString * schemaSql =  [NSString stringWithFormat:@"PRAGMA table_info(%@)", tableName];
    
    __block unsigned int countOfCol = 0;
    // execute it
    [xbDbQueue inDatabase:^(FMDatabase *db) {
        @try {
            if (![db open]) {
                NSLog(@"DBError:open failed");
                return ;
            }
            [db executeStatements:schemaSql withResultBlock:^int(NSDictionary *resultsDictionary) {
                countOfCol++;
                return SQLITE_OK;
            }];
        }
        @catch (NSException *exception) {
            NSLog(@"DBError:%@",exception.userInfo.description);
        }
        @finally {
            [db close];
        }
    }];
    
    return countOfCol;
}

#pragma mark table of table version related functions

- (void) createTableVersionDb
{
    NSString * tableName = NSStringFromClass([XBDbVersionTable class]);
    if (![self isTableExist:tableName]) {
        [xbDbQueue inDatabase:^(FMDatabase *db) {
            @try {
                if (![db open]) {
                    NSLog(@"DBError:open failed");
                    return ;
                }
                NSString *createSQL = [XBDbHandler createTableSQLWithModel:(NSObject *)[[XBDbVersionTable alloc]init] inDb:db];
                db.shouldCacheStatements = YES;
                if (![db executeUpdate:createSQL]) {
                    NSLog(@"create DB fail - %@", createSQL);
                };
            }
            @catch (NSException *exception) {
                NSLog(@"DBError:%@",exception.userInfo.description);
            }
            @finally {
                [db close];
            }
        }];
    }
}

- (void) updateClassVersion: (NSObject*)model
{
    XBDbVersionTable * tVersion = [[XBDbVersionTable alloc]init];
    tVersion.tablename =  NSStringFromClass([model class]);
    NSNumber * version = (NSNumber *)[model performSelector:@selector(dataVersionOfClass)];
    tVersion.version = version;
    [self insertOrUpdateWithModelArr:@[tVersion] byPrimaryKey:@"tablename"];
}

- (NSUInteger) getInDbClassVersion: (Class)modelClass
{
    NSString * tableName = NSStringFromClass(modelClass);
    NSArray * tVersionArray = [self queryWithClass:[XBDbVersionTable class] key:@"tablename" value:tableName orderByKey:nil desc:NO];
    if (tVersionArray != nil && [tVersionArray count] == 1) {
        XBDbVersionTable * tVersion = tVersionArray.lastObject;
        return tVersion.version.integerValue;
    }
    return 0;
}

- (BOOL) migrateClassTable: (NSObject *) model
{
    // just a double check
    if (![model.class conformsToProtocol:@protocol(XBDbMigrationProtocol)]) {
        return NO;
    }
    
    // this part of the code is a little bit duplicated, i just wanna the function to be totally seperated as we may face quite a lot of change
    NSNumber * currentVersion = (NSNumber *)[model performSelector:@selector(dataVersionOfClass)];
    NSUInteger dbVersion = [self getInDbClassVersion:model.class];
    
    if (currentVersion.unsignedIntegerValue == dbVersion) {
        return YES;
    }
    // NOTE FOR NOW WE ONLY support upgrade, but downgrade shall be supported ;-) it's easy, i just need time
    if (currentVersion.unsignedIntegerValue < dbVersion) {
        return NO;
    }
    
    // let's get the delta information for add/delete/update
    NSMutableDictionary * totalAddSet    = [NSMutableDictionary dictionary];
    NSMutableDictionary * totalUpdateSet = [NSMutableDictionary dictionary];
    NSMutableDictionary * totaldeleteSet = [NSMutableDictionary dictionary];
    
    for (NSUInteger i = dbVersion+1; i <= currentVersion.unsignedIntegerValue; i++){
        NSArray * addArray = [model performSelector:@selector(addedKeysForVersion:) withObject:[NSNumber numberWithUnsignedInteger:i]];
        NSArray * deleleArray = [model performSelector:@selector(deletedKeysForVersion:) withObject:[NSNumber numberWithUnsignedInteger:i]];
        NSMutableDictionary * updateDic = [NSMutableDictionary dictionaryWithDictionary:[model performSelector:@selector(renamedKeysForVersion:) withObject:[NSNumber numberWithUnsignedInteger:i]]];
        
        // quite complicated here, i almost give up on this one... so here is the scenario
        // Short version:
        // for all the changes from orignial to target, we would like a final change to summarize
        
        // Long version:
        // For all the   ADDS     UPDATES     DELETES
        //               add1      update1    delete1
        //               add2      update2    delete2
        //               ..        ..         ..
        //               addn      updaten    deleten
        
        // the first thing for any addx, deletex and updatex is merge them with previous changes So -
        // 1. ADDs minus deletex, if a match is found, then both of the item can be removed
        // 2. DELETES minus addx, if a match is found, then both of the item can be removed - think about 1&2, quite a lot of cases actually ;-D
        // 3. ADDs merge with updatex, if a key to key match is found, the key in ADDs will be replaced by updatex's value, then remove it from updatex
        // 4. UPDATES minus deletex, in case the updated key is removed. then remove the update item and change deletex to the original item.
        
        // after above merges then put addx into ADDS, updatex into UPDATES, deletex into DELETES
        
        NSMutableArray * dArray = [NSMutableArray arrayWithArray:deleleArray];
        NSMutableArray * aArray = [NSMutableArray arrayWithArray:addArray];
        
        [totalAddSet minusByKeyArray:dArray modifyInput:YES];
        [totaldeleteSet minusByKeyArray:aArray modifyInput:YES];
        [totalAddSet mergeWithUpdateDic:updateDic];
        [totalUpdateSet minusByKeyArrayUseValue:dArray modifyInput:YES];
        
        [totalAddSet addByKeyArray:aArray];
        [totaldeleteSet addByKeyArray:dArray];
        [totalUpdateSet addDic:updateDic];
    }
    
    // ok - after having the final ADDS DELETS UPDATES, let's operate on the db
    // due to the fact that sqlite doesn't support the alter for column name or delete column - here is my approach to do the dirty job
    
    // first get all the target class properties
    unsigned int propertyCount;
    objc_property_t *properties = class_copyAllPropertyList(model.class, &propertyCount);
    NSMutableArray *propertyArr = [NSMutableArray arrayWithCapacity:propertyCount];
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        
        // 属性
        const char *propertyName = property_getName(property);
        NSString *propertyStr = [NSString stringWithUTF8String:propertyName];
        
        // 拆解分析属性
        const char *attributeOfProperty = property_getAttributes(property);
        NSString *strOfAttribute = [NSString stringWithUTF8String:attributeOfProperty];
        
        if ([[self class] canPropertyBeStored:strOfAttribute]) {
            if ([strOfAttribute rangeOfString:@"NSNumber"].location != NSNotFound) {
                [propertyArr addObject:[NSString stringWithFormat:@"%@ double",propertyStr]];
            }
            else if ([strOfAttribute rangeOfString:@"NSString"].location != NSNotFound) {
                [propertyArr addObject:[NSString stringWithFormat:@"%@ text",propertyStr]];
            }
        }
    }
    
    // dump all the data from origial table and creat objects from that
    NSString * queryString = [NSString stringWithFormat:@"SELECT * FROM %@ ",NSStringFromClass(model.class)];
    NSMutableArray * mergedObjects = [NSMutableArray array];
    [xbDbQueue inDatabase:^(FMDatabase *db) {
        @try {
            if (![db open]) {
                NSLog(@"DBError:open failed");
                return ;
            }
            FMResultSet* result = [db executeQuery:queryString];
            while ([result next]) {
                // try load it do new class
                // create a object of new class
                id<NSObject> resultObj = [[model.class alloc]init];
                
                // first get the properties of new class
                for (unsigned int i = 0; i < propertyCount; i++) {
                    objc_property_t property = properties[i];
                    
                    const char *propertyName = property_getName(property);
                    NSString *propertyStr = [NSString stringWithUTF8String:propertyName];
                    const char *attributeOfProperty = property_getAttributes(property);
                    NSString *strOfAttribute = [NSString stringWithUTF8String:attributeOfProperty];
                    if ([[self class] canPropertyBeStored:strOfAttribute]) {
                        __block NSString * origKey = propertyStr;
                        [totalUpdateSet enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                            if ([(NSString *)obj isEqualToString:origKey]) {
                                origKey = (NSString *)key;
                                *stop = YES;
                            }
                        }];
                        SEL setSEL = [[self class] buildSelectorWithProperty:propertyStr];
                        // put the valide property into the class
                        if ([strOfAttribute rangeOfString:@"NSNumber"].location != NSNotFound) {
                            double rstDoulbleValue = [result doubleForColumn:origKey];
                            if ([resultObj respondsToSelector:setSEL]) {
                                [resultObj performSelector:setSEL withObject:[NSNumber numberWithDouble:rstDoulbleValue]];
                            }
                        }
                        else if ([strOfAttribute rangeOfString:@"NSString"].location != NSNotFound) {
                            NSString * rstStringValue = [result stringForColumn:origKey];
                            if ([resultObj respondsToSelector:setSEL]) {
                                [resultObj performSelector:setSEL withObject:rstStringValue == nil ? @"" : rstStringValue];
                            }
                        }
                    }
                }
                [mergedObjects addObject:resultObj];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"DBError:%@",exception.userInfo.description);
        }
        @finally {
            [db close];
        }
    }];
    
    // drop the old table
    [self dropModels:model.class];
    
    // create new
    NSString *createTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)",NSStringFromClass(model.class),[propertyArr componentsJoinedByString:@","]];
    [xbDbQueue inDatabase:^(FMDatabase *db) {
        @try {
            if (![db open]) {
                NSLog(@"DBError:open failed");
                return ;
            }
            db.shouldCacheStatements = YES;
            if (![db executeUpdate:createTableSQL]) {
                NSLog(@"create DB fail - %@", createTableSQL);
            };
        }
        @catch (NSException *exception) {
            NSLog(@"DBError:%@",exception.userInfo.description);
        }
        @finally {
            [db close];
        }
    }];
    
    // insert data in
    for (int i=0; i<mergedObjects.count; i++) {
        NSObject * model = [mergedObjects objectAtIndex:i];
        
        NSString *primaryKey = [model performSelector:@selector(primaryKey)];
        // check if this model exists in the db
        // not sure if this might be a potential efficiency problem, but querying everytime for every object feels pretty weird, so list this as TODO
        BOOL recordExists = NO;
        NSObject * pKeyValue = nil;
        if (primaryKey != nil) {
            pKeyValue = [self fetchValueFrom:model forKey:primaryKey];
            if (pKeyValue != nil){
                NSArray * existingObjs = [self queryWithClass:[model class] key:primaryKey value:pKeyValue orderByKey:nil desc:NO];
                // TODO - shall we change this to == 1 ?
                if (existingObjs.count > 0) {
                    recordExists = YES;
                }
            }
        }
        if (recordExists) {
            [self updateModel:model primaryKey:primaryKey pKeyValue:pKeyValue];
        }
        else{
            [self insertModel:model];
        }
    }
    
    // update table version information
    XBDbVersionTable * newDBTVersion = [[XBDbVersionTable alloc]init];
    newDBTVersion.tablename = NSStringFromClass(model.class);
    newDBTVersion.version = currentVersion;
    [self insertOrUpdateWithModelArr:@[newDBTVersion] byPrimaryKey:@"tablename"];
    
    free(properties);
    return YES;
}

- (NSString *) fetchPropertyType:(Class )cls byName:(NSString *)name
{
    unsigned int propertyCount;
    NSString * propertyType;
    objc_property_t *properties = class_copyAllPropertyList(cls, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        NSString *propertyStr = [NSString stringWithUTF8String:propertyName];
        if ([propertyStr isEqualToString:name]) {
            const char *attributeOfProperty = property_getAttributes(property);
            NSString *strOfAttribute = [NSString stringWithUTF8String:attributeOfProperty];
            if ([[self class] canPropertyBeStored:strOfAttribute]) {
                if ([strOfAttribute rangeOfString:@"NSNumber"].location != NSNotFound) {
                    propertyType =  @"double";
                }
                else if ([strOfAttribute rangeOfString:@"NSString"].location != NSNotFound) {
                    propertyType = @"text";
                }
            }
            break;
        }
    }
    free(properties);
    return propertyType;
}


#pragma mark extension for copy_propertyList

// copies the property list util it reaches the NSObject
// Attention - same as class_copyPropertyList, the returned objc_property_t * needs to be explictly freed by caller.
objc_property_t *class_copyAllPropertyList(Class cls, unsigned int *outCount)
{
    unsigned int propertyCountInAll = 0;
    objc_property_t * currentProperties = NULL;
    Class currentCls = cls;
    while (currentCls != [NSObject class]) {
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(currentCls, &propertyCount);
        if (currentProperties == NULL) {
            propertyCountInAll += propertyCount;
            currentProperties = malloc(propertyCountInAll * sizeof(objc_property_t));
            if (currentProperties != NULL) {
                for (int i=0; i<propertyCount; i++) {
                    currentProperties[i] = properties[i];
                }
            }
        }
        else{
            unsigned int oldCount = propertyCountInAll;
            propertyCountInAll += propertyCount;
            currentProperties = realloc(currentProperties, propertyCountInAll* sizeof(objc_property_t));
            for (int i=oldCount; i<propertyCountInAll; i++) {
                currentProperties[i] = properties[i-oldCount];
            }
        }
        currentCls = class_getSuperclass(currentCls);
        free(properties);
    }
    *outCount = propertyCountInAll;
    return currentProperties;
}


#pragma mark NSObject Dump function - ONLY FOR TEST

- (void) dumpObject: (NSObject *) obj
{
    NSLog(@"#### dumping object %@", NSStringFromClass([obj class]));
    if ( [obj conformsToProtocol:@protocol(XBDbMigrationProtocol)]) {
        NSNumber * version = (NSNumber *)[obj performSelector:@selector(dataVersionOfClass)];
        NSString  * pKey = (NSString *)[obj performSelector:@selector(primaryKey)];
        NSLog(@"## class supports migration");
        NSLog(@"## class data version is %@", version);
        NSLog(@"## class primaryKey is %@", pKey);
    }
    else
    {
        NSLog(@"## class doesn't support migration");
    }
    
    unsigned int propertyCount;
    objc_property_t *properties = class_copyAllPropertyList(obj.class, &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        const char *propertyName = property_getName(property);
        NSString *propertyStr = [NSString stringWithUTF8String:propertyName];
        const char *attributeOfProperty = property_getAttributes(property);
        NSString *strOfAttribute = [NSString stringWithUTF8String:attributeOfProperty];
        if ([[self class] canPropertyBeStored:strOfAttribute]) {
            NSObject * pKeyValue = [self fetchValueFrom:obj forKey:propertyStr];
            NSLog(@"## key %@ value %@", strOfAttribute, pKeyValue == nil ? @"nil" :pKeyValue);
        }
    }
}

@end
