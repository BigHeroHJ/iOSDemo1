//
//  XFDDetailViewController.m
//  caogaoan3
//
//  Created by XDS on 2018/5/24.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "XFDDetailViewController.h"
#import "XFDToolCategoryCell.h"
#import "XFDTToolsDefine.h"
#import "XFDShowParamCell.h"
#import "XFDPerformanceDetailController.h"
#import "XFDShowParamManager.h"

@interface XFDDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray *categoryDataArray;//显示 大类数组
@property (nonatomic, strong) NSArray *showParamsArray;//显示在上方面板的数据// 将选中的参数 存到NSUserdefault 中 随时修改
@end

@implementation XFDDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}
- (NSArray *)categoryDataArray
{
    if(!_categoryDataArray){
        _categoryDataArray = [NSArray arrayWithObjects:@"程序日志",@"性能监控",@"沙盒文件", nil];
    }
    return _categoryDataArray;
}
- (NSArray *)showParamsArray
{
    if(!_showParamsArray){
        _showParamsArray = [NSArray array];
    }
   _showParamsArray = [XFDShowParamManager shareInstance].showParams;
    return _showParamsArray;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        //[_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark -- UITableViewDataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section){
        return self.categoryDataArray.count;
    }else{
        return self.showParamsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        XFDShowParamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(!cell){
            cell = [[XFDShowParamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XFDShowParamCell" withFrame:_tableView.frame];
        }
        XFDParamsObj *obj = self.showParamsArray[indexPath.row];
        cell.titleLabel.text = obj.categoryName;
        return cell;
    }else{
        XFDToolCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(!cell){
            cell = [[XFDToolCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XFDToolCategoryCell" withFrame:_tableView.frame];
        }
        NSString *title = self.categoryDataArray[indexPath.row];
        cell.titleLabel.text = title;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section){
        return 60.0f;
    }else{
        return 100.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 30)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:17.0f];
    if(section){
        label.text = @"Detail Params";
    }else{
        label.text = @"Show Parmas";
    }
    return  label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XFDPerformanceDetailController *performancesVC = [[XFDPerformanceDetailController alloc] init];
    [self.navigationController pushViewController:performancesVC animated:NO];
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
