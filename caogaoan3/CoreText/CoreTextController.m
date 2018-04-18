//
//  CoreTextController.m
//  caogaoan3
//
//  Created by XDS on 2018/3/19.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "CoreTextController.h"
#import "CTDisplayView.h"


@interface CoreTextController ()

@end

@implementation CoreTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CTDisplayView * view1 = [[CTDisplayView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view1];
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
