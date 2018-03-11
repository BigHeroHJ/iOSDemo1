//
//  TestMsgsend1.m
//  caogaoan2
//
//  Created by XDS on 2018/3/11.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "TestMsgsend1.h"
#import <objc/runtime.h>

@implementation TestMsgsend1
//在消息 发送 没有实现 消息内容时  系统第一步会走resolveInstanceMethod(调用的是 实例方法) & resolveClassMethod(调用的是类方法)
//+ (BOOL)resolveClassMethod:(SEL)sel
//{
//
//}

void test(id self, SEL _cmd)
{
    NSLog(@"%@->%s",self, sel_getName(_cmd));
}
//step 1
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    return [super resolveInstanceMethod:sel];
}

//step 2 step1不实现 会走step2
- (id)forwardingTargetForSelector:(SEL)aSelector
{
   TestMsgSendFather * t1 =  [TestMsgSendFather new];
    //如果t1 能处理这个方法 就返回 让这个对象 接受方法 TestMsgSendFather 不需要申明 方法 只要有实现 就可以了
    if([t1 respondsToSelector:aSelector]){//自身 没有实现方法 可以在这里将消息转发给 别的类实现转发
        return t1;
    }
    return nil;
}

// 如果step1 step2 都没做处理 则会进入到第三步
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSString * sel = NSStringFromSelector(aSelector);
    if([sel isEqualToString:@"testStep3"]){
        return [NSMethodSignature methodSignatureForSelector:@selector(testStep3)];//生成自己方法的签名 给step4 进行实现
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL sel = [anInvocation selector];
    TestMsgSendFather * t1 = [TestMsgSendFather new];
    if([t1 respondsToSelector:sel]){
        //用这个invocation 唤醒这个类的方法
        [anInvocation invokeWithTarget:t1];
    }
}
@end
