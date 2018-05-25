//
//  XFDToolCommonCell.m
//  XFDTToolsKit
//
//  Created by XDS on 2018/5/25.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import "XFDToolCommonCell.h"

@implementation XFDToolCommonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withFrame:(CGRect)frame
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.frame = frame;
        [self loadUI];
        [self cellLayout];
    }
    return self;
}

- (void)loadUI
{
    
}

- (void)cellLayout
{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
