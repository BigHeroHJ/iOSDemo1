//
//  XFDUtilityWindow.h
//  caogaoan3
//
//  Created by gacao on 2018/5/24.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XFDUtilityWindowDelegate <NSObject>
/**
 关闭详细工具界面
 */
- (void)onWindowClose;
@end

@interface XFDUtilityWindow : UIWindow

@property (nonatomic, weak) id <XFDUtilityWindowDelegate> XFDutilityDelegate;//代理对象

/**
 初始化方法

 @param frame frame 值
 @param XFDUtilityDelegate 设置代理
 @return self 对象
 */
- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id)XFDUtilityDelegate;

@end
