//
//  Runtime_weak.m
//  caogaoan3
//
//  Created by XDS on 2018/4/24.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "Runtime_weak.h"



@implementation Runtime_weak
- (id)init
{
    
    return self;
}


- (void)test{
    NSObject *obj = [[NSObject alloc] init];
    
   id __weak obj1 = [obj copy];
    
   id __strong obj2 = obj1;
    
}
@end
