//
//  PhotoBrowerController.h
//  caogaoan3
//
//  Created by XDS on 2018/5/7.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBrowerController : UIViewController
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray * items;

- (instancetype)initWithItems:(NSMutableArray * )items currentIndex:(NSInteger) currentIndex;

@end
