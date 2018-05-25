//
//  XFDToolCommonCell.h
//  XFDTToolsKit
//
//  Created by XDS on 2018/5/25.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFDToolCommonCell : UITableViewCell


/**
 提供给子类进行UI 添加
 */
- (void)loadUI;

/**
 提供给子类进行cell 内部布局
 */
- (void)cellLayout;

/**
 初始化方法

 @param style cell类型
 @param reuseIdentifier 重用标识
 @return cell 对象
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withFrame:(CGRect)frame;
@end
