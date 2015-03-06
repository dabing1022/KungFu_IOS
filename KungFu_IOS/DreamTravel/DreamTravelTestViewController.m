//
//  DreamTravelTestViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/3/6.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "DreamTravelTestViewController.h"
#import "LandscapeAtom.h"
#import "PerlinNoise.h"


#define LANDSCAPE_LAYERS_NUM        10

@interface DreamTravelTestViewController ()
{
    PerlinNoise* perlinNoise;
    NSMutableArray* landscapeViews;
    
    LandscapeMoveDirection curMoveDir;
    float curMoveDuration;
}

@end

@implementation DreamTravelTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    
    [self addLandscapeAtomTest];
    [self animateLandscapeViews];
}

- (void)dealloc
{
    [self.view.layer removeAllAnimations];
    DebugMethod();
}

- (void)initData
{
    perlinNoise = [[PerlinNoise alloc] initWithSeed:25];
    landscapeViews = [NSMutableArray array];
    
    curMoveDir = LandscapeMoveDirectionLeft;
    curMoveDuration = 8.0f;
}

- (void)addLandscapeAtomTest
{
    for (NSUInteger i = 0; i < 10; i ++) {
        NSString* name = [NSString stringWithFormat:@"山峰 %@", @(i)];
        NSUInteger zIndex = arc4random_uniform(LANDSCAPE_LAYERS_NUM);
        
        LandscapeAtom* landscape = [[LandscapeAtom alloc] initWithFrame:CGRectMake(150 + arc4random() % 100, 50 + 30 * zIndex, 100, 100) landscapeName:name];
        landscape.alpha = (zIndex + 1.0) / 10.0;
        landscape.lifeTime = arc4random_uniform(4) + 4;
        landscape.zIndex = zIndex;
        NSLog(@"lifeTime %@, zIndex %@", @(landscape.lifeTime), @(landscape.zIndex));
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        landscape.transform = CGAffineTransformScale(transform, 1 + landscape.zIndex / 6.0, 1 + landscape.zIndex / 6.0);
        [self.view addSubview:landscape];
        
        [landscapeViews addObject:landscape];
    }
}

- (void)animateLandscapeViews
{
    CGFloat moveDistance = 100.0;
    if (curMoveDir == LandscapeMoveDirectionRight) {
        moveDistance *= 1;
    } else if (curMoveDir == LandscapeMoveDirectionLeft) {
        moveDistance *= -1;
    }
    
    [UIView animateWithDuration:curMoveDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        for (LandscapeAtom* landscape in landscapeViews) {
            CGFloat tx = landscape.zIndex * 1.0 / LANDSCAPE_LAYERS_NUM * moveDistance;
            landscape.transform = CGAffineTransformTranslate(landscape.transform, tx, 0);
        }
    } completion:^(BOOL finished) {
        if (finished) {
            NSArray* moveInfoArr = [self nextLandscapeMoveDirectionInfo];
            curMoveDir = [moveInfoArr[0] integerValue];
            curMoveDuration = [moveInfoArr[1] floatValue];
            CGFloat moveDistance = 100.0;
            if (curMoveDir == LandscapeMoveDirectionRight) {
                moveDistance *= 1;
            } else if (curMoveDir == LandscapeMoveDirectionLeft) {
                moveDistance *= -1;
            }
            [UIView animateWithDuration:curMoveDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                for (LandscapeAtom* landscape in landscapeViews) {
                    CGFloat tx = landscape.zIndex * 1.0 / LANDSCAPE_LAYERS_NUM * moveDistance;
                    landscape.transform = CGAffineTransformTranslate(landscape.transform, tx, 0);
                }
            } completion:NULL];
        }
    }];
}

- (NSArray *)nextLandscapeMoveDirectionInfo
{
//    LandscapeMoveDirection dir = arc4random_uniform(4);
//    float moveDuration = arc4random() % 8 + 4;
//    return @[@(dir), @(moveDuration)];
    return @[@(LandscapeMoveDirectionRight), @(4)];
}

@end
