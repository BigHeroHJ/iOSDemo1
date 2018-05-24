//
//  XFDTTools.h
//  XFDTTools
//
//  Created by z0x0z on 2018/5/24.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFDTTools : NSObject

/**
 工具是否显示
 */
@property (nonatomic, assign,getter=getToolHidden) BOOL hidden;

/**
 * 初始化XFDTTools
 */
+ (instancetype)create;

/**
 * 是否显示悬浮入口
 */
- (void)showEntry:(BOOL)isShow;

/**
 * 展开XFDTTools详细面板
 */
+ (void)expandToolsPannel;

/**
 * 收起XFDTTools详细面板
 */
+ (void)packupToolsPannel;

/**
 * 销毁XFDTTools
 */
+ (void)destroy;

@end
