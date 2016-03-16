//
//  BlockTestView.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/4/8.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "BlockTestView.h"

@implementation NSTimer (Block)

+ (NSTimer *)dd_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats
{
    void (^block)() = [inBlock copy];
    NSTimer * timer = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(__executeTimerBlock:) userInfo:block repeats:inRepeats];
    return timer;
}

+ (NSTimer *)dd_timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats
{
    void (^block)() = [inBlock copy];
    NSTimer * timer = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(__executeTimerBlock:) userInfo:block repeats:inRepeats];
    return timer;
}

+ (void)__executeTimerBlock:(NSTimer *)inTimer;
{
    if([inTimer userInfo])
    {
        void (^block)() = (void (^)())[inTimer userInfo];
        block();
    }
}

@end

@implementation BlockTestView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        int a = 10;
        
        int (^add1)(int) = ^(int b) {
            return a + b;
        };
        a = 6;
        NSLog(@"result: %d", add1(100)); // 110
        
        
        __block int m = 4;
        int (^add2)(int) = ^(int b) {
            return m + b;
        };
        m = 20;
        NSLog(@"result2: %d", add2(100)); // 120
        
        _timeInterval = 1;
        _timer = [NSTimer dd_scheduledTimerWithTimeInterval:_timeInterval block:^{
            [self timerUpdate];
        } repeats:YES];
    }
    
    return self;
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)timerUpdate {
    _times++;
    NSLog(@"times %@", @(_times));
    if (_times % 5 == 0) {
        _timeInterval += 2;
        [self stopTimer];
        
        _timer = [NSTimer dd_scheduledTimerWithTimeInterval:_timeInterval block:^{
            [self timerUpdate];
        } repeats:YES];
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (!newWindow) {
        [self stopTimer];
    }
}

@end
