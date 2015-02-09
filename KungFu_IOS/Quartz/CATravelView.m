//
//  CATravelView.m
//  TextTravel
//
//  Created by ChildhoodAndy on 15/2/9.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "CATravelView.h"
#import "CACONSTS.h"

@interface CATravelView ()
{
    UILabel* helloTravelLabel;
    CGRect labelRect;
    NSTimer* timer;
    CGFloat posX;
}

@end

@implementation CATravelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        helloTravelLabel = [[UILabel alloc] init];
        helloTravelLabel.text = @"HelloTravel!";
        helloTravelLabel.backgroundColor = [UIColor clearColor];
        helloTravelLabel.textColor = [UIColor redColor];
        helloTravelLabel.font = [UIFont systemFontOfSize:18];
        helloTravelLabel.textAlignment = NSTextAlignmentCenter;

        labelRect = [helloTravelLabel textRectForBounds:CGRectMake(0, 0, 100, 30) limitedToNumberOfLines:1];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
        [timer fire];
        
        posX = 0;
    }
    
    return self;
}

- (void)timerTick:(NSTimer *)timerSender
{
    posX += 0.1;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [helloTravelLabel drawTextInRect:CGRectMake(posX, 200, 100, 30)];
    
    if (posX > kScreen_Width) {
        posX = 0 - labelRect.size.width;
    }
}

@end
