//
//  PHManager.h
//  caogaoan3
//
//  Created by XDS on 2018/5/7.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PHManager : NSObject
+ (instancetype)shareInstace;

/**
 * 获取智能相册
 */
- (PHFetchResult *)getsmartResult;

/**
 * 获取用户创建的相册
 */
- (PHFetchResult *)getUserCreatResult;


@end
