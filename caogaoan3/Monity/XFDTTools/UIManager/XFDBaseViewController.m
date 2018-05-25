//
//  XFDBaseViewController.m
//  caogaoan3
//
//  Created by XDS on 2018/5/24.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "XFDBaseViewController.h"
#import "XFDDetailViewController.h"

@interface XFDBaseViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation XFDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.view addSubview:self.tableView];
    
    //创建一个UIButton
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton setTitle:@"LOGO" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.rightBarButtonItem = backItem;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

#pragma mark --返回
- (void)backItemClick
{
    if(self.dimissUtilityBlock){
        self.dimissUtilityBlock();
    }else{
        if(self.navigationController.viewControllers.count > 1){
        XFDDetailViewController *firstVc = (XFDDetailViewController *)self.navigationController.viewControllers.firstObject;
            firstVc.dimissUtilityBlock();
        }
    }
    
}

@end
