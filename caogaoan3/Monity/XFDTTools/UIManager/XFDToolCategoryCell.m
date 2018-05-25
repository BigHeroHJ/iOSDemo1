//
//  XFDToolCategoryCell.m
//  XFDTToolsKit
//
//  Created by XDS on 2018/5/25.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import "XFDToolCategoryCell.h"

const static CGFloat space = 10.0f;

@interface XFDToolCategoryCell()
@end

@implementation XFDToolCategoryCell

- (void)loadUI
{
    [super loadUI];
    // self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:18.0f];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleLabel];
    
    _multiChooseBtn = [[UIButton alloc] init];
    _multiChooseBtn.hidden = YES;
    [_multiChooseBtn setBackgroundImage:[UIImage imageNamed:@"gt_checkbox"] forState:UIControlStateNormal];
    [self.contentView addSubview:_multiChooseBtn];
}

- (void)layoutSubviews
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    self.selectedBackgroundView = v;
    _multiChooseBtn.frame = CGRectMake(self.frame.size.width - 50, self.frame.size.height / 2.0f - 12, 24.0f, 24.0f);
    _titleLabel.frame = CGRectMake(space, space, self.frame.size.width - 70, 30);
}

- (void)cellLayout
{
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if(highlighted){
        self.backgroundColor = [UIColor colorWithRed:71.0f / 255.0f green:59.0f / 255.0f blue:59.0f / 255.0f alpha:1];
    }else{
        self.backgroundColor = [UIColor colorWithRed:90.0f / 255.0f green:70.0f / 255.0f blue:70.0f / 255.0f alpha:1];
    }
}

@end
