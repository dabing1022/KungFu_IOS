//
//  BlockTestView.h
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/4/8.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSTimer (Block)

+ (NSTimer *)dd_scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

+ (NSTimer *)dd_timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

@end

@interface BlockTestView : UIView {
    NSTimer *_timer;
    NSTimeInterval _timeInterval;
    NSInteger _times;
}

@end
