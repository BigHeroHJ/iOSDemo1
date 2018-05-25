//
//  XFDShowParamCell.m
//  XFDTToolsKit
//
//  Created by XDS on 2018/5/25.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import "XFDShowParamCell.h"

const static  CGFloat space = 10.0f;

@interface XFDShowParamCell()
@property (nonatomic, strong) UIView *backgroudView;
@end

@implementation XFDShowParamCell

- (void)loadUI
{
    [super loadUI];
    //self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _backgroudView = [[UIView alloc] init];
    _backgroudView.backgroundColor = [UIColor colorWithRed:98.0f / 255.0f green:87.0f / 255.0f blue:87.0f / 255.0f alpha:1];
    _backgroudView.layer.cornerRadius = 10.0f;
    _backgroudView.layer.masksToBounds = YES;
    [self.contentView addSubview:_backgroudView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:18.0f];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.text = @"CPU";
    [_backgroudView addSubview:_titleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _backgroudView.frame = CGRectMake(space, space, self.contentView.frame.size.width - 2 * space, self.contentView.frame.size.height -  2 *space);
    _titleLabel.frame = CGRectMake(space, space, self.contentView.frame.size.width - 70, 30);
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.contentView.frame.size.width - 2 * 5, self.contentView.frame.size.height -  2 *5)];
    self.selectedBackgroundView = v;
}

- (void)cellLayout
{
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted: highlighted animated:animated];
    if(highlighted){
        _backgroudView.backgroundColor = [UIColor colorWithRed:124.0f/255.0f green:68.0f / 255.0f blue:68.0f / 255.0f alpha:1];
    }
}

@end
