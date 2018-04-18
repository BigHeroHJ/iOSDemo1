//
//  ArchiverTool.h
//  caogaoan3
//
//  Created by XDS on 2018/4/16.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchiverTool : NSObject
+ (instancetype)shareInstance;


- (void)EncodeObjectWith:(id)obj aCoder:(NSCoder *)aCoder;
- (void)DecodeObjectWith:(id)obj deCoder:(NSCoder *)deCoder;

@end
