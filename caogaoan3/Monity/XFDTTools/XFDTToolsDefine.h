//
//  XFDTToolsDefine.h
//  XFDTTools
//
//  Created by z0x0z on 2018/5/24.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#ifndef XFDTToolsDefine_h
#define XFDTToolsDefine_h

//logo界面样式相关
#define XFD_LOGO_HEIGHT  50.0f
#define XFD_LOGO_WIDTH  50.0f

#define XFD_CATEGORY_USERDEFAULT_KEY  @"CATORYUSERDEFAULT"
//全局界面相关
#define XFD_MAINSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define XFD_MAINSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define XFD_COLOR_WITH_HEX(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#endif /* XFDTToolsDefine_h */
