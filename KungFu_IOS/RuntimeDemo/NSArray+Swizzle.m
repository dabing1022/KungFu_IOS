//
//  NSArray+Swizzle.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/4/12.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "NSArray+Swizzle.h"

@implementation NSArray (Swizzle)

- (id)myLastObject
{
    id ret = [self myLastObject];
    NSLog(@"********* myLastObject *********");
    return ret;
}


@end
