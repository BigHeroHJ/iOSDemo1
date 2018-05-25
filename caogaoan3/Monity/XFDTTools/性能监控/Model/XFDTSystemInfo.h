//
//  XFDTSystemInfo.h
//  XFSystemMonitorDemo
//
//  Created by iFlytek on 2018/5/22.
//  Copyright © 2018年 Xwoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFDTSystemInfo : NSObject

/** 时间 */
@property (nonatomic, strong) NSDate *date;

/** 电量信息 */
@property (nonatomic, assign) CGFloat batteryLevel;

/** CPU 占用率 */
@property (nonatomic, assign) double cpuUsage;

/** 内存占用 */
@property (nonatomic, assign) uint64_t memoryUsage;

@end
