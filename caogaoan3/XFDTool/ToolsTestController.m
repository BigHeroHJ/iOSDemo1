//
//  ToolsTestController.m
//  caogaoan3
//
//  Created by XDS on 2018/5/24.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "ToolsTestController.h"
#import "XFDTTools.h"


@interface ToolsTestController ()

@end

@implementation ToolsTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    [XFDTTools create];
}
- (IBAction)clickShowTools:(UIButton *)sender {
    if([[XFDTTools create] getToolHidden])
    {
        [[XFDTTools create] setHidden:NO];
    }else{
        [[XFDTTools create] setHidden:YES];
    }
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
