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
        
        [self blockTest1];
    }
    
    return self;
}

// _NSConcreteGlobalBlock类型的block要么是空block，要么是不访问任何外部变量的block。它既不在栈中，也不在堆中，我理解为它可能在内存的全局区。
// _NSConcreteStackBlock类型的block有闭包行为，也就是有访问外部变量，并且该block有且只有有一次执行，因为栈中的空间是可重复使用的，所以当栈中的block执行一次之后就被清除出栈了，所以无法多次使用。
// _NSConcreteMallocBlock类型的block有闭包行为，并且该block需要被多次执行。当需要多次执行时，就会把该block从栈中复制到堆中，供以多次执行。
- (void)blockTest1 {
    
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
