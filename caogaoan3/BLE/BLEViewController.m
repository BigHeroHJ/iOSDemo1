//
//  BLEViewController.m
//  caogaoan3
//
//  Created by XDS on 2018/5/17.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "BLEViewController.h"
#import "BLEManager.h"
#import <ReactiveCocoa.h>
#import "BlePeripheral.h"



@interface BLEViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, strong) BLEManager * manager;

@end

@implementation BLEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
//    __weak typeof(self) weakSelf = self;
    
    [RACObserve(self.manager,connectState) subscribeNext:^(NSNumber * value) {
        NSLog(@"----------test cga -------%d",value.intValue);

        if(value.intValue == kBleConnectStatePoweredOn){
            [self.manager startScan];
        }else{
            [self.manager endScan];
        }
    }];
 
    @weakify(self)
    self.manager.scanResultBlock = ^(NSArray *peripherals, NSError *error) {
        [peripherals enumerateObjectsUsingBlock:^(BlePeripheral * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self)
            NSLog(@"service name %@",obj.peripheral.name);
            [self.dataArray addObject:obj];
            [self.tableView reloadData];
        }];
    };
    
    [self.manager startScan];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}

- (UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (BLEManager *)manager
{
    if(_manager == nil){
        _manager = [[BLEManager alloc] init];
    }
    return _manager;
}

#pragma mark -- UITableViewDataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [[(BlePeripheral *)self.dataArray[indexPath.row] peripheral] name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
//
//- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
//    <#code#>
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    <#code#>
//}
//
//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    <#code#>
//}
//
//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    <#code#>
//}
//
//- (void)setNeedsFocusUpdate {
//    <#code#>
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    <#code#>
//}
//
//- (void)updateFocusIfNeeded {
//    <#code#>
//}
//

@end
