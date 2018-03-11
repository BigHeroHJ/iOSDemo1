//
//  Son.m
//  caogaoan2
//
//  Created by XDS on 2018/3/5.
//  Copyright © 2018年 MountainX. All rights reserved.
//  objc_msgSendSuper 和 简单的self ,super 理解一下

#import "Son.h"
#import <objc/runtime.h>
#import <objc/message.h>


@implementation Son
- (id)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"%@", NSStringFromClass([self class]));
        NSLog(@"%@", NSStringFromClass([super class]));
        NSLog(@"%@", NSStringFromClass([super class]));
//        NSLog(@"%@", NSStringFromClass([self.superclass class]));
//        NSLog(@"%@", NSStringFromClass([self.superclass superclass]));
//        NSLog(@"%@", NSStringFromClass([[self.superclass superclass] class]));
        
        NSLog(@"runtime get class %@", class_getSuperclass(objc_getClass("Son")));
//        NSLog((NSString *)&__NSConstantStringImpl__var_folders_zb_xb0mtmn11j761g15ky9qj2000000gn_T_Son_664049_mi_0, NSStringFromClass(((Class (*)(id, SEL))(void *)objc_msgSend)((id)self, sel_registerName("class"))));
        
//        NSLog((NSString *)&__NSConstantStringImpl__var_folders_zb_xb0mtmn11j761g15ky9qj2000000gn_T_Son_664049_mi_1, NSStringFromClass(((Class (*)(__rw_objc_super *, SEL))(void *)objc_msgSendSuper)((__rw_objc_super){(id)self, (id)class_getSuperclass(objc_getClass("Son"))}, sel_registerName("class"))));
        
  //向父类发送class 消息的是否 runtime 下的代码 是通过objc_msgSendSuper 传递两个参数 第一个是 __rw_objc_super 的结构体 第二个是SEL 方法 class
//         第一个参数传递的 结构体 构造 是第一个 object 是self ，superclass 是 通过class_getSuperClass()获取 superclass
        
//        struct __rw_objc_super {
//            struct objc_object *object;//代表当前类的对象
//            struct objc_object *superClass;//super class
//            __rw_objc_super(struct objc_object *o, struct objc_object *s) : object(o), superClass(s) {}
//        };
        
//        在执行[super class]时，会做下面的事
//        1. 编译器会先构造一个__rw_objc_super的结构体 而 这个结构体的object 就是当前对象
//        2. 然后去superClass的方法列表中找方法
//        3. 找到之后由object调用。
        //所以在这里的[super someMethod] 其实还是当前这个对象接受方法  也就是self  所以打印的[self class]  和 [super class] 都是son
        //super 就是个障眼法 发，编译器符号， 它可以替换成 [self class],只不过 方法是从 self 的超类开始 寻找。
        
        //证明一下
        [self test1];
        [self test2];
    }
    return self;
}

- (void)test1{
    [self testSelfOrSuper];//直接用父类的方法
}
- (void)test2{
    [super testSelfOrSuper];//间接用父类的方法
}
//static void _I_Son_test1(Son * self, SEL _cmd) {
//((void (*)(id, SEL))(void *)objc_msgSend)((id)self, sel_registerName("testSelfOrSuper"));
//}


//static void _I_Son_test2(Son * self, SEL _cmd) {
//    ((void (*)(__rw_objc_super *, SEL))(void *)objc_msgSendSuper)((__rw_objc_super){(id)self, (id)class_getSuperclass(objc_getClass("Son"))}, sel_registerName("testSelfOrSuper"));
//}
@end
