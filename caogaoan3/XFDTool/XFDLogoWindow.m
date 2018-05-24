//
//  XFDLogoWindow.m
//  caogaoan3
//
//  Created by gacao on 2018/5/24.
//  Copyright © 2018年 iFlytek_PIC. All rights reserved.
//

#import "XFDLogoWindow.h"

@interface XFDLogoWindow()
{
    CGPoint         _startPoint;
}
@property (nonatomic, strong) UIButton *logoBtn;
@end

@implementation XFDLogoWindow

- (id)initWithFrame:(CGRect)frame withDelegate:(id)logoDelegate
{
    self = [super initWithFrame:frame];
    if(self){
        _logoDelegate = logoDelegate;
        self.windowLevel = UIWindowLevelAlert + 1;
        self.hidden = NO;
        [self initLogo];
        [self makeKeyAndVisible];
    }
    return self;
}

- (void)initLogo
{
    [self addSubview:self.logoBtn];
}

- (UIButton *)logoBtn
{
    if(_logoBtn == nil){
        _logoBtn = [[UIButton alloc] initWithFrame:self.bounds];
        _logoBtn.backgroundColor = [UIColor blackColor];
        [_logoBtn setTitle:@"XFD" forState:UIControlStateNormal];
        [_logoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _logoBtn.layer.cornerRadius = 10.0f;
        _logoBtn.layer.masksToBounds = YES;
        _logoBtn.layer.borderColor = [UIColor grayColor].CGColor;
        _logoBtn.layer.borderWidth = 0.5;
        [_logoBtn addTarget:self action:@selector(onDetailedWindow:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat insert = (XFD_LOGO_WIDTH  - 40) / 2.0f;
        [_logoBtn setImageEdgeInsets:UIEdgeInsetsMake(insert, insert, insert, insert)];
        
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        recognizer.delegate = self;
        recognizer.maximumNumberOfTouches = 1;
        [_logoBtn addGestureRecognizer:recognizer];
    }
    return _logoBtn;
}
#pragma mark - 手势处理逻辑
-(void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint pt = [recognizer locationInView:self] ;
        _startPoint = pt;
        
    }
    if ((recognizer.state == UIGestureRecognizerStateChanged) || (recognizer.state == UIGestureRecognizerStateEnded)) {
        CGPoint pt = [recognizer locationInView:self];
        CGRect frame = [self frame];
        frame.origin.y += pt.y - _startPoint.y;
        frame.origin.x += pt.x - _startPoint.x;
        
        CGPoint offset = CGPointMake(pt.x - _startPoint.x, pt.y - _startPoint.y);
        [_logoDelegate handlePanOffset:offset state:recognizer.state];
    }
}


#pragma mark --按钮点击
- (void)onDetailedWindow:(UIButton *)btn
{
    if(_logoDelegate && [_logoDelegate respondsToSelector:@selector(onClickDetailWindow)]){
        [_logoDelegate onClickDetailWindow];
    }
    NSLog(@"logoBtn click");
}
@end
