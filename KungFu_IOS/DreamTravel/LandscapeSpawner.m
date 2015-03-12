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

- (id)init
{
    self = [super init];
    if (self) {
        _dataSource = @[@"山峰", @"老树", @"古道", @"小河", @"松", @"竹", @"梅", @"兰", @"山石", @"溪流", @"边关", @"微草"];
    }
    
    return self;
}

- (LandscapeAtom *)spawnByDirection:(LandscapeMoveDirection)direction
{    
    NSString* name = _dataSource[arc4random_uniform(_dataSource.count)];
    NSUInteger zIndex = arc4random_uniform(LANDSCAPE_LAYERS_NUM);
    
    CGFloat posX;
    CGFloat width = 100.0;
    CGFloat height = 30.0;
    if (direction == LandscapeMoveDirectionLeft) {
        posX = kScreen_Width + arc4random_uniform(50);
    } else if (direction == LandscapeMoveDirectionRight) {
        posX = 0 - arc4random_uniform(50) - width;
    } else {
        posX = arc4random_uniform(kScreen_Width - 50) + 25;
    }
    
    LandscapeAtom* landscape = [[LandscapeAtom alloc] initWithFrame:CGRectMake(posX, 50 + 30 * zIndex, width, height) landscapeName:name];
    landscape.landscapeLayer.opacity = 0;
    landscape.targetOpacity = (zIndex + 1.0) / 10.0;
    landscape.lifeTime = arc4random_uniform(4) + 10;
    landscape.zIndex = zIndex;

    return landscape;
}

@end
