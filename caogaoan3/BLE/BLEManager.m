//
//  BLEManager.m
//  caogaoan3
//
//  Created by XDS on 2018/5/17.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "BLEManager.h"
#import "BlePeripheral.h"


NSError * BleError(NSString * errorString)
{
    return [NSError errorWithDomain:@"com.cga.ble" code:0 userInfo:@{@"dec":errorString}];
}


@interface BLEManager()<CBCentralManagerDelegate>

@property (nonatomic, strong) NSMutableArray * scanList;

@property (nonatomic, strong) NSMutableArray * userList;

@property (nonatomic, strong) dispatch_queue_t cbManagerQueue;


@end

@implementation BLEManager

#pragma mark --- life cycle
- (id)init
{
    if(self = [super init]){
        self.cbManagerQueue = dispatch_queue_create("com.cga.cbManagerQueue", 0);
        self.cbCenterManager = [[CBCentralManager alloc] initWithDelegate:self queue:self.cbManagerQueue];
        self.connectState = kBleConnectStateUnknown;
    }
    return self;
}

#pragma mark -- getter
- (NSMutableArray *)scanList
{
    if(_scanList == nil){
        _scanList = [NSMutableArray array];
    }
    return _scanList;
}

- (NSMutableArray *)userList
{
    if(_userList == nil){
        _scanList = [NSMutableArray array];
    }
    return _userList;
}

#pragma mark -- public method
- (void)startScan
{
    [self startScanWithNeedService:nil];
}

- (void)startScanWithNeedService:(NSArray *)services
{
    [self.scanList removeAllObjects];
    [self.userList removeAllObjects];
  
    if(self.cbCenterManager.state == CBManagerStatePoweredOn){
        [self endScan];
        [self.cbCenterManager scanForPeripheralsWithServices:services options:nil];
    }else{
        if(self.scanResultBlock){
            self.scanResultBlock(nil, BleError(@"蓝牙未知未打开"));
        }
    }
}

- (void)endScan
{
    if(self.cbCenterManager.isScanning){
        [self.cbCenterManager stopScan];
    }
}

#pragma mark -- CBcenterManagerDelegate
//状态更新
- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@"kBleConnectStateUnknown");
            self.connectState = kBleConnectStateUnknown;

            break;
        case CBManagerStatePoweredOn:
            NSLog(@"kBleConnectStatePoweredOn");
            self.connectState = kBleConnectStatePoweredOn;

            break;
        case CBManagerStatePoweredOff:
            NSLog(@"kBleConnectStatePoweredOff");
            self.connectState = kBleConnectStatePoweredOff;

            break;
        case CBManagerStateResetting:
            NSLog(@"kBleConnectStateDisconnect");
            self.connectState = kBleConnectStateDisconnect;

            break;
        case CBManagerStateUnsupported:
            self.connectState = kBleConnectStateDisconnect;
            break;
            
        case CBManagerStateUnauthorized:
            self.connectState = kBleConnectStateUnknown;
            break;
            
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    if (peripheral.name.length == 0)
    {
        return;
    }
    
    __block  BOOL alreadAdd = NO;
    [self.scanList enumerateObjectsUsingBlock:^(BlePeripheral * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.peripheral == peripheral)
        {
            alreadAdd = YES;
            *stop = YES;
        }
    }];
    
    if(alreadAdd == NO){
        BlePeripheral * bleP = [BlePeripheral new];
        bleP.peripheral = peripheral;
        [self.scanList addObject:bleP];
    }

    if(self.scanResultBlock){
        self.scanResultBlock(self.scanList, nil);
    }
    
}

-  (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
}

//断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
}

@end
