//
//  MonityViewController.m
//  caogaoan3
//
//  Created by XDS on 2018/5/22.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "MonityViewController.h"
#import <mach/mach.h>
#import <Foundation/NSProcessInfo.h>



@interface MonityViewController ()
{
    dispatch_source_t _timer;
}
@end

@implementation MonityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

#if TARGET_OS_SIMULATOR
#else
#endif
   NSProcessInfo *processDevice =  [NSProcessInfo processInfo];
   int64_t mem_size = [processDevice physicalMemory];//物理内存
    printf("设备所有的物理内存:%lld",mem_size);
    NSLog(@"process info hostName(设备名字):%@--processName(当前运行的进程名字程序名):%@--processorCount:%ld--activeProcessorCount:%ld",[processDevice hostName],[processDevice processName],[processDevice processorCount],[processDevice activeProcessorCount]);
    //operatingSystemVersionString 设备的版本 最近
    //globallyUniqueString         设备唯一标示
    //processorCount  This property value is equal to the result of entering the command sysctl -n hw.ncpu on the current system.
    //activeProcessorCount 设备cpu核数The number of active processing cores available on the computer.

    
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0.5 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
      float percent =  [self appUsageOfCPU];
        NSLog(@"percent %f",percent);
    });
    dispatch_resume(_timer);
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < 1000000; i++) {
            NSLog(@"%d",i);
        }
    });}

- (void)viewWillDisappear:(BOOL)animated
{
    dispatch_source_cancel(_timer);
}

#pragma mark --memory
- (float)appMemoryUsage
{
    struct mach_task_basic_info  mach_task_info_temp ;//mach_task_basic_info_t 是系统的 mach_task_basic_info这个类型的变量
    
    
    return 0;
}
- (void)memory_test
{
    struct mach_task_basic_info {
        mach_vm_size_t  virtual_size;       /* virtual memory size (bytes) */
        mach_vm_size_t  resident_size;      /* resident memory size (bytes) */
        mach_vm_size_t  resident_size_max;  /* maximum resident memory size (bytes) */
        time_value_t    user_time;          /* total user run time for
                                             terminated threads */
        time_value_t    system_time;        /* total system run time for
                                             terminated threads */
        policy_t        policy;             /* default policy for new threads */
        integer_t       suspend_count;      /* suspend count for task */
    };
}


#pragma mark --cpu
- (float)appUsageOfCPU
{
    kern_return_t kr;//获取操作后的返回值
    task_info_data_t  task_info_data;
   // task_info_t task_info_ = NULL;
    mach_msg_type_number_t task_info_count ;
    task_info_count = TASK_INFO_MAX;
    //获取当前的进程
    // 使用该函数 传递的参数为integer_t类型的指针 task_info_t ，把数组转为这个指针
    kr = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)task_info_data, &task_info_count);
    if(kr != KERN_SUCCESS){
        return -1;
    }
    
    thread_array_t thread_list;//线程缓存的数组
    mach_msg_type_number_t thread_count;//
   
    //获取在task 中的线程
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if(kr != KERN_SUCCESS){
        return -1;
    }
    
    thread_info_data_t threadInfo;//线程输出到的缓存区位置
    mach_msg_type_number_t thread_info_count;//线程存放的缓存区大小
    
    thread_basic_info_t basi_info_t;
    
    float cpusage = 0;
    // 循环获取线程 信息 统计
    for (int i= 0 ; i < (int)thread_count; i++) {
        thread_info_count = THREAD_INFO_MAX;//设置最大 32
        //参数传递和 获取task 类似thread_info_t 是一个integer_t类型的指针  将信息类型缓存数组转为这中指针类型
        kr = thread_info(thread_list[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &thread_info_count);
        if(kr != KERN_SUCCESS){
            return -1;
        }
        basi_info_t = (thread_basic_info_t) threadInfo;
        if(!(basi_info_t->flags & TH_FLAGS_IDLE))
        {
            cpusage += basi_info_t->cpu_usage;
        }
    }
    
    cpusage = cpusage / (float) TH_USAGE_SCALE * 100;
    vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));//释放内存 vm_offset_t 数组指针偏移大小  * 每个线程的大小
    return cpusage;
}

- (void)thread_task_info
{
    //每个mach task,mach 是没有提供进程， 但在BSD层 有个一对一的映射 一个BSD进程 对应一个mach task 任务（在底层关联的mack task） 每个mach task 是这个进程的一个执行环境  可以获取到其中的线程等等
    
    //获取进程的mach task 函数
    kern_return_t task_info
    (
     task_name_t target_task,
     task_flavor_t flavor,
     task_info_t task_info_out,
     mach_msg_type_number_t *task_info_outCnt
     );
    
    // mach 层中基本的thread 信息
    struct thread_basic_info {
        time_value_t    user_time;      /* user run time */
        time_value_t    system_time;    /* system run time */
        integer_t       cpu_usage;      /* scaled cpu usage percentage */
        policy_t        policy;         /* scheduling policy in effect */
        integer_t       run_state;      /* run state (see below) */
        integer_t       flags;          /* various flags (see below) */
        integer_t       suspend_count;  /* suspend count for thread */
        integer_t       sleep_time;     /* number of seconds that thread
                                         has been sleeping */
    };
    
    // 系统提供c函数 task_threads() 来获取指定task 的线程数 和器数目
    kern_return_t task_threads
    (
     task_t target_task,
     thread_act_array_t *act_list,
     mach_msg_type_number_t *act_listCnt
     );
    
    //通过调用thread_info() 来获取指定的thread 的信息
    kern_return_t thread_info
    (
     thread_act_t target_act,
     thread_flavor_t flavor,//指定的thread 信息
     thread_info_t thread_info_out,// 信息返回的缓存区
     mach_msg_type_number_t *thread_info_outCnt//信息返回的长度
     );
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
