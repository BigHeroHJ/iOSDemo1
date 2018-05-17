//
//  PhotoBrowerTransition.m
//  caogaoan3
//
//  Created by XDS on 2018/5/7.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "PhotoBrowerTransition.h"

@implementation PhotoBrowerTransition

#pragma mark - 懒加载
- (UIImageView *)showImageView
{
    if (!_showImageView)
    {
        _showImageView = [[UIImageView alloc] init];
        _showImageView.backgroundColor = [UIColor whiteColor];
        //        _showImageView.image = [UIImage imageNamed:self.imageNameArray[self.currentIndex]];
        _showImageView.contentMode = UIViewContentModeScaleAspectFill;
        _showImageView.layer.masksToBounds = YES;
    }
    return _showImageView;
}


- (void)setAsset:(PHAsset *)asset
{
    _asset = asset;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
}

- (void)setImageUrl:(NSURL *)imageUrl
{
    _imageUrl = imageUrl;
}

/**
 * 返回专场时间
 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

//present 和dismiss 的动画
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if(self.transitionType == PhotoBrowerTransitionPresent){
        
        UIView * containView = [transitionContext containerView];
        
        //from vc
        UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        
        [containView addSubview:toVC.view];
       // toVC.view.backgroundColor = [UIColor redColor];
        
        if(self.asset){
            //获取对应的资源
            PHCachingImageManager * imageManager = [[PHCachingImageManager alloc] init];
            float originWidth = self.asset.pixelWidth;
            float originHeight = self.asset.pixelHeight;
            float originRadio = originWidth / originHeight;
            
            float showWidth  = 0;
            float showHeight = 0;
            if(originWidth <= toVC.view.frame.size.width * [UIScreen mainScreen].scale){
                showWidth = originWidth;
                showHeight = originHeight;
            }else{
                showWidth = toVC.view.frame.size.width;
                showHeight =  toVC.view.frame.size.width / originRadio;
            }
            [containView addSubview:self.showImageView];

            self.showImageView.frame = CGRectMake(100, 200, 2, 2);
            
            [imageManager requestImageForAsset:self.asset targetSize:CGSizeMake(showWidth, showHeight) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                self.showImageView.image = result;
                
                self.showImageView.hidden = YES;
                
                [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:10 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    
                    self.showImageView.hidden = NO;
                    self.showImageView.frame = CGRectMake(0, 0, showWidth, showHeight);
                    self.showImageView.center = CGPointMake(toVC.view.frame.size.width / 2.0f, toVC.view.frame.size.height / 2.0f);
                    
                } completion:^(BOOL finished) {
                    self.showImageView.hidden = YES;
                    [transitionContext completeTransition:YES];
                }];
                
            }];
            
        }else if (self.image){
            
        }else if (self.imageUrl){
            
        }else{
            NSAssert(NO, @"动画开始需要设置一个资源");
        }
        
    }else if (self.transitionType == PhotoBrowerTransitionDismiss){
        
        
        
    }
}
@end
