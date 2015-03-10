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
#import "PerlinNoise.h"

@interface DreamTravelTestViewController ()
{
    PerlinNoise* perlinNoise;
    
    NSMutableArray* landscapes;
    NSMutableArray* landscapeLayers;

    LandscapeSpawner* spawner;
    LandscapeMoveDirection curMoveDir;
    float curMoveDuration;
    
    CADisplayLink* displayLink;
    CGFloat velocity;
    CGFloat tickerNum;
    
    NSMutableArray* landscapeToBeDeleted;
    
    UILabel* fpsLabel;
}

@end

@implementation DreamTravelTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self addFpsLabel];
    
    NSArray* moveInfo = [self nextLandscapeMoveDirectionInfo];
    curMoveDir = [moveInfo[0] integerValue];
    curMoveDuration = [moveInfo[1] floatValue];
    
    for (NSUInteger i = 0; i < 5; i++) {
        [self spawnLandscapeByMoveDirection:curMoveDir];
    }
    
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(travelling:)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [displayLink invalidate];
    displayLink = nil;
}

- (void)dealloc
{
    DebugMethod();
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    DebugMethod();
    displayLink.paused = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    DebugMethod();
    UITouch* touch = [touches anyObject];
    CGPoint previousPos = [touch previousLocationInView:self.view];
    CGPoint nowPos = [touch locationInView:self.view];
    CGFloat deltaX = nowPos.x - previousPos.x;
    CGFloat deltaY = nowPos.y - previousPos.y;
    
    for (LandscapeAtom* landscape in landscapes) {
        CALayer* layer = landscape.landscapeLayer;
        CGFloat speed = landscape.zIndex * 1.0 / LANDSCAPE_LAYERS_NUM * velocity;
        CATransform3D transform = layer.transform;
        if (deltaX > 0) {
            transform = CATransform3DTranslate(transform, speed * 0.05, 0, 0);
        } else {
            transform = CATransform3DTranslate(transform, -speed * 0.05, 0, 0);
        }
        
        if (deltaY > 0) {
            transform = CATransform3DTranslate(transform, 0, speed * 0.01, 0);
        } else {
            transform = CATransform3DTranslate(transform, 0, -speed * 0.01, 0);
        }
        layer.transform = transform;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    DebugMethod();
    displayLink.paused = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    DebugMethod();
    displayLink.paused = YES;
}

- (void)initData
{
    perlinNoise = [[PerlinNoise alloc] initWithSeed:25];
    spawner = [[LandscapeSpawner alloc] init];
    landscapes = [NSMutableArray array];
    landscapeToBeDeleted = [NSMutableArray array];
    landscapeLayers = [NSMutableArray arrayWithCapacity:LANDSCAPE_LAYERS_NUM];
    for (NSUInteger i = 0; i < LANDSCAPE_LAYERS_NUM; i++) {
        CAScrollLayer* scrollLayer = [CAScrollLayer layer];
        [self.view.layer addSublayer:scrollLayer];
        
        CATransform3D transform = CATransform3DIdentity;
        CGFloat scale = 1 + i * 1.0 / LANDSCAPE_LAYERS_NUM;
        scrollLayer.transform = CATransform3DScale(transform, scale, scale, 1);

        [landscapeLayers addObject:scrollLayer];
    }
    
    velocity = 150.0;
}

- (void)addFpsLabel
{
    fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 150, 50)];
    fpsLabel.textColor = [UIColor redColor];
    fpsLabel.backgroundColor = [UIColor clearColor];
    fpsLabel.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:fpsLabel];
}

- (void)travelling:(CADisplayLink *)timer
{
    fpsLabel.text = [NSString stringWithFormat:@"%.1f FPS", 1.0 / timer.duration];
    
    tickerNum += 0.05;
    if (tickerNum >= curMoveDuration) {
        tickerNum = 0;
        
        NSArray* moveInfo = [self nextLandscapeMoveDirectionInfo];
        curMoveDir = [moveInfo[0] integerValue];
        curMoveDuration = [moveInfo[1] floatValue];
        
        [self spawnLandscapeByMoveDirection:curMoveDir];
    }
    
    if (curMoveDir == LandscapeMoveDirectionIntoScreen) {
        for (CALayer* layer in landscapeLayers) {
            layer.transform = CATransform3DScale(layer.transform, 1.001, 1.001, 1);
        }
    } else if (curMoveDir == LandscapeMoveDirectionOutScreen) {
        for (CALayer* layer in landscapeLayers) {
            layer.transform = CATransform3DScale(layer.transform, 0.999, 0.999, 1);
        }
    } else {
        for (LandscapeAtom* landscape in landscapes) {
            CALayer* layer = landscape.landscapeLayer;
            CGFloat speed = landscape.zIndex * 1.0 / LANDSCAPE_LAYERS_NUM * velocity;
            CATransform3D transform = layer.transform;
            if (curMoveDir == LandscapeMoveDirectionLeft) {
                transform = CATransform3DTranslate(transform, -speed * timer.duration, 0, 0);
            } else {
                transform = CATransform3DTranslate(transform, speed * timer.duration, 0, 0);
            }
            layer.transform = transform;
        }
    }
    
    for (LandscapeAtom* landscape in landscapes) {
        if (landscape.landscapeLayer.opacity < landscape.targetOpacity && landscape.isFadeIn) {
            landscape.landscapeLayer.opacity += 0.02;
        } else {
            landscape.isFadeIn = NO;
            landscape.landscapeLayer.opacity -= 0.0005;
            
            if (landscape.landscapeLayer.opacity <= 0) {
                [landscapeToBeDeleted addObject:landscape];
            }
        }
    }
    
    for (LandscapeAtom* landscape in landscapeToBeDeleted) {
        [landscape.landscapeLayer removeFromSuperlayer];
        [landscapes removeObject:landscape];
    }
    [landscapeToBeDeleted removeAllObjects];
}

- (void)spawnLandscapeByMoveDirection:(LandscapeMoveDirection)direction
{
    LandscapeAtom* landscape = [spawner spawnByDirection:direction];
    NSLog(@"==== spawn landscape lifeTime %@, zIndex %@", @(landscape.lifeTime), @(landscape.zIndex));
    
    CALayer* layer = [self layerOfLandscape:landscape];
    [layer addSublayer:landscape.landscapeLayer];
    
    [landscapes addObject:landscape];
    
    [KungFuHelper debugLayer:landscape.landscapeLayer enabled:NO];
}

- (CALayer *)layerOfLandscape:(LandscapeAtom *)landscape
{
    return [landscapeLayers objectAtIndex:landscape.zIndex];
}

- (NSArray *)nextLandscapeMoveDirectionInfo
{
    LandscapeMoveDirection dir = LandscapeMoveDirectionLeft;
    
    float noise = [perlinNoise perlin1DValueForPoint:CACurrentMediaTime()];
    NSLog(@"noise =============== %f", noise);
    if (noise < 0.45) {
        dir = LandscapeMoveDirectionLeft;
        NSLog(@"========== move left ");
    } else if (noise < 0.8) {
        dir = LandscapeMoveDirectionRight;
        NSLog(@"========== move right");
    } else if (noise < 0.9) {
        dir = LandscapeMoveDirectionOutScreen;
        NSLog(@"========== out screen");
    } else {
        dir = LandscapeMoveDirectionIntoScreen;
        NSLog(@"========== into screen");
    }
    float moveDuration = arc4random() % 8 + 4;
    return @[@(dir), @(moveDuration)];
}

@end
