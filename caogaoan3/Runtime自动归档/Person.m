//
//  Person.m
//  caogaoan3
//
//  Created by XDS on 2018/4/16.
//  Copyright © 2018年 MountainX. All rights reserved.
//1. 如果是想自己的；类 具有copy 功能 要实现copyWithZone 将属性都copy 过去

#import "Person.h"
#import <objc/runtime.h>

@implementation Person
- (id)copyWithZone:(NSZone *)zone
{
    Person * p1 = [[Person alloc] init];
    p1.name = [_name copy];
    p1.age  = [_age copy];
    return p1;
}

- (NSString *)description
{
    unsigned int count;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    objc_property_t * prorpertyArray = class_copyPropertyList([self class], &count);
    NSMutableString * str;
    for (int i = 0; i < count; i++) {
      objc_property_t prot = prorpertyArray[i];
        NSString * proKey = [NSString stringWithFormat:@"%s",property_getName(prot)];
        id value = [self valueForKey:proKey];
        if (value) {
            [dic setObject:value forKey:proKey];
        } else {
            [dic setObject:@"" forKey:proKey];
        }
    }
    
    return dic.description;
}

- (void)setName:(NSString *)name
{
    _name = name;
}
@end
