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

#import <sys/sysctl.h>
#import <mach/thread_act.h>

const float out_timeInterval = 0.5f;
const MonityViewController * selfCalss = nil;
const int64_t lxd_time_out_interval = 1.0f;


@interface MonityViewController ()
{
    dispatch_source_t _timer;
    CFRunLoopObserverRef  _observer;
    
    
    
}

@property(nonatomic,strong) dispatch_queue_t  fluecy_queue;
@property(nonatomic,assign) BOOL isMoniting;
@property(nonatomic,assign) CFRunLoopActivity currentState_runloop;
@property(nonatomic,strong)     dispatch_semaphore_t   semaphore_out;



@end

@implementation MonityViewController

- (id)init
{
    if(self = [super init]){
        selfCalss = self;
        self.semaphore_out = dispatch_semaphore_create(0);

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addRunLoop];
    
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
      float memoryUse = [self appMemoryUsage];
      NSLog(@"memoryUse percent %f",memoryUse);
        
        [self totalMemory];
       
        //NSLog(@"memoryUse percent2 %llu",[self memoryUsage]);
       
        NSLog(@"availableMemory %lluMB",[self availableMemory]);
//        size_t size = 1024 * 1024;
//        char *string = malloc(size);
        
    });
    dispatch_resume(_timer);
   
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
//        for (int i = 0; i < 100000; i++) {
//            NSLog(@"%d",i);
//        }
//    });
    
    
}

#pragma mark -- runloop 去检测是否卡顿

- (dispatch_queue_t)fluecy_queue
{
    if(_fluecy_queue == nil){
        _fluecy_queue = dispatch_queue_create("com.cga.fluecyQueue", NULL);
    }
    return _fluecy_queue;
}

- (void)addRunLoop
{
    CFRunLoopObserverContext context = {
        0,
        (__bridge void *)self,
        NULL,
        NULL
    };
    //这个context 结构体 是在回调中 获取跟踪信息的 如果为空则 callback 中的info 为null
    _observer =CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, observerCallBack, &context);
    
    CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    
    //检测卡顿的 时机 是在
    //1.runloop 即将处理source0 和 在进入休眠之前beforeWaiting
    //2.在afterWaiting 之后 即将唤醒
}

- (void)addMonityOfMainQueue
{
    if(self.isMoniting) return;
    self.isMoniting = YES;
    
    dispatch_async(self.fluecy_queue, ^{
        while (self.isMoniting) {
            if (self.currentState_runloop == kCFRunLoopBeforeWaiting) {
                __block BOOL timeOut = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    timeOut = NO;
                    dispatch_semaphore_signal(self.semaphore_out);
                });
                
                //当前线程睡了 一个阈值之后 主线程 还未修改bool值 表示超时
                [NSThread sleepForTimeInterval:out_timeInterval];
                if(timeOut){
                    //超时了
                }
                //等待主线程 发送信号 继续检测
                dispatch_semaphore_wait(self.semaphore_out, DISPATCH_TIME_FOREVER);
            }
        }
    });
}


void observerCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    selfCalss.currentState_runloop = activity;
    dispatch_semaphore_signal(selfCalss.semaphore_out);
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"runloop entry");
            break;
            
        case kCFRunLoopExit:
            NSLog(@"runloop exit");
            break;
            
        case kCFRunLoopAfterWaiting:
            NSLog(@"runloop after waiting");
            break;
            
        case kCFRunLoopBeforeTimers:
            NSLog(@"runloop before timers");
            break;
            
        case kCFRunLoopBeforeSources:
            NSLog(@"runloop before sources");
            break;
            
        case kCFRunLoopBeforeWaiting:
            NSLog(@"runloop before waiting");
            break;
            
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    dispatch_source_cancel(_timer);
}

#pragma mark --memory
//设备总内存大小
- (void)totalMemory
{
    //http://gamesfromwithin.com/whered-that-memory-go
    //sysctl()
    //#define    HW_PHYSMEM     5        /* int: total memory */
    //#define    HW_USERMEM     6        /* int: non-kernel memory */
    
    int mem;
    int mib[2];
    mib[0] = CTL_HW;
    mib[1] = HW_PHYSMEM;
    size_t length = sizeof(mem);
    sysctl(mib, 2, &mem, &length, NULL, 0);
    NSLog(@"Physical memory: %.2fMB", mem/1024.0f/1024.0f);
    
    mib[1] = HW_USERMEM;
    length = sizeof(mem);
    sysctl(mib, 2, &mem, &length, NULL, 0);
    NSLog(@"User memory: %.2fMB", mem/1024.0f/1024.0f);
    
}

// 可用内存大小
- (uint64_t)availableMemory
{
    host_info_t vmStats;
    vm_statistics_data_t vm_data;
    
    vmStats = (host_info_t)&vm_data;// 将integer_t 指针vmStats =  &vm_data 等于这个结构体类型的指针 中间 转化一下类型
    //我们可以将指针强制转换成int型或者其他类型。同样，我们也可以将任何一个常数转换成int型再赋值给指针。所有的指针所占的空间大小都是4字节，他们只是声明的类型不同，他们的值都是地址指向某个东西，他们对于机器来说没有本质差别，他们之间可以进行强制类型转换。
    
    mach_msg_type_number_t infoCount = HOST_BASIC_INFO_COUNT;
    //eg: 指定 purgeable HOST_VM_PURGABLE  可以获取相应的可清楚的内存 在对应的结构体信息数组中struct vm_purgeable_info {
    // vm_purgeable_stat_t fifo_data[8];
    // vm_purgeable_stat_t obsolete_data;
    // vm_purgeable_stat_t lifo_data[8];
    // }; 当然HOST_BASIC_INFO_COUNT 获取的 信息中有purgeable_count 这个 也是获取对应的count
    
    // 获取方式也是和 获取task thread 类似 系统提供的函数
    //mach_task_self() 这个是获取task 当前   mach_host_self()获取当前host
    kern_return_t kr = host_statistics(mach_host_self(), HOST_BASIC_INFO, vmStats, &infoCount);
    //mach/kern_return.h 中定义 返回结果
    if(kr != KERN_SUCCESS){
        return -1;
    }
    return vm_page_size * vm_data.free_count / 1024.0f / 1024.0f;//free_count 这个结合pagesize 就表示给我们可用的内存的数量 vm_page_size 实在全局定义的变量 在iPhone 上是4K
}

- (void)docmentOfavailableMemory
{
    //获取VM statistic 通过host_statistics() 指定 HOST_VM_INFO_COUNT是来获取到
    struct vm_statistics {
        natural_t    free_count;        /* # of pages free */ //natural_t 其实是unsigned int 类型
        natural_t    active_count;        /* # of pages active */
        natural_t    inactive_count;        /* # of pages inactive */
        natural_t    wire_count;        /* # of pages wired down */
        natural_t    zero_fill_count;    /* # of zero fill pages */
        natural_t    reactivations;        /* # of pages reactivated */
        natural_t    pageins;        /* # of pageins */
        natural_t    pageouts;        /* # of pageouts */
        natural_t    faults;            /* # of faults */
        natural_t    cow_faults;        /* # of copy-on-writes */
        natural_t    lookups;        /* object cache lookups */
        natural_t    hits;            /* object cache hits */
        
        /* added for rev1 */
        natural_t    purgeable_count;    /* # of pages purgeable */
        natural_t    purges;            /* # of pages purged */
        
        /* added for rev2 */
        /*
         * NB: speculative pages are already accounted for in "free_count",
         * so "speculative_count" is the number of "free" pages that are
         * used to hold data that was read speculatively from disk but
         * haven't actually been used by anyone so far.
         */
        natural_t    speculative_count;    /* # of pages speculative */
    };
    //也有对应的 vm_statistics64
    
    kern_return_t host_statistics
    (
     host_t host_priv,
     host_flavor_t flavor,
     host_info_t host_info_out,
     mach_msg_type_number_t *host_info_outCnt
     );
}

//- (uint64_t)memoryUsage {
//    kern_return_t rval = 0;
//    mach_port_t task = mach_task_self();
//
//    struct task_basic_info info = { 0 };
//    mach_msg_type_number_t tcnt = TASK_BASIC_INFO_COUNT;
//    task_flavor_t flavor = TASK_BASIC_INFO;
//
//    task_info_t tptr = (task_info_t)&info;
//
//    if (tcnt > sizeof(info)) {
//        return 0;
//    }
//
//    rval = task_info(task, flavor, tptr, &tcnt);
//    if (rval != KERN_SUCCESS) {
//        return 0;
//    }
//
//    return info.resident_size;
//}
//获取 当前进程的 内存使用
- (float)appMemoryUsage
{
    //struct mach_task_basic_info  mach_task_info_temp ;//mach_task_basic_info_t 是系统的 mach_task_basic_info这个类型的变量
    
    //获取当前的task
    struct mach_task_basic_info info;
    mach_msg_type_number_t count = MACH_TASK_BASIC_INFO_COUNT;
    
    kern_return_t kr ;
    kr = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &count);
    if(kr != KERN_SUCCESS){
        return -1;
    }
    return info.resident_size / 1024.0f / 1024.0f;
    
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
    
    //但是下面这个结构体 不推荐使用了apple
    struct task_basic_info {
        integer_t       suspend_count;  /* suspend count for task */
        vm_size_t       virtual_size;   /* virtual memory size (bytes) */
        vm_size_t       resident_size;  /* resident memory size (bytes) */
        time_value_t    user_time;      /* total user run time for
                                         terminated threads */
        time_value_t    system_time;    /* total system run time for
                                         terminated threads */
        policy_t    policy;        /* default policy for new threads */
    };
    
    //和thread_info 类似 都有获取task 或者thread info信息的函数
    kern_return_t task_info
    (
     task_name_t target_task,
     task_flavor_t flavor,//指定MACH_TASK_BASIC_INFO 这个类型会输出mach_task_basic_info 这个结构体信息
     task_info_t task_info_out,//信息输出的缓存区位置
     mach_msg_type_number_t *task_info_outCnt//信息输出的缓存区的size
     );
}


#pragma mark --cpu
- (float)appUsageOfCPU
{
    kern_return_t kr;//获取操作后的返回值
    task_info_data_t  task_info_data;
   // task_info_t task_info_ = NULL;
    mach_msg_type_number_t task_info_count ;
    task_info_count = TASK_INFO_MAX;
    //获取当前的进程  和进程有关的task。用task_info 获取
    // 使用该函数 传递的参数为integer_t类型的指针 task_info_t ，把数组转为这个指针
    kr = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)task_info_data, &task_info_count);
    if(kr != KERN_SUCCESS){
        return -1;
    }
    //**********************************************
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
    
    //函数方法 存放在 mach/thread_act.h 文件中
    //获取进程的mach task 函数
    kern_return_t task_info
    (
     task_name_t target_task,
     task_flavor_t flavor,//THREAD_BASIC_INFO指定这个类型 会输出thread_basic_info的线程
     task_info_t task_info_out,
     mach_msg_type_number_t *task_info_outCnt
     );
    
    //结构体信息一般存放在 mach/thread_info.h 中
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
    
    // 线程状态  通过指定的flavor 类型为x86_THREAD_STATE64  可以获取这个线程的状态
    kern_return_t thread_get_state
    (
     thread_act_t target_act,
     thread_state_flavor_t flavor,
     thread_state_t old_state,
     mach_msg_type_number_t *old_stateCnt
     );
    
//    thread_get_state(<#thread_act_t target_act#>, <#thread_state_flavor_t flavor#>, <#thread_state_t old_state#>, <#mach_msg_type_number_t *old_stateCnt#>)
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
