//
//  XFDShowParamManager.h
//  XFDTToolsKit
//
//  Created by XDS on 2018/5/25.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFDMonitorConfig.h"

@interface XFDParamsObj :NSObject
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, assign) XFDMonitorType showType;
@property (nonatomic, assign) BOOL isShow;//是否显示多选的按钮
@end

@interface XFDShowParamManager : NSObject

@property (nonatomic, strong) NSArray *showParams;//当前显示在面板的数量
/**
 初始化
 */
+ (instancetype)shareInstance;

/**
 添加一个分类到 面板显示
 */
- (void)addCategoryToShow:(XFDParamsObj *)obj;

/**
 移除一个分类从面板
 */
- (void)removeCategoryOfShow:(XFDParamsObj *)obj;

@end
