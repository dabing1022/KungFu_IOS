//
//  DreamTravelTestViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/3/6.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "DreamTravelTestViewController.h"
#import "LandscapeAtom.h"

#define LANDSCAPE_LAYERS_NUM        10

@interface DreamTravelTestViewController ()
{
    NSMutableArray* landscapeViews;
    
    LandscapeMoveDirection curMoveDir;
    float curMoveDuration;
    
    UILabel* bugTestLabel;
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
    landscapeViews = [NSMutableArray array];
}

- (void)addLandscapeAtomTest
{
    for (NSUInteger i = 0; i < 11; i ++) {
        NSString* name = [NSString stringWithFormat:@"山峰 %@", @(i)];
        NSUInteger zIndex = arc4random_uniform(LANDSCAPE_LAYERS_NUM);
        
        LandscapeAtom* landscape = [[LandscapeAtom alloc] initWithFrame:CGRectMake(150 + arc4random() % 100, 50 + 30 * zIndex, 100, 100) landscapeName:name];
        landscape.alpha = (zIndex + 1.0) / 10.0;
        landscape.lifeTime = arc4random_uniform(4) + 4;
        landscape.zIndex = zIndex;
        NSLog(@"lifeTime %@, zIndex %@", @(landscape.lifeTime), @(landscape.zIndex));
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        landscape.transform = CGAffineTransformScale(transform, 1 + landscape.zIndex * 1.0 / LANDSCAPE_LAYERS_NUM, 1 + landscape.zIndex * 1.0 / LANDSCAPE_LAYERS_NUM);
        [self.view addSubview:landscape];
        
        [landscapeViews addObject:landscape];
    }
}

- (void)animateLandscapeViews
{
    NSArray* moveInfoArr = [self nextLandscapeMoveDirectionInfo];
    curMoveDuration = [moveInfoArr[1] floatValue];

    for (LandscapeAtom* landscape in landscapeViews) {
        CABasicAnimation* animation = [CABasicAnimation animation];
        animation.keyPath = @"transform";
        animation.duration = curMoveDuration;
        animation.fromValue = [NSValue valueWithCATransform3D:landscape.layer.transform];
        CATransform3D transform = [self transformOfLandscape:landscape directionInfo:moveInfoArr];
        animation.toValue = [NSValue valueWithCATransform3D:transform];
        [landscape.layer setValue:animation.toValue forKeyPath:animation.keyPath];
        animation.delegate = self;
        [animation setValue:@"landscapeAnime" forKey:@"landscape"];
        [landscape.layer addAnimation:animation forKey:nil];
    }
}

- (CATransform3D)transformOfLandscape:(LandscapeAtom *)landscape directionInfo:(NSArray *)directonInfo
{
    curMoveDir = [directonInfo[0] integerValue];
    CGFloat moveDistance = 100.0;
    CGFloat tx = landscape.zIndex * 1.0 / LANDSCAPE_LAYERS_NUM * moveDistance;
    CATransform3D transform = landscape.layer.transform;
    
    if (curMoveDir == LandscapeMoveDirectionLeft) {
        transform = CATransform3DTranslate(transform, -tx, 0, 0);
    } else if (curMoveDir == LandscapeMoveDirectionRight) {
        transform = CATransform3DTranslate(transform, tx, 0, 0);
    } else if (curMoveDir == LandscapeMoveDirectionIntoScreen) {
        transform = CATransform3DScale(transform, 2, 2, 1);
    } else if (curMoveDir == LandscapeMoveDirectionOutScreen) {
        transform = CATransform3DScale(transform, 0.5, 0.5, 1);
    }
    
    return transform;
}

- (NSArray *)nextLandscapeMoveDirectionInfo
{
    LandscapeMoveDirection dir = arc4random_uniform(4);
    float moveDuration = arc4random() % 8 + 4;
    return @[@(dir), @(moveDuration)];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag
{
    NSArray* moveInfoArr = [self nextLandscapeMoveDirectionInfo];
    curMoveDuration = [moveInfoArr[1] floatValue];
    
    static int i = 0;
    i++;
    if (i % landscapeViews.count == 0) {
        for (LandscapeAtom* landscape in landscapeViews) {
            CABasicAnimation* animation = [CABasicAnimation animation];
            animation.keyPath = @"transform";
            animation.duration = curMoveDuration;
            animation.fromValue = [NSValue valueWithCATransform3D:landscape.layer.transform];
            CATransform3D transform = [self transformOfLandscape:landscape directionInfo:moveInfoArr];
            animation.toValue = [NSValue valueWithCATransform3D:transform];
            [landscape.layer setValue:animation.toValue forKeyPath:animation.keyPath];
            [landscape.layer addAnimation:animation forKey:nil];
        }
    }
}

@end
