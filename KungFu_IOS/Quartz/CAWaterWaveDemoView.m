//
//  CAWaterWaveDemoView.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/3/11.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "CAWaterWaveDemoView.h"

@interface CAWaterWaveDemoView ()
{
    UIColor* waterColor;
    
    CGFloat linePointY;
    
    CGFloat circleTimeDelta;     // 纵向波浪点的正弦周期改变的偏差值
    CGFloat waveSinAmplitude;    // 纵向波浪点的正弦周期的振幅，外观表现为波浪上下振动的幅度
    CGFloat waveVibrationSpeed;  // 波浪上下振荡速度，修改其值大小从外观上影响波浪的速度
    
    CADisplayLink* displayLink;
}

@end

@implementation CAWaterWaveDemoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        waterColor = [UIColor colorWithRed:64.0/255.0f green:164.0/255.0f blue:245.0/255.0f alpha:1];
        
        linePointY = kScreen_CenterY;
        circleTimeDelta = 0;
        waveSinAmplitude = 1.5;
        waveVibrationSpeed = 0.3;
        
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWaveData:)];
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [displayLink invalidate];
    }
}

- (void)updateWaveData:(CADisplayLink *)dLink
{
    circleTimeDelta += waveVibrationSpeed;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGContextSetFillColorWithColor(context, waterColor.CGColor);
    
    CGPathMoveToPoint(path, NULL, 0, linePointY);
    CGFloat y = linePointY;
    for(CGFloat x = 0; x <= kScreen_Width; x++){
        y = waveSinAmplitude * sin( x / 180 * M_PI + circleTimeDelta) * 5 + linePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, kScreen_Width, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, linePointY);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathFill);
    CGPathRelease(path);
}

@end
