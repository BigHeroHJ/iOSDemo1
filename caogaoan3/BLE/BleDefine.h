//
//  BleDefine.h
//  caogaoan3
//
//  Created by XDS on 2018/5/17.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#ifndef BleDefine_h
#define BleDefine_h

// 蓝牙连接状态
typedef enum : NSUInteger {
    kBleConnectStateUnknown         = 0,
    kBleConnectStateConnecting      = 1,
    kBleConnectStateConnected       = 2,
    kBleConnectStateConnectFail     = 3,
    kBleConnectStateDisconnect      = 4,
    kBleConnectStatePoweredOff      = 5,
    kBleConnectStatePoweredOn       = 6,
} BleConnectState;

#endif /* BleDefine_h */
