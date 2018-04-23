//
//  GCDViewController.m
//  caogaoan3
//
//  Created by XDS on 2018/4/18.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "GCDViewController.h"
#import <pthread.h>
#import <libkern/OSAtomic.h>
#import <os/lock.h>

#define CycleTime (1024*1024*32)


@interface GCDViewController ()
{
    NSLock   *lock;
}
@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
     lock = [[NSLock alloc] init];
//    [self test1];
//     [self test2];
//
    
    //[self test3];
    //[self useLock];
    //[self useNSRecursiveLock];
    //[self conditionLockActive];
    //[self testOSSpinLock];
    //[self compareOSSPinLockWithNSLock];
    
    [self testPriorityReserve];
}

- (void)doAction{
    [lock lock];
    __block int count = 0;
   
        // [NSThread sleepForTimeInterval:20.0];
    
        
        while (true) {
            
            if(count < 100000){
                count ++;
                NSLog(@"%d current thread is:%@",count,[NSThread currentThread]);
            }else{
                break;
            }
            
        }
     [lock unlock];
}

- (void)testPriorityReserve
{
   
//    dispatch_queue_t serialQueue = dispatch_queue_create("com.huangyibiao.serial_queue",
//                                                         DISPATCH_QUEUE_SERIAL);
//    // 将serialQueue放到全局队列中作为子队列，这样优先级就是使用默认
//    dispatch_set_target_queue(serialQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
//
//    dispatch_async(serialQueue, ^{
//        NSLog(@"s1");
//    });
//    dispatch_async(serialQueue, ^{
//        NSLog(@"s2");
//    });
//    dispatch_async(serialQueue, ^{
//        NSLog(@"s3");
//    });
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"优先级高-4");
//    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"优先级高-5");
//    });
    
    dispatch_queue_t queue_highPriority = dispatch_queue_create("com.cga.queuePriorityHigh", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(queue_highPriority, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));//吧自队列设置到 全局队列中 这样就能跟随着全局队列的 优先级了


    dispatch_queue_t queue_lowPriority = dispatch_queue_create("com.cga.queuePrioritylow", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(queue_lowPriority, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));

    dispatch_queue_t queue_defaultPriority = dispatch_queue_create("com.cga.queuePrioritydefalut", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(queue_defaultPriority, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));

    dispatch_async(queue_lowPriority, ^{
        NSLog(@"queue_lowPriority");
        [self doAction];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        dispatch_async(queue_highPriority, ^{
//            NSLog(@"queue_highPriority");
//            [self doAction];
//        });
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"优先级高-4");
             [self doAction];
        });
//        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSLog(@"优先级高-5");
//            [self doAction];
//        });
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSLog(@"优先级高-6");
            for (int i = 0; i< 1000; i++) {
                NSLog(@"优先级高-6---%d current thread is:%@",i,[NSThread currentThread]);
            }
        });
    });


    
    
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
    dispatch_async(queue, ^{ // 在串行队列中 将applay 添加到当前的串行队列 会发现奔溃 因为apply 是同步调用的
       // 如果实在串行队列里 有没有意义了 一般的for循环也可以做到  apply并不并发 决定他追加到哪中队列中
        dispatch_apply(10000, queue, ^(size_t index) {
            
            NSLog(@"队列%@：%zu",[NSThread currentThread],index);
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"done");
        });
    });
    
}

// 条件锁还能实现任务的依赖
- (void)conditionLockActive {
    NSConditionLock *lock = [[NSConditionLock alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i <= 5; i++) {
            [lock lock];
            NSLog(@"1.thread1 condition = %ld, i = %d",(long)lock.condition,i);
            [lock unlockWithCondition:i];
            NSLog(@"2.thread1 condition = %ld, i = %d",(long)lock.condition,i);
        }
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [lock lockWhenCondition:2];
        NSLog(@"thread2");
        [lock unlock];
    });
}


//递归中使用一般的锁的话 会直接死锁了
- (void)useNSRecursiveLock
{
    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
   // NSLock *lock = [[NSLock alloc] init];
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void(^TestMethod)(int);
        
        TestMethod = ^(int value) {
            [lock lock];
            if (value > 0) {
                NSLog(@"value = %d",value);
                [NSThread sleepForTimeInterval:1];
                TestMethod(--value);
            }
            [lock unlock];
        };
        
        NSLog(@"Begain Test");
        TestMethod(5);
    });

}
//nslock 和synchronized
- (void)useLock
{
   __block int ticketsCount = 1000;
     NSLock *lock = [[NSLock alloc] init];
    void (^ countAction)(void) = ^{
      
        
        while (true) {
           // @synchronized(self){//不加这个的话  会重新错乱
            
           // [lock lock];
            
                [NSThread sleepForTimeInterval:0.5];
                if (ticketsCount > 0) {
                    ticketsCount--;
                    NSLog(@"Tickets = %d, Thread:%@",ticketsCount,[NSThread currentThread]);
                }
                else {
                    NSLog(@"Clear  Thread:%@",[NSThread currentThread]);
                    break;
                }
            
           // [lock unlock];
            //}
        }
        
    };
    
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        countAction();
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        countAction();
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        countAction();
    });
    
}

- (void)test3
{
   NSTimeInterval time = [NSDate date].timeIntervalSince1970;
    
    for (int i = 0; i < CycleTime; i++) {
        @synchronized(self) {
            
        }
    }
    NSLog(@"%f : work time of Synchronized",[NSDate date].timeIntervalSince1970-time);
    time = [NSDate date].timeIntervalSince1970;
    
    
    //条件锁
    NSConditionLock *conditionLock = [[NSConditionLock alloc] init];
    for (int i = 0; i < CycleTime; i++) {
        [conditionLock lock];
        [conditionLock unlock];
    }
    NSLog(@"%f : work time of NSConditionLock",[NSDate date].timeIntervalSince1970-time);
    time = [NSDate date].timeIntervalSince1970;
    
    //递归锁
    NSRecursiveLock *rsLock = [[NSRecursiveLock alloc] init];
    for (int i = 0; i < CycleTime; i++) {
        [rsLock lock];
        [rsLock unlock];
    }
    NSLog(@"%f : work time of NSRecursiveLock",[NSDate date].timeIntervalSince1970-time);
    time = [NSDate date].timeIntervalSince1970;
    
    //互斥锁
    NSLock *mutexLock = [[NSLock alloc] init];
    for (int i = 0; i < CycleTime; i++) {
        [mutexLock lock];
        [mutexLock unlock];
    }
    NSLog(@"%f : work time of NSLock",[NSDate date].timeIntervalSince1970-time);
    time = [NSDate date].timeIntervalSince1970;
    
    //互斥锁
    pthread_mutex_t mutex;
    pthread_mutex_init(&mutex, NULL);
    for (int i = 0; i < CycleTime; i++) {
        pthread_mutex_lock(&mutex);
        pthread_mutex_unlock(&mutex);
    }
    NSLog(@"%f : work time of pthread_mutex",[NSDate date].timeIntervalSince1970-time);
    time = [NSDate date].timeIntervalSince1970;
    
    //信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    for (int i = 0; i < CycleTime; i++) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_signal(semaphore);
    }
    NSLog(@"%f : work time of dispatch_semaphore",[NSDate date].timeIntervalSince1970-time);
    time = [NSDate date].timeIntervalSince1970;
    
    //自旋锁
   
    OSSpinLock spinlock = OS_SPINLOCK_INIT;
    for (int i = 0; i < CycleTime; i++) {
        OSSpinLockLock(&spinlock);
        OSSpinLockUnlock(&spinlock);
    }
    
    
    NSLog(@"%f : work time of OSSpinLock",[NSDate date].timeIntervalSince1970-time);
    
  
}

- (void)testOSSpinLock
{
    __block OSSpinLock theLock = OS_SPINLOCK_INIT;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSSpinLockLock(&theLock);
        NSLog(@"线程1");
        sleep(10);
        OSSpinLockUnlock(&theLock);
        NSLog(@"线程1解锁成功");
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        OSSpinLockLock(&theLock);
        NSLog(@"线程2");
        OSSpinLockUnlock(&theLock);
    });


   
    
    
}

- (void)compareOSSPinLockWithNSLock
{
    NSLock *lock = [[NSLock alloc] init];
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lock];
        NSLog(@"线程1");
        sleep(10);
        [lock unlock];
        NSLog(@"线程1解锁成功");
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);//以保证让线程2的代码后执行
        [lock lock];
        NSLog(@"线程2");
        [lock unlock];
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
