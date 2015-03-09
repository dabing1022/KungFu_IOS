//
//  KungFuHelper.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/3/9.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "KungFuHelper.h"
#import <UIKit/UIKit.h>

@implementation KungFuHelper

+ (void)debugLayer:(CALayer *)layer enabled:(BOOL)enabled
{
    if (enabled) {
        layer.borderWidth = 1.0;
        layer.borderColor = [UIColor redColor].CGColor;
    } else {
        layer.borderWidth = 0.0;
    }
}

@end
