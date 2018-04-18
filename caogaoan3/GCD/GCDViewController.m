//
//  GCDViewController.m
//  caogaoan3
//
//  Created by XDS on 2018/4/18.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test1];
     [self test2];
    
}
/**
 *
 */
- (void)test1
{
    NSLog(@"current thread is %@",[NSThread currentThread]);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"is block?");
    });
    
    
   dispatch_queue_t serialQueue =  dispatch_queue_create("com.cga.serialQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(serialQueue, ^{
        dispatch_async(serialQueue, ^{//---> 类似在主队列的 串行队列中一样 串行中在这个 队列内在同步 追加一个 block 执行到 当前 串行队列中 也会和主线程 上面 造成的结果一样 卡死掉
            NSLog(@"is serialQueue block?");
        });
    });
    
}

- (void)test2
{
    //并发队列 下 apply 会进行一个 并发的 循环 一般用来执行 for循环中可并发操作的任务
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_queue_t quqeue_serial = dispatch_queue_create("com.cga.serialQueue1", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{ // 在串行队列中 将applay 添加到当前的串行队列 会发现奔溃 因为apply 是同步调用的
//
       // 如果实在串行队列里 有没有意义了 一般的for循环也可以做到  apply并不并发 决定他追加到哪中队列中
        dispatch_apply(10000, queue, ^(size_t index) {
            
            NSLog(@"队列%@：%zu",[NSThread currentThread],index);
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"done");
        });
    });
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
