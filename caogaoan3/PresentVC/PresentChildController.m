//
//  PresentChildController.m
//  caogaoan3
//
//  Created by XDS on 2018/5/14.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "PresentChildController.h"

@interface PresentChildController ()

{
    UIView *subView;
}
@end

@implementation PresentChildController

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * touch = touches.anyObject;
    
    CGPoint loca = [touch locationInView:self.view];
    if(CGRectContainsPoint(subView.frame, loca))
    {
        return;
    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (id)init {
    self = [super init];
    if(self){
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   

    subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    subView.center = CGPointMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height / 2.0f);
    subView.layer.cornerRadius = 10;
    subView.layer.masksToBounds = YES;
    subView.backgroundColor = [UIColor redColor];
    [self.view addSubview:subView];
    
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
