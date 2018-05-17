//
//  BLEManager.h
//  caogaoan3
//
//  Created by XDS on 2018/5/17.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleDefine.h"


// 中心管理状态变化
typedef void(^CentralStateChangeBlock)(CBManagerState state);
// 扫描结果，扫描过程中不断更新
typedef void(^ScanResultBlock)(NSArray *peripherals, NSError *error);
// 连接状态改变回调
typedef void(^ConnectStateChangeBlock)(BleConnectState state, NSString *name, NSError *error);
// BLE响应回调
typedef void(^DidUpdateValueForCharacteristic)(CBCharacteristic *characteristic, NSError *error);
// BLE订阅接受数据回调
typedef void(^DidUpdateNotificationStateForCharacteristic)(CBCharacteristic *characteristic, NSError *error);
// BLE写入数据回调
typedef void(^DidWriteValueForCharacteristic)(CBCharacteristic *characteristic, NSError *error);


@interface BLEManager : NSObject

// 中心管理状态变化
@property (nonatomic, strong) CentralStateChangeBlock centralStateChangeBlock;
// 扫描结果，扫描过程中不断更新
@property (nonatomic, strong) ScanResultBlock scanResultBlock;
// 连接状态改变回调
@property (nonatomic, strong) ConnectStateChangeBlock connectStateChangeBlock;
// BLE响应回调
@property (nonatomic, strong) DidUpdateValueForCharacteristic didUpdateValueForCharacteristic;
// BLE订阅 接受数据回调
@property (nonatomic, strong) DidUpdateNotificationStateForCharacteristic didUpdateNotificationStateForCharacteristic;
// BLE写入数据回调
@property (nonatomic, strong) DidWriteValueForCharacteristic didWriteValueForCharacteristic;
//蓝牙中心设备类
@property (nonatomic, strong) CBCentralManager * cbCenterManager;

@property (nonatomic, assign) BleConnectState connectState;

/**
 开始扫描
 */
- (void)startScan;

/**
 开始扫描

 @param services 传入需要发现的service 服务
 */
- (void)startScanWithNeedService:(NSArray *)services;

/**
 结束扫描
 */
- (void)endScan;


@end
