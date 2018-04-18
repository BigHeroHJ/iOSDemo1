//
//  ArchiverTool.m
//  caogaoan3
//
//  Created by XDS on 2018/4/16.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "ArchiverTool.h"
#import <objc/runtime.h>

@interface ArchiverTool()

@end

@implementation ArchiverTool

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static ArchiverTool * tool = nil;
    dispatch_once(&onceToken, ^{
        tool = [[ArchiverTool alloc] init];
    });
    return tool;
}

- (void)EncodeObjectWith:(id)obj aCoder:(NSCoder *)aCoder
{
    //获取这个 对象的类
    Class cls = [obj class];
    
    unsigned int count ;
    objc_property_t * proarr = class_copyPropertyList(cls, &count);
    for (int i =0 ; i < count; i++) {
        objc_property_t pro = proarr[i];
        NSString * prokey = [NSString stringWithFormat:@"%s",property_getName(pro)];
        id value = [obj valueForKey:prokey];
        [aCoder encodeObject:value forKey:prokey];
    }
}

- (void)DecodeObjectWith:(id)obj deCoder:(NSCoder *)deCoder
{
    //获取这个 对象的类
    Class cls = [obj class];
    
    unsigned int count ;
    objc_property_t * proarr = class_copyPropertyList(cls, &count);
    for (int i =0 ; i < count; i++) {
        objc_property_t pro = proarr[i];
        NSString * prokey = [NSString stringWithFormat:@"%s",property_getName(pro)];
        id value =  [deCoder decodeObjectForKey:prokey];
        [obj setValue:value forKey:prokey];
    }
}

@end
