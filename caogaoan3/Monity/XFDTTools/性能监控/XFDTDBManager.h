//
//  XFDTDBManager.h
//  XFDTToolsKit
//
//  Created by iFlytek on 2018/5/24.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface XFDTDBManager : NSObject

@property (nonatomic, strong, class, readonly) XFDTDBManager *sharedManager;

/** SQLite 数据库句柄 */
@property (nonatomic, assign, readonly) sqlite3 *dbHandler;

/** 创建并打开数据库 */
- (void)createAndOpenDatabase;

/** 创建数据表 */
- (void)createTable;

/** 插入测试数据 */
- (void)insertTestData;

@end
