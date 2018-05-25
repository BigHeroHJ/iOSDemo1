//
//  NSFileManager+XFDTExt.m
//  XFDTToolsKit
//
//  Created by iFlytek on 2018/5/24.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import "NSFileManager+XFDTExt.h"

@implementation NSFileManager (XFDTExt)

- (BOOL)xfsm_createFileIfNotExistsAtPath:(NSString *)filePath {
    if ([self fileExistsAtPath:filePath] ) {
        return NO;
    }

    return [self createFileAtPath:filePath contents:nil attributes:nil];
}

@end
