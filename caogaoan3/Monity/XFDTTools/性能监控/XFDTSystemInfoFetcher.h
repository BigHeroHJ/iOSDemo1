//
//  XFDTSystemInfoFetcher.h
//  XFSystemMonitor
//
//  Created by iFlytek on 2018/5/21.
//  Copyright © 2018年 Xwoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFDTSystemInfoFetcher : NSObject

/** 获取电量信息 */
@property (nonatomic, class, readonly) CGFloat fetchBatteryLevel;

/** 获取 CPU 占用率 */
@property (nonatomic, class, readonly) double fetchCpuUsage;

/** 获取内存占用 */
@property (nonatomic, class, readonly) uint64_t fetchMemoryUsage;

@end
