//
//  XFDTCpuDetailViewController.m
//  XFDTToolsKit
//
//  Created by XDS on 2018/5/29.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import "XFDTCpuDetailViewController.h"
#import "XFDTChartView.h"
#import "XFDTCavsObj.h"
#import "XFDTChartConfig.h"

@interface XFDTCpuDetailViewController ()<XFDTChartViewDatasource>
{
   __block NSInteger  historyCount;//记录 从开始到结束的 采集个数
}
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray *dataBuf;//当前所需要的数据
@property (nonatomic, strong) NSMutableArray *xAxisTexts;//当前所需要x轴 上显示的 变化的坐标
@property (nonatomic, strong) NSMutableArray *yAxisTexts;//当前 y 轴上显示的变化的坐标

@property (nonatomic, strong) dispatch_queue_t observerQueue;
@property (nonatomic, strong) XFDTChartView * chartView;
@end

@implementation XFDTCpuDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    self.dataBuf = [NSMutableArray array];
    self.xAxisTexts = [NSMutableArray array];
    self.yAxisTexts = [NSMutableArray array];
    
    self.observerQueue = dispatch_queue_create("com.xfdttool.observerTick", 0);
    self.chartView = [[XFDTChartView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 400)];
    self.chartView.center = CGPointMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height / 2.0f);
    self.chartView.dataSource = self;
    [self.view addSubview:self.chartView];

    __weak typeof(self) weakSelf = self;
    
//    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
//    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 10 * 1000000);
//    dispatch_source_set_event_handler(timer, ^{
//                NSDate * date = [NSDate date];
//                XFDTCavsObj * obj = [[XFDTCavsObj alloc] init];
//                obj.date = date;
//                obj.dateText = [dateFormate stringFromDate:date];
//                obj.cavsValue = arc4random() % 100;
//                [weakSelf.dataArray addObject:obj];
//                self->historyCount ++;
//                [chartView updateData];
//    });
//    dispatch_resume(timer);
    
     [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(handleTick) userInfo:nil repeats:YES];
    
}
- (void)handleTick
{
    NSDateFormatter * dateFormate =  [[NSDateFormatter alloc] init];
    dateFormate.dateFormat = @"hh:mm:ss";
    NSDate * date = [NSDate date];
    XFDTCavsObj * obj = [[XFDTCavsObj alloc] init];
    obj.date = date;
    obj.dateText = [dateFormate stringFromDate:date];
    obj.cavsValue = arc4random() % 100;
    [self.dataArray addObject:obj];
    self->historyCount ++;
    [self.chartView updateData];
}

#pragma mark -- XFDTChartViewDatasource
- (id)chartDatas
{
    if(!historyCount) return @[];
    if(historyCount < XFDVISIABLE_COUNT)
    {
        [self.dataBuf addObject:self.dataArray.lastObject];
    }else{
        [self.dataBuf removeObjectAtIndex:0];
        [self.dataBuf addObject:self.dataArray.lastObject];
    }
    return self.dataBuf;
}

- (id)chartXAxisTexts
{
    [self.xAxisTexts removeAllObjects];
    for (int i = 0; i < self.dataBuf.count; i++) {
        if(i % 4 == 0){
            NSLog(@"时间点%@",[self.dataBuf[i] dateText]);
            XFDTCavsObj *obj = self.dataBuf[i];
            [self.xAxisTexts addObject:obj.dateText];
        }
    }
    return self.xAxisTexts;
}

//- (id)chartYAxisTexts
//{
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
