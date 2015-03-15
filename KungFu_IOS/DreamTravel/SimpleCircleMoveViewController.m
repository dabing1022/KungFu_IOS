//
//  SimpleCircleMoveViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/3/14.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "SimpleCircleMoveViewController.h"

@interface SimpleCircleMoveViewController ()
{
    CircleMove2DView* circleMove2DView;
}

@end

@implementation SimpleCircleMoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    circleMove2DView = [[CircleMove2DView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:circleMove2DView];
}

@end



#pragma mark - CircleMove2DView

@interface CircleMove2DView ()
{
    CAShapeLayer* landscapePoint;
    CAShapeLayer* circlePathLayer;
    CircleMover* mover;
    
    CGFloat circleRadius;
    CGFloat landscapePointRadius;
    
    CADisplayLink* displayLink;
    CGPoint landscapePos;
    CGFloat angle;
}

@end

@implementation CircleMove2DView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        circleRadius = 100;
        landscapePointRadius = 10;
        angle = 0;
        
        CGRect circleFrame = CGRectMake(kScreen_CenterX - circleRadius, 100, 2 * circleRadius, 2 * circleRadius);
        UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect:circleFrame];
        circlePathLayer = [CAShapeLayer layer];
        circlePathLayer.lineWidth = 1;
        circlePathLayer.strokeColor = [UIColor grayColor].CGColor;
        circlePathLayer.fillColor = [UIColor clearColor].CGColor;
        circlePathLayer.path = circlePath.CGPath;
        [self.layer addSublayer:circlePathLayer];
        landscapePos = CGPointMake(CGRectGetMidX(circleFrame), CGRectGetMidY(circleFrame));
        
        CGRect landscapePointFrame = CGRectMake(kScreen_CenterX - landscapePointRadius, CGRectGetMidY(circleFrame) - landscapePointRadius, 2 * landscapePointRadius, 2 * landscapePointRadius);
        UIBezierPath* landscapePointPath = [UIBezierPath bezierPathWithOvalInRect:landscapePointFrame];
        landscapePoint = [CAShapeLayer layer];
        landscapePoint.fillColor = [UIColor redColor].CGColor;
        landscapePoint.path = landscapePointPath.CGPath;
        [self.layer addSublayer:landscapePoint];
        
        mover = [[CircleMover alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        mover.center = CGPointMake(landscapePos.x + circleRadius * cos(angle), landscapePos.y + circleRadius * sin(angle));
        [self addSubview:mover];
        
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(circleMoving:)];
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    
    return self;
}

- (void)circleMoving:(CADisplayLink *)display
{
    angle += 0.05;
    mover.center = CGPointMake(landscapePos.x + circleRadius * cos(angle), landscapePos.y + circleRadius * sin(angle));
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [displayLink invalidate];
        displayLink = nil;
    }
}

@end


#pragma mark - CircleMover

@interface CircleMover ()
{
    CAShapeLayer* body;
}

@end

@implementation CircleMover

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.velocity = 4.0;
        
        UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
        body = [CAShapeLayer layer];
        body.fillColor = [UIColor blackColor].CGColor;
        body.path = path.CGPath;
        [self.layer addSublayer:body];
    }
    
    return self;
}

@end


