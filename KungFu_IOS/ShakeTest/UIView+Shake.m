//
//  UIView+Shake.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/7/18.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "UIView+Shake.h"

@implementation UIView (Shake)

- (void)shakeWithDefaultTimes {
    [self shakeWithTimes:4];
}

- (void)shakeWithTimes:(float)times {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.05];
    [animation setRepeatCount:times];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake(self.center.x - 20.0f, self.center.y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake(self.center.x + 20.0f, self.center.y)]];
    [self.layer addAnimation:animation forKey:@"shake"];
}

@end
