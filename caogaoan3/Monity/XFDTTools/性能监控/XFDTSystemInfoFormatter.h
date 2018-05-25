//
//  XFSMSystemInfoFormatter.h
//  XFSystemMonitorDemo
//
//  Created by iFlytek on 2018/5/22.
//  Copyright © 2018年 Xwoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XFDTSystemInfo;

typedef NS_ENUM(NSUInteger, SystemInfoFormatterMode) {
    SystemInfoFormatterModeSingleLineString
};

@interface XFDTSystemInfoFormatter : NSObject

+ (NSString *)formatSystemInfo:(XFDTSystemInfo *)info mode:(SystemInfoFormatterMode)mode;

@end
