//
//  CTDisplayView.m
//  caogaoan3
//
//  Created by XDS on 2018/3/19.
//  Copyright © 2018年 MountainX. All rights reserved.
//

#import "CTDisplayView.h"
#import <CoreText/CoreText.h>

@implementation CTDisplayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1, 1));
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddRect(pathRef, NULL, self.bounds);
//    CGPathAddArc(pathRef, NULL, 50, 50, 30, 0, 360, YES);
    NSAttributedString * attriStr = [[NSAttributedString alloc] initWithString:@"core text 的 第一次排版"];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attriStr);
    CTFrameRef framref = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attriStr length]), pathRef, NULL);
    
    CTFrameDraw(framref, context);
    
    
    CFRelease(framref);
    CFRelease(pathRef);
    CFRelease(framesetter);
}
@end
