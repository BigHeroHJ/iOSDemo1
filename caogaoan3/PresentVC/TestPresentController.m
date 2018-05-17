//
//  TestPresentController.m
//  caogaoan3
//
//  Created by XDS on 2018/5/14.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "TestPresentController.h"
#import "PresentChildController.h"


@interface TestPresentController ()

@end

@implementation TestPresentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 80, 80)];
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
 
}

- (void)click{
    PresentChildController *pc = [[PresentChildController alloc] init];
    [self presentViewController:pc animated:NO completion:nil];
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
