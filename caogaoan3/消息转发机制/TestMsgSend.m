//
//  TestMsgSend.m
//  caogaoan2
//
//  Created by XDS on 2018/3/11.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "TestMsgSend.h"
#import <objc/runtime.h>


@implementation TestMsgSend
////在消息 发送 没有实现 消息内容时  系统第一步会走resolveInstanceMethod(调用的是 实例方法) & resolveClassMethod(调用的是类方法)
////+ (BOOL)resolveClassMethod:(SEL)sel
////{
////
////}
//
//void test(id self, SEL _cmd)
//{
//    NSLog(@"%@->%s",self, sel_getName(_cmd));
//}
////step 1
//+ (BOOL)resolveInstanceMethod:(SEL)sel
//{
//    //如果方法没有没实现 则可以在这里动态添加方法实现 不报错
//    if(sel == @selector(test)){
//        class_addMethod(self, sel, (IMP)test, "");
//    }
//    
//    return [super resolveInstanceMethod:sel];
//}
//
////step 2

@end
