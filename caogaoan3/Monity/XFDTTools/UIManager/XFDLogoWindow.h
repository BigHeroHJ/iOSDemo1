//
//  XFDLogoWindow.h
//  caogaoan3
//
//  Created by gacao on 2018/5/24.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFDTToolsDefine.h"

@protocol XFDLogoWindowDelegate <NSObject>
/**
 logo 点击
 */
- (void)onClickDetailWindow;

/**
 处理logo 手势代理方法
 @param offset 偏移量
 @param state 手势状态
 */
-(void)handlePanOffset:(CGPoint)offset state:(UIGestureRecognizerState)state;
@end

@interface XFDLogoWindow : UIWindow

/**
 图标按钮的代理
 */
@property (nonatomic, weak) id<XFDLogoWindowDelegate> logoDelegate;

/**
 初始化logo window

 @param frame window 窗口大小
 @param logoDelegate 代理设置
 @return self 对象
 */
- (id)initWithFrame:(CGRect)frame withDelegate:(id)logoDelegate;

@end
