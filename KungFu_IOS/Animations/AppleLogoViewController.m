//
//  AppleLogoViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 16/5/13.
//  Copyright © 2016年 ChildhoodAndy. All rights reserved.
//

#import "AppleLogoViewController.h"
#import "BLBezierView.h"
#import "PWBezier.h"

#pragma mark - ColorBall
@interface ColorBall : UIView

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) UIColor *color;

@end

@implementation ColorBall

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(frame.size.width == frame.size.height, @"Be a round ball.");
        _radius = frame.size.width * 0.5;
        self.layer.cornerRadius = _radius;
        self.layer.masksToBounds = YES;
        self.color = [RANDOM_COLOR colorWithAlphaComponent:0.5];
    }
    
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.backgroundColor = _color;
}

- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    self.bounds = CGRectMake(0, 0, 2 * _radius, 2 * _radius);
}

@end

#pragma mark - AppleLogoView
static NSArray *AppleLogoBezierData;
#define PointValue(a, b)   [NSValue valueWithCGPoint:CGPointMake(a, b)]
@interface AppleLogoView : UIView {
    NSMutableArray *_bezierArray;
    NSInteger _divisions;
}

@property (nonatomic, strong) NSMutableArray *positionArray;

@end

@implementation AppleLogoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _divisions = 5;
        AppleLogoBezierData = @[//1
                                @{@"s" : PointValue(82.3, 245.02),
                                  @"c1" : PointValue(64.29, 239.47),
                                  @"c2" : PointValue(39.12, 201.78),
                                  @"e" : PointValue(29.96, 166.65),
                                  @"d" : @(-1)},
                                //2
                                @{@"s" : PointValue(29.96, 166.65),
                                  @"c1" : PointValue(12.22, 98.6),
                                  @"c2" : PointValue(57.12, 41.23),
                                  @"e" : PointValue(110.75, 63.4),
                                  @"d" : @(-1)},
                                //3
                                @{@"s" : PointValue(110.75, 63.4),
                                  @"c1" : PointValue(125.44, 69.48),
                                  @"c2" : PointValue(126.61, 69.49),
                                  @"e" : PointValue(143.97, 63.83),
                                  @"d" : @(-1)},
                                //4
                                @{@"s" : PointValue(143.97, 63.83),
                                  @"c1" : PointValue(175.09, 53.67),
                                  @"c2" : PointValue(203.77, 60.18),
                                  @"e" : PointValue(213.8, 79.68),
                                  @"d" : @(1)},
                                //5
                                @{@"s" : PointValue(213.8, 79.68),
                                  @"c1" : PointValue(216.85, 85.62),
                                  @"c2" : PointValue(216.43, 86.75),
                                  @"e" : PointValue(207.92, 95.52),
                                  @"d" : @(-1)},
                                //6
                                @{@"s" : PointValue(207.92, 95.52),
                                  @"c1" : PointValue(185.91, 118.22),
                                  @"c2" : PointValue(188.13, 153.44),
                                  @"e" : PointValue(212.68, 170.95),
                                  @"d" : @(-1)},
                                //7
                                @{@"s" : PointValue(212.68, 170.95),
                                  @"c1" : PointValue(223.11, 178.39),
                                  @"c2" : PointValue(223.46, 182.43),
                                  @"e" : PointValue(215.26, 200.29),
                                  @"d" : @(-1)},
                                //8
                                @{@"s" : PointValue(215.26, 200.29),
                                  @"c1" : PointValue(196.99, 240.05),
                                  @"c2" : PointValue(178.43, 251.51),
                                  @"e" : PointValue(148.17, 241.73),
                                  @"d" : @(-1)},
                                //9
                                @{@"s" : PointValue(148.17, 241.73),
                                  @"c1" : PointValue(132.72, 236.73),
                                  @"c2" : PointValue(126.6, 236.96),
                                  @"e" : PointValue(108.72, 243.23),
                                  @"d" : @(-1)},
                                //10
                                @{@"s" : PointValue(108.72, 243.23),
                                  @"c1" : PointValue(95.78, 247.76),
                                  @"c2" : PointValue(92, 248.02),
                                  @"e" : PointValue(82.3, 245.02),
                                  @"d" : @(-1)},
                                //11
                                @{@"s" : PointValue(122.81, 59.84),
                                  @"c1" : PointValue(115.29, 48.3),
                                  @"c2" : PointValue(133.71, 17.23),
                                  @"e" : PointValue(153.75, 7.62),
                                  @"d" : @(-1)},
                                //12
                                @{@"s" : PointValue(153.75, 7.62),
                                  @"c1" : PointValue(173.57, -1.87),
                                  @"c2" : PointValue(178.95, 2.9),
                                  @"e" : PointValue(172.42, 24.17),
                                  @"d" : @(-1)},
                                //13
                                @{@"s" : PointValue(172.42, 24.17),
                                  @"c1" : PointValue(164.93, 48.55),
                                  @"c2" : PointValue(131.24, 72.78),
                                  @"e" : PointValue(122.81, 59.84),
                                  @"d" : @(-1)},
                               ];
        _bezierArray = @[].mutableCopy;
        _positionArray = @[].mutableCopy;
        
        CGPoint bezierPoint, extraPoint;
        CGFloat t = 0, angle = 0;
        for (NSDictionary *item in AppleLogoBezierData) {
            PWBezier *bezier = [[PWBezier alloc] initWithOrigin:[item[@"s"] CGPointValue]
                                                  controlPoint1:[item[@"c1"] CGPointValue]
                                                  controlPoint2:[item[@"c2"] CGPointValue]
                                                    destination:[item[@"e"] CGPointValue]];
            [_bezierArray addObject:bezier];
            
            NSInteger direction = [item[@"d"] integerValue];
            for (NSInteger i = 0; i < _divisions; i++) {
                t = (CGFloat) i / _divisions;
                bezierPoint = [bezier outputAtT:t];
                angle = [bezier tangentAngleAtT:t];
                [_positionArray addObject:PointValue(bezierPoint.x, bezierPoint.y)];
                
                NSInteger extra = arc4random() % 3 + 2;
                for (NSInteger j = 0; j < extra; j++) {
                    NSInteger lineWidth = arc4random() % 20 + 10;
                    extraPoint.x = bezierPoint.x + lineWidth * cos(angle + direction * M_PI_2);
                    extraPoint.y = bezierPoint.y + lineWidth * sin(angle + direction * M_PI_2);
                    [_positionArray addObject:PointValue(extraPoint.x, extraPoint.y)];
                }
            }
        }
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [UIColor.lightGrayColor setStroke];
    [_bezierArray enumerateObjectsUsingBlock:^(PWBezier *bezier, NSUInteger idx, BOOL * _Nonnull stop) {
        [[bezier bezierPath] stroke];
    }];
}

@end


@interface AppleLogoViewController () {
    AppleLogoView *_appleLogo;
    NSMutableArray *_colorBalls;
}

@end

@implementation AppleLogoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _colorBalls = @[].mutableCopy;
    
//    [self setUpBlBezierView];
    [self setUpAppleLogo];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    [self setUpColorBalls];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self animateColorBalls];
}

- (void)setUpBlBezierView {
    BLBezierView *blBezierView = [[BLBezierView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 400)];
    blBezierView.center = CGPointMake(kScreen_CenterX, kScreen_CenterY);
    [KungFuHelper debugLayer:blBezierView.layer enabled:YES];
    [self.view addSubview:blBezierView];
}

- (void)setUpAppleLogo {
    _appleLogo = [[AppleLogoView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    _appleLogo.center = CGPointMake(kScreen_CenterX, kScreen_CenterY);
    _appleLogo.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_appleLogo];
}

- (void)setUpColorBalls {
    NSArray *posArr = _appleLogo.positionArray.copy;
    ColorBall *ball;
    for (NSValue *posValue in posArr) {
        CGPoint pos = posValue.CGPointValue;
        pos = [_appleLogo convertPoint:pos toView:self.view];
        CGFloat radius = arc4random_uniform(20) + 2;
        ball = [[ColorBall alloc] initWithFrame:CGRectMake(pos.x - radius, kScreen_Height + 100 + _appleLogo.bounds.size.height - posValue.CGPointValue.y, 2 * radius, 2 * radius)];
        [_colorBalls addObject:ball];
        [self.view addSubview:ball];
    }
}

- (void)animateColorBalls {
    NSArray *posArr = _appleLogo.positionArray.copy;
    ColorBall *ball;
    for (NSInteger i = 0; i < _colorBalls.count; i++) {
        @autoreleasepool {
            CGPoint pos = [posArr[i] CGPointValue];
            ball = _colorBalls[i];
            pos = [_appleLogo convertPoint:pos toView:self.view];
            NSTimeInterval upDuration1 = arc4random_uniform(3) / 3.0 + 2;
            [UIView animateWithDuration:upDuration1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                ball.frame = CGRectMake(ball.frame.origin.x, pos.y - ball.radius, ball.bounds.size.width, ball.bounds.size.height);
            } completion:^(BOOL finished) {
                NSTimeInterval upDuration2 = arc4random_uniform(3) / 3.0 + 2;
                [UIView animateWithDuration:upDuration2 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    ball.frame = CGRectMake(ball.frame.origin.x, -100, ball.bounds.size.width, ball.bounds.size.height);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }
    }
}

@end
