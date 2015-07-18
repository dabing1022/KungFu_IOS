//
//  CardView.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/7/18.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "CardView.h"

#define CardViewWidth  200
#define CardViewHeight 200
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)
static const CGFloat backgroundViewAlpha = 0.5;
@interface CardView () {
    UIView *backView;
    NSInteger rorateDirection;
}

@end

@implementation CardView

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        _leaveWay = CardViewLeaveWayLeft;
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        panGesture.minimumNumberOfTouches = 1;
        panGesture.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:panGesture];
    }
    
    return self;
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)show {
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - CardViewWidth) * 0.5, -CardViewHeight - 30, CardViewWidth, CardViewHeight);
    [topVC.view addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)removeFromSuperview {
    UIViewController *topVC = [self appRootViewController];
    
    [backView removeFromSuperview];
    CGRect lastFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - CardViewWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), CardViewWidth, CardViewHeight);
    
    [UIView animateWithDuration:0.5f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.frame = lastFrame;
        if (_leaveWay) {
            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
        }else {
            self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
        }
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        return;
    }
    
    UIViewController *topVC = [self appRootViewController];
    if (!backView) {
        backView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = backgroundViewAlpha;
    }
    [topVC.view addSubview:backView];
    self.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    CGRect lastFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - CardViewWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - CardViewHeight) * 0.5, CardViewWidth, CardViewHeight);
    [UIView animateWithDuration:0.5f
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = lastFrame;
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview:newSuperview];
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    UIView *v = recognizer.view;
    CGPoint translation = [recognizer translationInView:v];
    [recognizer setTranslation:CGPointZero inView:v];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint position =  [recognizer locationInView:v];
        rorateDirection = position.x > CGRectGetMidX(v.bounds) ? 1 : -1;
    } else if(recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat y = self.center.y + translation.y;
        self.center = CGPointMake(self.center.x, y);
        NSLog(@"translation y : %f", translation.y);
        
        float halfScreenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
        float ratio = self.center.y / halfScreenHeight;
        
        NSLog(@"ratio: %f", ratio);
        BOOL panDown = ratio > 0.5;
        if (panDown) {
            backView.alpha = backgroundViewAlpha - ratio * backgroundViewAlpha;
            backView.alpha = backgroundViewAlpha * (1 - ratio);
        } else {
            backView.alpha = backgroundViewAlpha * ratio;
        }
        
        CGFloat finalDegree = 45;
        CGFloat radian = DEGREES_TO_RADIANS(finalDegree) * (ratio - 0.5) * rorateDirection;
        v.transform = CGAffineTransformMakeRotation(radian);
    } else {
        [self panEnd];
    }
}

- (void)panEnd {
    if (fabs(self.center.y - CGRectGetHeight([UIScreen mainScreen].bounds) * 0.5) < 100) {
        [self dismiss];
    } else {
        [self resetPosition];
    }
}

- (void)resetPosition {
    [UIView animateWithDuration:0.3
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         backView.alpha = backgroundViewAlpha;
                         self.transform = CGAffineTransformMakeRotation(0);
                         self.center = CGPointMake(self.center.x, CGRectGetHeight([UIScreen mainScreen].bounds) * 0.5);
     } completion:^(BOOL finished) {
     }];
}


@end
