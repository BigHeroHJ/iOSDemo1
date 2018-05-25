//
//  XFDMonitorConfig.h
//  XFDTTools
//
//  Created by XDS on 2018/5/25.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#ifndef XFDMonitorConfig_h
#define XFDMonitorConfig_h

typedef NS_OPTIONS(NSUInteger, XFDMonitorType) {
    XFDMonitorTypeMemory = 1,
    XFDMonitorTypeCPU = 1 << 1,
    XFDMonitorTypeBattery = 1 << 2,
    XFDMonitorTypeNTSpeed = 1 << 3,
    XFDMonitorTypeCrashRatio = 1 << 4,
};

#endif /* XFDMonitorConfig_h */
