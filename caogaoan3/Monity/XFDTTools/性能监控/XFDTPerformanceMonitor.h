//
//  XFSystemMonitor.h
//  XFSystemMonitor
//
//  Created by iFlytek on 2018/5/21.
//  Copyright © 2018年 Xwoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFSystemMonitor : NSObject

@property (nonatomic, strong, class, readonly) XFSystemMonitor *sharedMonitor;

@property (nonatomic, copy, readonly) NSString *logDirPath;

/** 开始监控 */
- (void)startMonitoring;

/** 停止监控 */
- (void)stopMonitoring;

@end
