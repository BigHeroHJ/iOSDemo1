//
//  PHBrower.m
//  caogaoan3
//
//  Created by XDS on 2018/5/7.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "PHBrower.h"

@interface PHBrower()
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray * items;
@end


@implementation PHBrower

- (id)initWithFrame:(CGRect)frame items:(NSMutableArray * )items currentIndex:(NSInteger) index
{
    self = [super initWithFrame:frame];
    if(self){
        self.currentIndex = index;
        self.items = items;
    }
    return self;
}

@end
