//
//  XFDPerformanceDetailController.m
//  XFDTToolsKit
//
//  Created by XDS on 2018/5/25.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import "XFDPerformanceDetailController.h"
#import "XFDToolCategoryCell.h"

@interface XFDPerformanceDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * performanceArray;// 小分类
@property (nonatomic, strong) UIButton *addButton;
@end

@implementation XFDPerformanceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self handleBarButtonItem];
}

// 处理 按钮多加一个
- (void)handleBarButtonItem
{
    UIBarButtonItem * barItem_done = self.navigationItem.rightBarButtonItem;
    //创建一个UIButton
    self.addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.addButton setTitle:@"添加到面板" forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:self.addButton];
    self.navigationItem.rightBarButtonItems = @[barItem_done,addItem];
}

#pragma mark --getter
- (NSArray *)performanceArray
{
    if(!_performanceArray){
        _performanceArray = nil;
       
    }
    return _performanceArray;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _tableView.rowHeight = 60.0f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark -- UITableViewDataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.performanceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XFDToolCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XFDToolCategoryCell"];
    if(!cell){
        cell = [[XFDToolCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XFDToolCategoryCell" withFrame:tableView.frame];
    }
    NSString *title = self.performanceArray[indexPath.row];
    cell.titleLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark --BarButtonItem 点击
- (void)addItemClick
{
    if(self.tableView.editing){
        self.tableView.editing = NO;
        [self.addButton setTitle:@"添加到面板" forState:UIControlStateNormal];
    }else{
        self.tableView.editing = YES;
        [self.addButton setTitle:@"完成添加" forState:UIControlStateNormal];
    }
}

@end
