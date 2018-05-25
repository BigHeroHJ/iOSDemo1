//
//  NSFileManager+XFDTExt.h
//  XFDTToolsKit
//
//  Created by iFlytek on 2018/5/24.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (XFDTExt)

- (BOOL)xfsm_createFileIfNotExistsAtPath:(NSString *)filePath;

@end
