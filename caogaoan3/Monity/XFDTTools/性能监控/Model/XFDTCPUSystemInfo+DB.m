//
//  XFDTCPUSystemInfo+DB.m
//  XFDTToolsKit
//
//  Created by iFlytek on 2018/5/25.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import "XFDTCPUSystemInfo+DB.h"
#import "XFDTDBManager.h"

@implementation XFDTCPUSystemInfo (DB)

- (void)insertIntoDatabase {
    sqlite3 *dbHandler = XFDTDBManager.sharedManager.dbHandler;
    // 开启事务
    NSString *beginTransactionSql = @"BEGIN TRANSACTION";
    sqlite3_stmt *beginTransactionStmt = NULL;
    if (sqlite3_prepare_v2(dbHandler, beginTransactionSql.UTF8String, -1, &beginTransactionStmt, NULL) != SQLITE_OK) {
        sqlite3_finalize(beginTransactionStmt);
        sqlite3_close(dbHandler);
        return;
    }
    if (SQLITE_DONE != sqlite3_step(beginTransactionStmt)) {
        sqlite3_finalize(beginTransactionStmt);
        sqlite3_close(dbHandler);
        return;
    }
    sqlite3_finalize(beginTransactionStmt);

    // 插入数据

    NSString *insertDataSql = [NSString stringWithFormat:@"INSERT INTO `%@` (usage, date) VALUES (?, ?);", self.tableName];
    sqlite3_stmt *insertDataStmt = NULL;
    if (sqlite3_prepare_v2(dbHandler, insertDataSql.UTF8String, -1, &insertDataStmt, NULL) != SQLITE_OK) {
        sqlite3_finalize(insertDataStmt);
        sqlite3_close(dbHandler);
        return;
    }

    sqlite3_bind_double(insertDataStmt, 1, self.cpuUsage);
    sqlite3_bind_double(insertDataStmt, 2, self.date.timeIntervalSince1970);
    if (sqlite3_step(insertDataStmt) != SQLITE_DONE) {
        sqlite3_finalize(insertDataStmt);
        sqlite3_close(dbHandler);
        return;
    }
    sqlite3_reset(insertDataStmt);
    sqlite3_finalize(insertDataStmt);

    // 提交事务
    NSString *commitTransactionSql = @"COMMIT TRANSACTION";
    sqlite3_stmt *commitTransactionStmt = NULL;
    if (sqlite3_prepare_v2(dbHandler, commitTransactionSql.UTF8String, -1, &commitTransactionStmt, NULL) != SQLITE_OK) {
        sqlite3_finalize(commitTransactionStmt);
        sqlite3_close(dbHandler);
        return;
    }
    if (sqlite3_step(commitTransactionStmt) != SQLITE_DONE) {
        sqlite3_finalize(commitTransactionStmt);
        sqlite3_close(dbHandler);
        return;
    }
    sqlite3_finalize(commitTransactionStmt);
}

- (NSString *)tableName {
    return @"TB_Cpu";
}

@end
