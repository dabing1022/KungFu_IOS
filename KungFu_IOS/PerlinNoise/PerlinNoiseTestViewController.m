//
//  PerlinNoiseTestViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/3/4.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "PerlinNoiseTestViewController.h"
#import "PerlinNoise.h"


#define CELL_WIDTH   5.0
#define CELL_HEIGHT  5.0

@interface PerlinNoiseTestViewController ()
{
    CALayer* noiseLayer;
    PerlinNoise* noise;
    NSUInteger rowsNum;
    NSUInteger colsNum;
}

@end

@implementation PerlinNoiseTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    noise = [[PerlinNoise alloc] initWithSeed:25];

    noiseLayer = [CALayer layer];
    noiseLayer.frame = self.view.bounds;
    noiseLayer.backgroundColor = [UIColor whiteColor].CGColor;
    noiseLayer.contentsScale = [UIScreen mainScreen].scale;
    noiseLayer.delegate = self;
    
    rowsNum = kScreen_Height / CELL_HEIGHT;
    colsNum = kScreen_Width / CELL_WIDTH;
    NSLog(@"rowsNum, colsNum: %@, %@", @(rowsNum), @(colsNum));
    
    [self.view.layer addSublayer:noiseLayer];
    [noiseLayer display];
}

- (void)dealloc
{
    // Don't forget to clear layer's delegate, or it will crash
    noiseLayer.delegate = nil;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    for (NSUInteger i = 0; i < rowsNum; i++) {
        for (NSUInteger j = 0; j < colsNum; j++) {
            CGMutablePathRef path = CGPathCreateMutable();
            CGRect rect = CGRectMake(CELL_WIDTH*j, CELL_HEIGHT*i, CELL_WIDTH, CELL_HEIGHT);
            CGPathAddRect(path, NULL, rect);
            CGContextAddPath(ctx, path);
            CGFloat c = [noise perlin2DValueForPoint:i :j];
            UIColor* color = nil;
            if (c > 0.8) {
                color = [UIColor colorWithRed:0 green:c blue:0 alpha:1.0];
            } else if (c > 0.2) {
                color = [UIColor colorWithRed:c green:0 blue:0 alpha:1.0];
            } else {
                color = [UIColor colorWithRed:0 green:0 blue:c alpha:1.0];
            }
            CGContextSetFillColorWithColor(ctx, color.CGColor);
            CGContextFillPath(ctx);
            CGPathRelease(path);
        }
    }
}

@end
