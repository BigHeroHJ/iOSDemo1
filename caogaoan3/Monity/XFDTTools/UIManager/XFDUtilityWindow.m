//
//  XFDUtilityWindow.m
//  caogaoan3
//
//  Created by gacao on 2018/5/24.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//  

#import "XFDUtilityWindow.h"
#import "XFDDetailViewController.h"

@implementation XFDUtilityWindow

- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id)XFDUtilityDelegate
{
    self = [super initWithFrame:frame];
    if(self){
        self.XFDutilityDelegate = XFDUtilityDelegate;
        [self addViewController];
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 200;
    }
    return self;
}

#pragma mark -- 界面相关
- (void)addViewController
{
    XFDDetailViewController * baseVC = [[XFDDetailViewController alloc] init];
    UINavigationController * navVC = [[UINavigationController alloc] init];
    [navVC setViewControllers:@[baseVC]];
    __weak typeof(self) weakSelf = self;
    baseVC.dimissUtilityBlock = ^{
      //这里收回 工具界面回到logo
        if(weakSelf.XFDutilityDelegate && [weakSelf.XFDutilityDelegate respondsToSelector:@selector(onWindowClose)]){
            [weakSelf.XFDutilityDelegate onWindowClose];
        }
    };
    [self setRootViewController:navVC];
    [self makeKeyAndVisible];
}
@end
