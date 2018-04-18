//
//  RACController.m
//  caogaoan3
//
//  Created by XDS on 2018/3/19.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "RACController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RACController ()

@end

@implementation RACController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self test1];
    [self test2];
    [self test3];
}
- (void)test3
{
    //map  mapreplace
    
    // reduceEach 只对元祖
    // not and or reduceApply
    // materialize dematerialize
    RACTuple *tuple1 = RACTuplePack(@1,@3,@10);

    //filter  ignore
    //take  skip
    // startwith repeat retry
    //collect 收集
    //Throttle 阀门
    
    [[self rac_signalForSelector:@selector(viewDidAppear:)] mapReplace:@YES];
    
}
- (void)test2
{
    //创建信号 单元信号
    RACSignal * s1 = [RACSignal return:@1];
    s1 = [RACSignal never];
    s1 = [RACSignal error:nil];
    s1 = [RACSignal empty];
    
    RACSignal * s2 = [[[s1 map:^id(id value) {
        return @8;
    }] aggregateWithStart:@0 reduce:^id(id running, id next) {
        return @([running intValue] + [next intValue]);
    }] scanWithStart:@1 reduce:^id(id running, id next) {
        return @([running intValue] + [next intValue]);
    }];
    
    
    RACSignal *s3 = [s2  mapReplace:@10];
    
    RAC(self.view,backgroundColor) = s1;
    //RACTuple
    RACTuple *tuple1 = RACTuplePack(@1,@3,@10);
    NSLog(@"tuple1.first is %@",tuple1.first);
    NSLog(@"tuple1.second is %@",tuple1.second);
    NSLog(@"tuple1.third is %@",tuple1.third);
    
    //tuple 下面也能去除对应的值
    RACTupleUnpack(NSNumber *number,NSNumber * number1,NSNumber *number2) = tuple1;
    
    
    //push drive 不是使用者决定的
    //pull drive 由使用者决定
    
     // cocoa 连接
    [self.view rac_liftSelector:@selector(convertRect:toView:) withSignals:s1,s2,nil];//等等
    //s1 s2 -》params
}
- (void)test1{
    //这个是创建动态信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendError:nil];//error后 completed 失效了
        [subscriber  sendCompleted];
//        return nil;
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"---");
        }];
    }];
    
    RACDisposable * dispose = [signal subscribeNext:^(id x) {
        NSLog(@"next is %@",x);
    } error:^(NSError *error) {
        NSLog(@"error %@ ",error);
    } completed:^{
        NSLog(@"finished");
    }];
    
    [dispose dispose];
}
int Max(int * array,int count){
    if(count < 1) return INT_MIN;
    if(count == 1)return array[0];
    int maxH = Max(array, count - 1);
    return maxH > array[count - 1] ? maxH : array[count - 1];
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
