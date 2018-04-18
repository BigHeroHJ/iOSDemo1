//
//  LookBlockInRuntime.m
//  caogaoan3
//
//  Created by XDS on 2018/4/14.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "LookBlockInRuntime.h"

typedef void(^block3)(void);

@implementation LookBlockInRuntime
//- (id)init
//{
//    [self LookBlockInRuntime:^{
//
//    }];
//}
//struct __LookBlockInRuntime__LookBlockInRuntime__block_impl_0 {
//    struct __block_impl impl;
//    struct __LookBlockInRuntime__LookBlockInRuntime__block_desc_0* Desc;
//    __LookBlockInRuntime__LookBlockInRuntime__block_impl_0(void *fp, struct __LookBlockInRuntime__LookBlockInRuntime__block_desc_0 *desc, int flags=0) {
//        impl.isa = &_NSConcreteStackBlock;
//        impl.Flags = flags;
//        impl.FuncPtr = fp;
//        Desc = desc;
//    }
//};
//static int __LookBlockInRuntime__LookBlockInRuntime__block_func_0(struct __LookBlockInRuntime__LookBlockInRuntime__block_impl_0 *__cself, int a) {
//
//    printf("%d",a);
//    return a;
//}
//
//static struct __LookBlockInRuntime__LookBlockInRuntime__block_desc_0 {
//    size_t reserved;
//    size_t Block_size;
//} __LookBlockInRuntime__LookBlockInRuntime__block_desc_0_DATA = { 0, sizeof(struct __LookBlockInRuntime__LookBlockInRuntime__block_impl_0)};
//
//static void _I_LookBlockInRuntime_LookBlockInRuntime_(LookBlockInRuntime * self, SEL _cmd, void (*block)()) {
//
//
//
//    int(*myBlock)(int) = ((int (*)(int))&__LookBlockInRuntime__LookBlockInRuntime__block_impl_0((void *)__LookBlockInRuntime__LookBlockInRuntime__block_func_0, &__LookBlockInRuntime__LookBlockInRuntime__block_desc_0_DATA));
//    ((int (*)(__block_impl *, int))((__block_impl *)myBlock)->FuncPtr)((__block_impl *)myBlock, 10);
//
//}

- (void)LookBlockInRuntime:(void (^)(void)) block
{
    //block 语法 和一般的c 函数申明一样 只是在返回值类型前面 加个^
   //block 类型变量
    
    int(^myBlock)(int) = ^int(int a){
        printf("%d",a);
        return a;
    };
    int(^myBlock2)(int) = ^int(int a){
        return a;
    };
    myBlock(10);
    myBlock2(10);
    
    
    block3 blk = ^void(void){
        
    };
    
    blk();
}


@end
