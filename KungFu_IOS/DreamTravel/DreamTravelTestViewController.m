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

#define LANDSCAPE_VELOCITY_MANUALLY            10
#define LANDSCAPE_VELOCITY_AUTO                100

@interface DreamTravelTestViewController ()
{
    PerlinNoise* perlinNoise;
    
    UIView* landscapeContainerView;
    NSMutableArray* landscapes;
    NSMutableArray* landscapeLayers;

    LandscapeSpawner* spawner;
    LandscapeMoveDirection curMoveDir;
    float curMoveDuration;
    
    CADisplayLink* displayLink;
    CGFloat tickerNum;
    
    NSMutableArray* landscapeToBeDeleted;
    
    UILabel* fpsLabel;
    
    CALayer* transformTestLayer;
    
    UITapGestureRecognizer* doubleTapGes;
    UIPanGestureRecognizer* panGes;
    UIPinchGestureRecognizer* pinchGes;
    CGFloat pinchLastScale;
    CGPoint pinchLastPoint;
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
    
    doubleTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapHandler:)];
    doubleTapGes.numberOfTouchesRequired = 1;
    doubleTapGes.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGes];
    
    panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    [self.view addGestureRecognizer:panGes];
    
    pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandler:)];
    [self.view addGestureRecognizer:pinchGes];
    
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
    [self.view removeGestureRecognizer:doubleTapGes];
    [self.view removeGestureRecognizer:panGes];
    [self.view removeGestureRecognizer:pinchGes];
    DebugMethod();
}

- (void)doubleTapHandler:(UITapGestureRecognizer *)doubleTap
{
    landscapeContainerView.layer.transform = CATransform3DMakeScale(1, 1, 1);
}

- (void)panHandler:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        displayLink.paused = YES;
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint traslation = [pan translationInView:self.view];
        CGFloat deltaX = traslation.x;
        CGFloat deltaY = traslation.y;
        
        for (LandscapeAtom* landscape in landscapes) {
            CALayer* layer = landscape.landscapeLayer;
            CGFloat speed = landscape.zIndex * 1.0 / LANDSCAPE_LAYERS_NUM * LANDSCAPE_VELOCITY_MANUALLY;
            CATransform3D transform = layer.transform;
            transform = CATransform3DTranslate(transform, speed * deltaX * 0.005, speed * deltaY * 0.001, 0);
            layer.transform = transform;
        }
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        displayLink.paused = NO;
    } else if (pan.state == UIGestureRecognizerStateCancelled) {
        displayLink.paused = NO;
    }
}

- (void)pinchHandler:(UIPinchGestureRecognizer *)pinch
{
    if (pinch.state == UIGestureRecognizerStateBegan) {
        displayLink.paused = YES;
        pinchLastScale = 1.0;
        pinchLastPoint = [pinch locationInView:self.view];
    } else if([pinch state] == UIGestureRecognizerStateEnded) {
        displayLink.paused = NO;
    } else if (pinch.state == UIGestureRecognizerStateChanged) {
        displayLink.paused = YES;
        
        CATransform3D transform = landscapeContainerView.layer.transform;
        CGFloat scale = 1.0 + (pinch.scale - pinchLastScale);
        transform = CATransform3DScale(transform, scale, scale, 1);
        pinchLastScale = pinch.scale;
        
        CGPoint point = [pinch locationInView:landscapeContainerView];
        transform = CATransform3DTranslate(transform, point.x - pinchLastPoint.x, point.y - pinchLastPoint.y, 0);
        pinchLastPoint = point;
        
        landscapeContainerView.layer.transform = transform;
    } else if (pinch.state == UIGestureRecognizerStateCancelled) {
        displayLink.paused = NO;
    }
}

- (void)initData
{
    perlinNoise = [[PerlinNoise alloc] initWithSeed:30];
    spawner = [[LandscapeSpawner alloc] init];
    landscapes = [NSMutableArray array];
    landscapeToBeDeleted = [NSMutableArray array];
    landscapeLayers = [NSMutableArray arrayWithCapacity:LANDSCAPE_LAYERS_NUM];
    
    landscapeContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:landscapeContainerView];
    for (NSUInteger i = 0; i < LANDSCAPE_LAYERS_NUM; i++) {
        CALayer* layer = [CALayer layer];
        [landscapeContainerView.layer addSublayer:layer];
        [KungFuHelper debugLayer:layer enabled:YES];
        
        CATransform3D transform = CATransform3DIdentity;
        CGFloat scale = 1 + i * 1.0 / LANDSCAPE_LAYERS_NUM;
        layer.transform = CATransform3DScale(transform, scale, scale, 1);

        [landscapeLayers addObject:layer];
    }
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
            CGFloat speed = landscape.zIndex * 1.0 / LANDSCAPE_LAYERS_NUM * LANDSCAPE_VELOCITY_AUTO;
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
    NSLog(@"Noise =============== %f", noise);
    if (noise < 0.45) {
        dir = LandscapeMoveDirectionLeft;
        NSLog(@"◀︎ ◀︎ ◀︎ ◀︎ ◀︎ ◀︎");
    } else if (noise < 0.8) {
        dir = LandscapeMoveDirectionRight;
        NSLog(@"▶︎ ▶︎ ▶︎ ▶︎ ▶︎ ▶︎");
    } else if (noise < 0.9) {
        dir = LandscapeMoveDirectionOutScreen;
        NSLog(@"▼ ▼ ▼ ▼ ▼ ▼");
    } else {
        dir = LandscapeMoveDirectionIntoScreen;
        NSLog(@"▲ ▲ ▲ ▲ ▲ ▲");
    }
    float moveDuration = arc4random() % 8 + 4;
    return @[@(dir), @(moveDuration)];
}

- (void)applyBasicAnimation:(CABasicAnimation *)animation toLayer:(CALayer *)layer forKey:(NSString *)key
{
    animation.fromValue = [layer.presentationLayer ? : layer valueForKey:animation.keyPath];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [layer setValue:animation.toValue forKeyPath:animation.keyPath];
    [CATransaction commit];
    [layer addAnimation:animation forKey:key];
}

@end
