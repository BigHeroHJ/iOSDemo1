//
//  PhotoBrowerTransition.h
//  caogaoan3
//
//  Created by XDS on 2018/5/7.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


typedef enum : NSUInteger {
    PhotoBrowerTransitionPresent,
    PhotoBrowerTransitionDismiss,
} PhotoBrowerTransitionType;

@interface PhotoBrowerTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) PhotoBrowerTransitionType transitionType;

/**
 *  显示的图片文件是 UIImage
 */
@property (nonatomic, strong) UIImage *image;

/**
 *  动画要显示的资源文件是本地文件
 */
@property (nonatomic, strong) PHAsset * asset;

/**
 * 显示的图片是一个地址
 */
@property (nonatomic, strong) NSURL * imageUrl;


@property (nonatomic, strong) UIImageView *showImageView;

@end
