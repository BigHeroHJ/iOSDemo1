//
//  XFDTMemorySystemInfo.h
//  XFDTToolsKit
//
//  Created by iFlytek on 2018/5/24.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import "XFDTBaseSystemInfo.h"

@interface XFDTMemorySystemInfo : XFDTBaseSystemInfo

/** 已使用的内存空间 */
@property (nonatomic, assign) uint64_t memoryUsage;

@end
