//
//  ArchiveCopyController.m
//  caogaoan3
//
//  Created by XDS on 2018/4/16.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "ArchiveCopyController.h"
#import "Person.h"
#import "ArchiverTool.h"
#import <AFNetworking.h>

@interface ArchiveCopyController ()
{
    Person * p1;
}
@property(nonatomic, strong)UIButton *button;

@end

@implementation ArchiveCopyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    p1 = [[Person alloc] init];
    p1.name = @"cga";
    p1.age  = @"20";
    
    Person *p2 = [p1 copy];
    
    [p1 addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW , 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        p1.name = @"234324";
    });
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(30, 50, 50, 30)];
    [self.button setTitle:@"测试" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button.layer.borderWidth = 1.0f;
    [self.view addSubview:self.button];
    
    //注册监听button的enabled状态
    [self.button addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:@"test_button"];
    
    //  3秒钟后改变当前button的enabled状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.button.enabled = YES;
    });
    NSLog(@"p1:%@---p2%@",p1.description,p2.description);
    
    ArchiverTool * tool = [ArchiverTool shareInstance];
    //[tool EncodeObjectWith:p1 aCoder:p1.classForCoder];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    
    [manager GET:@"https://www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"name"]){
        id value = change[NSKeyValueChangeNewKey];
        NSLog(@"person对象的新value%@",value);
    }
    UIButton *button = (UIButton *)object;

    if (self.button == button && [@"enabled" isEqualToString:keyPath]) {
        NSLog(@"self.button的enabled属性改变了%@",[change objectForKey:@"new"]);
    }
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
