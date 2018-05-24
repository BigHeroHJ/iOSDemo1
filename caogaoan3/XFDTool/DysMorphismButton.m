//
//  DysMorphismButton.m
//  TLZGXXMK
//
//  Created by cga on 2018/5/24.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#define kButtonXoffset 7
#define topNavInsetHeight 64

#define topNavInsetHeight 64
#define dyButtonWidth  54
#define dyButtonHeight  54
#define dyButtonMargin 10

#import "DysMorphismButton.h"

@implementation DysmorphismButton{
     UIButton *dyButton;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
        [self addGestureRecognizer:tap];
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handelPan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

-(void)dysmorphismButtonShownInView:(UIView*)view imageName:(NSString*)imageName dysmorphismButton:(DysmorphismButtonBlock)dysmorphismButtonBlock{
    
     self.dysmorphismButtonBlock = dysmorphismButtonBlock;
    
    //UIImage *bgImage = [UIImage imageNamed:imageName];
    UIColor * segColor = [UIColor colorWithRed:48/255.0f green:162/255.0f blue:252/255.0f alpha:1];
//    if(color != nil && ![color isEqualToString:@""]){
//       // segColor = [UIColor colorWithHexString:color];
//    }
    self.backgroundColor = segColor;
  //[self setImage:bgImage forState:UIControlStateNormal];
    [self setTitle:imageName forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
   // [self setBackgroundImage:[UIImage imageNamed:@"timg"] forState:UIControlStateNormal];
    self.frame =
    CGRectMake(view.frame.size.width - dyButtonWidth - dyButtonMargin, dyButtonMargin + topNavInsetHeight, dyButtonWidth , dyButtonHeight);
    self.topMargin = dyButtonMargin;
    self.layer.cornerRadius = dyButtonWidth / 2.0f;
    self.clipsToBounds = YES;
    //self.backgroundColor = [UIColor clearColor];
    self.layer.borderWidth = 0;
//    self.layer.borderColor = RGB(21, 38, 120).CGColor;
    dyButton = self;
    [view addSubview:dyButton];
    
}

//点击手势的响应方法
-(void)tapGesture{
    if (self.dysmorphismButtonBlock != nil) {
        self.dysmorphismButtonBlock();
    }
    

}

//滑动手势的方法
-(void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer{

    CGPoint currentPosition= [gestureRecognizer locationInView:self.superview];
    //悬浮不能滑到view外面
//    if (currentPosition.y > 22) {
//
         [self setCenter:currentPosition];
//    }

   
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        [self handleButtonMoveEndEvent];
        
        
    }
}

//当拖动结束时候让悬浮框靠边
- (void)handleButtonMoveEndEvent {
    
    if ( self.center.y<= dyButtonWidth/2) {
        //偏移动画
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:.5];
        [UIView setAnimationDelegate:self];
        self.frame = CGRectMake(self.superview.frame.size.width - self.frame.size.width - kButtonXoffset, 0.f+kButtonXoffset, self.frame.size.width, self.frame.size.height);
        //提交UIView动画
        [UIView commitAnimations];

    }else if (self.center.y > self.superview.frame.size.height-dyButtonWidth/2){
        
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:.5];
        [UIView setAnimationDelegate:self];
        self.frame = CGRectMake(0.f + kButtonXoffset, self.superview.frame.size.height-dyButtonWidth-kButtonXoffset, self.frame.size.width, self.frame.size.height);
        //提交UIView动画
        [UIView commitAnimations];

    }
    
    if (self.center.x >= self.superview.frame.size.width / 2) {  //向右侧移动
        //偏移动画
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:.5];
        [UIView setAnimationDelegate:self];
        self.frame = CGRectMake(self.superview.frame.size.width - self.frame.size.width - kButtonXoffset, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        //提交UIView动画
        [UIView commitAnimations];
    } else {  //向左侧移动
        
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:.5];
        [UIView setAnimationDelegate:self];
        self.frame = CGRectMake(0.f + kButtonXoffset, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        //提交UIView动画
        [UIView commitAnimations];
    }
    
//    NSLog(@"button_x=%f,button_y=%f",self.frame.origin.x,self.frame.origin.y);
}
@end

