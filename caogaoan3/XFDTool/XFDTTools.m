//
//  XFDTTools.m
//  XFDTTools
//
//  Created by z0x0z on 2018/5/24.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import "XFDTTools.h"
#import "XFDLogoWindow.h"
#import "XFDUtilityWindow.h"


@interface XFDTTools()<XFDLogoWindowDelegate,XFDUtilityWindowDelegate>
{
    CGRect   _logoLastFrame;//logo 按钮上一次的位置
}
@property (nonatomic, strong) XFDLogoWindow *logoWindow;//logo
@property (nonatomic, strong) XFDUtilityWindow *utilityWindow;//工具集界面

@end

@implementation XFDTTools

@synthesize hidden = _hidden;

/**
 * 初始化XFDTTools
 */
+ (instancetype)create
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if(self){
        _logoWindow = [[XFDLogoWindow alloc] initWithFrame:CGRectMake(80, 100, XFD_LOGO_WIDTH, XFD_LOGO_HEIGHT) withDelegate:self];
        self.hidden = YES;
        
        _utilityWindow = nil;
    }
    return self;
}
#pragma mark --setter & getter
- (void)setHidden:(BOOL)hidden
{
    _hidden = hidden;
    if(hidden){
        _logoWindow.hidden = YES;
    }else{
        _logoWindow.hidden = NO;
        [self layoutLogoFrame];
    }
}

- (BOOL)getToolHidden
{
    return _hidden;
}
/**
 * 是否显示悬浮入口
 */
- (void)showEntry:(BOOL)isShow
{
    [self setHidden:isShow];
}

/**
 * 展开XFDTTools详细面板
 */
+ (void)expandToolsPannel
{
    
}

/**
 * 收起XFDTTools详细面板
 */
+ (void)packupToolsPannel
{
    
}

/**
 * 销毁XFDTTools
 */
+ (void)destroy
{
    
}

#pragma mark -- XFDUtilityDelegate 方法
- (void)onWindowClose
{
  //关闭工具详情的界面 回到logo
    if(_utilityWindow){
        _utilityWindow = nil;
        _logoWindow.hidden = NO;
         [_logoWindow setFrame:CGRectMake(_logoLastFrame.origin.x, _logoLastFrame.origin.y, XFD_LOGO_WIDTH, XFD_LOGO_WIDTH)];
        [self layoutLogoFrame];
    }
}

#pragma mark -- logoWindow 手势代理方法处理
- (void)handlePanOffset:(CGPoint)offset state:(UIGestureRecognizerState)state
{
   CGRect frame = CGRectOffset(_logoWindow.frame, offset.x, offset.y);
    [_logoWindow setFrame:CGRectMake(frame.origin.x, frame.origin.y, XFD_LOGO_WIDTH, XFD_LOGO_HEIGHT)];
    
    if (state == UIGestureRecognizerStateEnded) {
        [self layoutLogoFrame];//停止后判断吸附
    }
}

- (void)onClickDetailWindow {
    _logoLastFrame = _logoWindow.frame;
    _logoWindow.hidden = YES;
    if(_utilityWindow){
        _utilityWindow.hidden = NO;
    }else{
        _utilityWindow = [[XFDUtilityWindow alloc] initWithFrame:CGRectMake(0, 0, XFD_MAINSCREEN_WIDTH, XFD_MAINSCREEN_HEIGHT) withDelegate:self];
        _utilityWindow.hidden = NO;
    }
}

- (void)layoutLogoFrame
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelay:0.0f];
    [UIView setAnimationDelegate:self];
    
    CGRect frame = _logoWindow.frame;
    
    if(frame.origin.y < 0){
        frame.origin.y = 0;
    }
    if (frame.origin.x  < (([UIScreen mainScreen].bounds.size.width - XFD_LOGO_WIDTH)/2) ) {
        frame.origin.x = 0.0f;
    } else {
        frame.origin.x = [UIScreen mainScreen].bounds.size.width - XFD_LOGO_WIDTH;
    }
    if (frame.origin.y > [UIScreen mainScreen].bounds.size.height - XFD_LOGO_HEIGHT)
    {
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - XFD_LOGO_HEIGHT;
    }
    
    [_logoWindow setFrame:CGRectMake(frame.origin.x, frame.origin.y, XFD_LOGO_WIDTH, XFD_LOGO_HEIGHT)];
    
    [UIView commitAnimations];
}
@end
