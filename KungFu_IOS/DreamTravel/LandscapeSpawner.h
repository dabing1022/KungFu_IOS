//
//  LandscapeSpawner.h
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/3/8.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LandscapeAtom.h"

#define LANDSCAPE_LAYERS_NUM        10

@class LandscapeAtom;
@interface LandscapeSpawner : NSObject

@property (nonatomic, strong) NSArray* dataSource;

- (LandscapeAtom *)spawnByDirection:(LandscapeMoveDirection)direction;

@end
