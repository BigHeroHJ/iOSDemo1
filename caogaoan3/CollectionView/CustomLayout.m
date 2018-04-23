//
//  CustomLayout.m
//  caogaoan3
//
//  Created by XDS on 2018/4/23.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "CustomLayout.h"


@interface CustomLayout()

@property (nonatomic, strong) NSMutableArray * maxHs;

@property (nonatomic, strong) NSMutableArray * cellAttrs;

@property (nonatomic, strong) NSMutableArray * columHeights;

@end



@implementation CustomLayout

- (NSMutableArray *)cellAttrs
{
    if(!_cellAttrs){
        _cellAttrs = [NSMutableArray array];
    }
    return _cellAttrs;
}

- (NSMutableArray *)columHeights
{
    if(!_columHeights)
    {
        _columHeights = [NSMutableArray array];
    }
    return _columHeights;
}

//预布局方法
-  (void)prepareLayout
{
  
}

@end
