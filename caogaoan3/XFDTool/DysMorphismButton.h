//
//  DysMorphismButton.h
//  TLZGXXMK
//
//  Created by cga on 2018/5/24.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DysmorphismButtonBlock)();

@interface DysmorphismButton : UIButton

@property(nonatomic, assign) CGFloat topMargin;

@property(nonatomic,copy)DysmorphismButtonBlock  dysmorphismButtonBlock;

-(void)dysmorphismButtonShownInView:(UIView*)view imageName:(NSString*)imageName dysmorphismButton:(DysmorphismButtonBlock)dysmorphismButtonBlock;

@end
