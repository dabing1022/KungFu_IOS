//
//  ShakeResponderView.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/7/18.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "ShakeResponderView.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioToolbox/AudioToolbox.h"
#import "CardView.h"

@interface ShakeResponderView () {
    SystemSoundID soundID;
    CardView *cardView;
}

@end

@implementation ShakeResponderView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
        _shakeEnabled = YES;
        [self becomeFirstResponder];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"glass" ofType:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    }
    
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return _shakeEnabled;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"motion began...");
    AudioServicesPlaySystemSound (soundID);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"motion cancelled...");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"motion ended...");
        
        cardView = [[CardView alloc] init];
        [cardView show];
        
//        [self performSelector:@selector(cardViewDismissed) withObject:nil afterDelay:5];
    }
}

- (void)cardViewDismissed {
    [cardView dismiss];
}

- (void)setShakeEnabled:(BOOL)shakeEnabled {
    _shakeEnabled = shakeEnabled;
    
    if (_shakeEnabled) {
        [self becomeFirstResponder];
    } else {
        [self resignFirstResponder];
    }
}

@end
