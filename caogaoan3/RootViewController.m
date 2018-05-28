//
//  RootViewController.m
//  caogaoan3
//
//  Created by XDS on 2018/4/16.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "RootViewController.h"
#import "ArchiveCopyController.h"
#import "GCDViewController.h"
#import "CollectionView/CollectionViewController.h"
#import "RILIViewController.h"
#import "PHViewController.h"
#import "TestPresentController.h"
#import "BLEViewController.h"
#import "MonityViewController.h"



@interface RootViewController ()
@property (nonatomic, strong) NSArray * dataArray;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSArray arrayWithObjects:@"Runtime自动归档",@"GCD",@"RAC+MVVM",@"IMUI",@"GPUImage",@"消息转发机制",@"CollectionView",@"RIL",@"PH",@"presentOverFullScreen",@"BLE",@"MonityVC",@"ToolsXFD",nil];
    [self testWeiYunSuan];
}

- (void)testWeiYunSuan
{
    int temp = 1024 ;
    NSLog(@"输出十六进制位:%x -- 对应的二进制位数：%2o",temp,temp);
    NSLog(@"第一位 %d",temp & 0xff);
    NSLog(@"第二位 %d",temp >> 8 & 0xff);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [super tableView:tableView didDeselectRowAtIndexPath:indexPath];
    if(indexPath.row == 0){
        
        ArchiveCopyController * vc = [ArchiveCopyController new ];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 1){
        
        GCDViewController * gdcVC = [GCDViewController new];
        [self.navigationController pushViewController:gdcVC animated:YES];
        
    }else if (indexPath.row == 6){
        
        CollectionViewController * collecVC = [[CollectionViewController alloc] init];
        [self.navigationController pushViewController:collecVC animated:YES];
        
    }else if(indexPath.item == 7){
        
        RILIViewController * collecVC = [[RILIViewController alloc] init];
        [self.navigationController pushViewController:collecVC animated:YES];
        
    }else if(indexPath.item == 8){
        
        PHViewController * collecVC = [[PHViewController alloc] init];
        [self.navigationController pushViewController:collecVC animated:YES];
        
    }else if(indexPath.item == 9){
        
        TestPresentController * testPresentVC = [TestPresentController new];
        [self.navigationController pushViewController:testPresentVC animated:YES];
    }else if(indexPath.item == 10){
        BLEViewController * bleVC = [[BLEViewController alloc] init];
        [self.navigationController pushViewController:bleVC animated:YES];
    }else if (indexPath.row == 11){
        MonityViewController * monityVC = [[MonityViewController alloc] init];
        [self.navigationController pushViewController:monityVC animated:YES];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
