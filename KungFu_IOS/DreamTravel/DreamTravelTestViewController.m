//
//  DreamTravelTestViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/3/6.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "DreamTravelTestViewController.h"
#import "LandscapeAtom.h"
#import "LandscapeSpawner.h"

@interface DreamTravelTestViewController ()
{
    NSMutableArray* landscapes;
    NSMutableArray* landscapeLayers;

    LandscapeSpawner* spawner;
    LandscapeMoveDirection curMoveDir;
    float curMoveDuration;
}

@end

@implementation DreamTravelTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    
    for (NSUInteger i = 0; i < 5; i++) {
        [self spawnLandscape];
    }
    [self performSelector:@selector(animateLandscapeViews) withObject:nil afterDelay:2];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateLandscapeViews) object:nil];
}

- (void)dealloc
{
    [self.view.layer removeAllAnimations];

    DebugMethod();
}

- (void)initData
{
    spawner = [[LandscapeSpawner alloc] init];
    landscapes = [NSMutableArray array];
    landscapeLayers = [NSMutableArray arrayWithCapacity:LANDSCAPE_LAYERS_NUM];
    for (NSUInteger i = 0; i < LANDSCAPE_LAYERS_NUM; i++) {
        CALayer* layer = [CALayer layer];
        [self.view.layer addSublayer:layer];

        [landscapeLayers addObject:layer];
        
        [KungFuHelper debugLayer:layer enabled:YES];
    }
    [KungFuHelper debugLayer:self.view.layer enabled:YES];
}

- (void)spawnLandscape
{
    LandscapeAtom* landscape = [spawner spawn];
    NSLog(@"==== spawn landscape lifeTime %@, zIndex %@", @(landscape.lifeTime), @(landscape.zIndex));
    
    CALayer* layer = [self layerOfLandscape:landscape];
    [layer addSublayer:landscape.landscapeLayer];
    
    [KungFuHelper debugLayer:landscape.landscapeLayer enabled:YES];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    CATransform3D transform = CATransform3DIdentity;
    CGFloat scale = 1 + landscape.zIndex * 1.0 / LANDSCAPE_LAYERS_NUM;
    layer.transform = CATransform3DScale(transform, scale, scale, 1);
    [CATransaction commit];
    
    [landscapes addObject:landscape];
}

- (CALayer *)layerOfLandscape:(LandscapeAtom *)landscape
{
    return [landscapeLayers objectAtIndex:landscape.zIndex];
}

- (void)animateLandscapeViews
{
    DebugMethod();
    NSArray* moveInfoArr = [self nextLandscapeMoveDirectionInfo];
    curMoveDuration = [moveInfoArr[1] floatValue];
    [self performSelector:@selector(animateLandscapeViews) withObject:nil afterDelay:curMoveDuration];

    NSLog(@"landscapes num %@", @(landscapes.count));

    for (LandscapeAtom* landscape in landscapes) {
        CABasicAnimation* transformAnimation = [CABasicAnimation animation];
        transformAnimation.keyPath = @"transform";
        transformAnimation.duration = curMoveDuration;
        CATransform3D transform = [self transformOfLandscape:landscape directionInfo:moveInfoArr];
        transformAnimation.toValue = [NSValue valueWithCATransform3D:transform];
        transformAnimation.delegate = self;
        [transformAnimation setValue:@"landscapeTransformAnime" forKey:@"landscape"];
    
        CALayer* layer = [self layerOfLandscape:landscape];
        [self applyBasicAnimation:transformAnimation toLayer:layer forKey:nil];
    
        if (![landscape.landscapeLayer animationForKey:@"landscape"]) {
            CABasicAnimation* fadeOutAnimation = [CABasicAnimation animation];
            fadeOutAnimation.keyPath = @"opacity";
            fadeOutAnimation.duration = landscape.lifeTime;
            fadeOutAnimation.toValue = @(0);
            fadeOutAnimation.delegate = self;
            [fadeOutAnimation setValue:@"landscapeFadeOutAnime" forKey:@"landscape"];
            [fadeOutAnimation setValue:landscape forKey:@"landscapeAtom"];
            [self applyBasicAnimation:fadeOutAnimation toLayer:landscape.landscapeLayer forKey:@"landscapeFadeOut"];
        }
    }
}

- (void)applyBasicAnimation:(CABasicAnimation *)animation toLayer:(CALayer *)layer forKey:(NSString *)key
{
    animation.fromValue = [layer.presentationLayer ? : layer valueForKey:animation.keyPath];

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [layer setValue:animation.toValue forKeyPath:animation.keyPath];
    
    if ([[animation valueForKey:@"landscape"] isEqualToString:@"landscapeTransformAnime"]) {
        NSLog(@"%f %f %f %f", layer.transform.m11, layer.transform.m21, layer.transform.m31, layer.transform.m41);
        NSLog(@"%f %f %f %f", layer.transform.m12, layer.transform.m22, layer.transform.m32, layer.transform.m42);
        NSLog(@"%f %f %f %f", layer.transform.m13, layer.transform.m23, layer.transform.m33, layer.transform.m43);
        NSLog(@"%f %f %f %f", layer.transform.m14, layer.transform.m24, layer.transform.m34, layer.transform.m44);
    }
    
    [CATransaction commit];
    
    [layer addAnimation:animation forKey:key];
}

- (CATransform3D)transformOfLandscape:(LandscapeAtom *)landscape directionInfo:(NSArray *)directonInfo
{
    curMoveDir = [directonInfo[0] integerValue];
    CGFloat moveDistance = 100.0;
    CGFloat tx = landscape.zIndex * 1.0 / LANDSCAPE_LAYERS_NUM * moveDistance;
    
    CALayer* layer = [landscapeLayers objectAtIndex:landscape.zIndex];
    CATransform3D transform = layer.transform;
    
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
    if ([[anim valueForKey:@"landscape"] isEqualToString:@"landscapeFadeOutAnime"]) {
        static NSUInteger i = 0;
        i++;
        LandscapeAtom* landscape = (LandscapeAtom *)[anim valueForKey:@"landscapeAtom"];
        NSLog(@"alpha --> 0, layer removed, landscape %@", landscape.landscapeName);
        [landscapes removeObject:landscape];
        [landscape.landscapeLayer removeFromSuperlayer];

        if (i % 2 == 0 || landscapes.count == 0) {
            [self spawnLandscape];
        }
    }
}

@end
