//
//  XFSystemMonitor.m
//  XFSystemMonitor
//
//  Created by iFlytek on 2018/5/21.
//  Copyright © 2018年 Xwoder. All rights reserved.
//

#import "XFDTPerformanceMonitor.h"
#import "XFDTSystemInfo.h"
#import "XFDTSystemInfoFetcher.h"
#import "XFDTSystemInfoFormatter.h"
#import "NSFileManager+XFDTExt.h"
#import <mach/mach.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XFSystemMonitorMonitoringDataDisplayMode) {
    XFSystemMonitorMonitoringDataDisplayModeTableView
};

#define DocumentDirectory (NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject)

static NSString *const logFileDirName = @"XFSystemMonitor";

@interface XFSystemMonitor ()

@property (nonatomic, copy) NSString *logFilePath;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, weak) NSFileHandle *logHandler;

@end

@implementation XFSystemMonitor

+ (XFSystemMonitor *)sharedMonitor {
    static XFSystemMonitor *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *logDirPath = [DocumentDirectory stringByAppendingPathComponent:logFileDirName];
        _logDirPath = logDirPath;

        // 创建日志文件夹
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:logDirPath
                                                withIntermediateDirectories:YES
                                                                 attributes:nil
                                                                      error:NULL];
        if (!result) {
            NSLog(@"XFSystemMonitor, 创建日志文件夹出错");
        }

        NSTimer *timer = [NSTimer timerWithTimeInterval:5
                                                 target:self
                                               selector:@selector(updateSystemInfo)
                                               userInfo:nil
                                                repeats:YES];
        _timer = timer;
    }
    return self;
}

- (void)updateSystemInfo {
    XFDTSystemInfo *info = [[XFDTSystemInfo alloc] init];
    info.date = [NSDate date];
    info.batteryLevel = [XFDTSystemInfoFetcher fetchBatteryLevel];
    info.cpuUsage = [XFDTSystemInfoFetcher fetchCpuUsage];
    info.memoryUsage = [XFDTSystemInfoFetcher fetchCpuUsage];

    NSString *infoStr = [XFDTSystemInfoFormatter formatSystemInfo:info mode:SystemInfoFormatterModeSingleLineString];

    NSFileHandle *logHandler = [NSFileHandle fileHandleForWritingAtPath:self.logFilePath];
    if (!logHandler) {
        NSLog(@"XFSystemMonitor, 打开日志文件出错");
        return;
    }
    [logHandler seekToEndOfFile];
    [logHandler writeData:[[infoStr stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    self.logHandler = logHandler;
}

- (void)startMonitoring {
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *dateStr = [dateFormatter stringFromDate:now];

    NSString *logFileName = [NSString stringWithFormat:@"log-%@.txt", dateStr];
    self.logFilePath = [self.logDirPath stringByAppendingPathComponent:logFileName];

    // 创建日志记录文件
    if ([[NSFileManager defaultManager] xfsm_createFileIfNotExistsAtPath:self.logFilePath]) {
        NSLog(@"XFSystemMonitor, 新建日志文件成功, %@", self.logFilePath);
    } else {
        self.logFilePath = nil;
        NSLog(@"XFSystemMonitor, 新建日志文件失败");
        return;
    }

    UIDevice.currentDevice.batteryMonitoringEnabled = YES;
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopMonitoring {
    UIDevice.currentDevice.batteryMonitoringEnabled = NO;
    [self.timer invalidate];
    [self.logHandler closeFile];
}

@end
