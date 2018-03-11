//
//  ViewController.m
//  caogaoan3
//
//  Created by XDS on 2018/3/11.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <objc/objc.h>
#import "Father.h"
#import "Son.h"
#import "TestMsgSend.h"
#import "TestMsgSend1.h"

 

@interface ViewController ()

@end

@implementation ViewController


+ (void)load
{
    //第一种替换交换方法
    //三种获取SEL的 方法
    //a、sel_registerName函数
    //    b、Objective-C编译器提供的@selector()
    //    c、NSSelectorFromString()方法
    Method me1 = class_getInstanceMethod(self, @selector(viewWillAppear:));
    
    Method me2 = class_getInstanceMethod(self, sel_registerName([@"viewWillApeara1:" UTF8String]));
    
    //交换方法
    method_exchangeImplementations(me1, me2);
    
    //*********8消息转发
    //消息转发走的第一步
    //    TestMsgSend * testMsg1 = [TestMsgSend new];
    //    [testMsg1 test];
    //消息转发走的第二步
    TestMsgsend1 * testMsg2 = [TestMsgsend1 new];
    [testMsg2 testStep2];
    [testMsg2 testStep3];
    //*********
}

- (void)viewWillApeara1:(BOOL)animated
{
    NSLog(@"使用自己的方法 替换系统的方法");
    [self viewWillApeara1:YES];//这边调用自己的方法 不会循环引用 因为方法被交换了调用的其实是系统的方法
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"再调用 系统的方法");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 发送消息 objc_msgSend
    //[obj test]; 其实在编译运行的时候 是向obj 发送test的 消息
    // <objc/message.h> need this
    ((void (*) (id, SEL))objc_msgSend)(self,sel_registerName("testMsg_send"));//
    //objc_msgSendSuper 往父类发送消息
    
    Son * s1 = [Son new];
    
    //    NSLog(@"%@", NSStringFromClass([Son class]));
    //    NSLog(@"%@", NSStringFromClass([Father class]));
}

- (void)testMsg_send
{
    NSLog(@"向obj 发送test的 消息");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
