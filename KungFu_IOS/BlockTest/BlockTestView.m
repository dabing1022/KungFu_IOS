//
//  BlockTestView.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/4/8.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "BlockTestView.h"

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
    }
    
    return self;
}

@end
