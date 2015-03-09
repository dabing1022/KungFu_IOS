//
//  LandscapeSpawner.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/3/8.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "LandscapeSpawner.h"
#import "LandscapeAtom.h"

@implementation LandscapeSpawner

- (LandscapeAtom *)spawn
{
    NSString* name = [NSString stringWithFormat:@"山峰 %@", @(arc4random_uniform(100))];
    NSUInteger zIndex = arc4random_uniform(LANDSCAPE_LAYERS_NUM);
    
    LandscapeAtom* landscape = [[LandscapeAtom alloc] initWithFrame:CGRectMake(arc4random_uniform(kScreen_Width), 50 + 30 * zIndex, 100, 30) landscapeName:name];
    landscape.landscapeLayer.opacity = (zIndex + 1.0) / 10.0;
    landscape.lifeTime = arc4random_uniform(4) + 4;
    landscape.zIndex = zIndex;

    return landscape;
}

@end
