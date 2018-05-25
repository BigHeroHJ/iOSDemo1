//
//  XFSMSystemInfoFormatter.m
//  XFSystemMonitorDemo
//
//  Created by iFlytek on 2018/5/22.
//  Copyright © 2018年 Xwoder. All rights reserved.
//

#import "XFDTSystemInfoFormatter.h"
#import "XFDTSystemInfo.h"

@interface XFDTSystemInfoFormatter ()

@end

@implementation XFDTSystemInfoFormatter

+ (NSString *)formatSystemInfo:(XFDTSystemInfo *)info mode:(SystemInfoFormatterMode)mode {
    switch (mode) {
        case SystemInfoFormatterModeSingleLineString: {
            NSMutableString *infoStrM = [NSMutableString string];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            [infoStrM appendFormat:@"%@: ", [dateFormatter stringFromDate:info.date]];
            [infoStrM appendFormat:@"CPU Usage: %f; ", info.cpuUsage];
            [infoStrM appendFormat:@"Memory Usage: %@; ", [NSByteCountFormatter stringFromByteCount:info.memoryUsage countStyle:NSByteCountFormatterCountStyleFile]];
            [infoStrM appendFormat:@"Battery Level: %.2f; ", info.batteryLevel];
            return infoStrM;
        }
            break;
    }
}

@end
