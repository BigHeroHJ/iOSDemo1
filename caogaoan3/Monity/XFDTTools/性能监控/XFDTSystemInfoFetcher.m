//
//  XFDTSystemInfoFetcher.m
//  XFSystemMonitor
//
//  Created by iFlytek on 2018/5/21.
//  Copyright © 2018年 Xwoder. All rights reserved.
//

#import "XFDTSystemInfoFetcher.h"
#import <mach/mach.h>

@implementation XFDTSystemInfoFetcher

+ (CGFloat)fetchBatteryLevel {
    return UIDevice.currentDevice.batteryLevel;
}

+ (double)fetchCpuUsage {
    kern_return_t kern;

    thread_array_t threadList;
    mach_msg_type_number_t threadCount;

    thread_info_data_t threadInfo;
    mach_msg_type_number_t threadInfoCount;

    thread_basic_info_t threadBasicInfo;
    uint32_t threadStatistic = 0;

    kern = task_threads(mach_task_self(), &threadList, &threadCount);

    if (kern != KERN_SUCCESS) {
        return -1;
    }

    if (threadCount > 0) {
        threadStatistic += threadCount;
    }

    double totalUsageOfCPU = 0;

    for (mach_msg_type_number_t i = 0; i < threadCount; ++i) {
        threadInfoCount = THREAD_INFO_MAX;
        kern = thread_info(threadList[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount);
        if (kern != KERN_SUCCESS) {
            return -1;
        }

        threadBasicInfo = (thread_basic_info_t)threadInfo;

        if (!(threadBasicInfo->flags & TH_FLAGS_IDLE)) {
            totalUsageOfCPU = totalUsageOfCPU + 100.0 * threadBasicInfo->cpu_usage / TH_USAGE_SCALE;
        }
    }

    kern = vm_deallocate(mach_task_self(), (vm_offset_t)threadList, threadCount * sizeof(thread_t));

    return totalUsageOfCPU;
}

+ (uint64_t)fetchMemoryUsage {
    kern_return_t rval = 0;
    mach_port_t task = mach_task_self();

    struct task_basic_info info = { 0 };
    mach_msg_type_number_t tcnt = TASK_BASIC_INFO_COUNT;
    task_flavor_t flavor = TASK_BASIC_INFO;

    task_info_t tptr = (task_info_t)&info;

    if (tcnt > sizeof(info)) {
        return 0;
    }

    rval = task_info(task, flavor, tptr, &tcnt);
    if (rval != KERN_SUCCESS) {
        return 0;
    }

    return info.resident_size;
}

@end
