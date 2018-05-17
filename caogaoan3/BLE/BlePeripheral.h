//
//  BlePeripheral.h
//  caogaoan3
//
//  Created by XDS on 2018/5/17.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleDefine.h"

@interface BlePeripheral : NSObject


@property (nonatomic, strong) CBPeripheral * peripheral;

@property (nonatomic, assign) BleConnectState state;


@end
