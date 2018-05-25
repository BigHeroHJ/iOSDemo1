//
//  XFDTDBManager.m
//  XFDTToolsKit
//
//  Created by iFlytek on 2018/5/24.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import "XFDTDBManager.h"
#import "XFDTPerformanceDefine.h"

static NSString *const dbName = @"XFDTTools.sqlite";
static NSString *const sqlFileNameOfCreateTable = @"XFDTTools.sqlite.sql";

@interface XFDTDBManager ()

@end

@implementation XFDTDBManager

+ (XFDTDBManager *)sharedManager {
    static id _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

/** 创建并打开数据库 */
- (void)createAndOpenDatabase {
    NSString *dbPath = [DocumentDirectory stringByAppendingPathComponent:dbName];
    NSLog(@"dbPath = %@", dbPath);

    sqlite3 *dbHandler = NULL;
    BOOL result = sqlite3_open_v2(dbPath.UTF8String, &dbHandler, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL) == SQLITE_OK;
    NSLog(@"XFSM, 创建并打开数据库%@", result ? @"成功" : @"失败");
    _dbHandler = dbHandler;
}

/** 创建数据表 */
- (void)createTable {
    NSString *path = [NSBundle.mainBundle pathForResource:sqlFileNameOfCreateTable ofType:nil];
    NSAssert1(path, @"SQL 文件 %@ 不存在", sqlFileNameOfCreateTable);
    NSString *sql = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    BOOL result = sqlite3_exec(_dbHandler, sql.UTF8String, NULL, NULL, NULL) == SQLITE_OK;
    NSLog(@"XFSM, 创建数据表%@", result ? @"成功" : @"失败");
}

/** 插入测试数据 */
- (void)insertTestData {
    NSString *path = [NSBundle.mainBundle pathForResource:@"XFDTTools.TestData.Insert.sqlite.sql" ofType:nil];
    BOOL result = [self execSQLFileAtPath:path];
    NSLog(@"XFSM, 插入测试数据[%@]", result ? @"成功" : @"失败");
}

- (BOOL)execSQLFileAtPath:(NSString *)path {
    NSAssert1(path, @"SQL 文件 %@ 不存在", path);
    NSString *sql = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    BOOL result = sqlite3_exec(_dbHandler, sql.UTF8String, NULL, NULL, NULL) == SQLITE_OK;
    NSLog(@"XFSM, 执行 %@ SQL 文件 [%@]", path.lastPathComponent, result ? @"成功" : @"失败");
    return result;
}

- (void)closeDatabase {
    sqlite3_close_v2(self.dbHandler);
}

@end
