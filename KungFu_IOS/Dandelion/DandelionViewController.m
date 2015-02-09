//
//  DandelionViewController.m
//  ParticleSystemDemos
//
//  Created by ChildhoodAndy on 15/2/4.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "DandelionViewController.h"

@interface DandelionViewController ()

@end

@implementation DandelionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    CAEmitterLayer* emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = CGPointMake(0, self.view.bounds.size.height);
    emitterLayer.emitterZPosition = 10;
    emitterLayer.emitterSize = CGSizeMake(self.view.bounds.size.width, 0);
    emitterLayer.emitterShape = kCAEmitterLayerSphere;
    
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    emitterCell.scale = 1;
    emitterCell.scaleRange = 0.5;
    emitterCell.spin = 0.5;
    emitterCell.spinRange = 0.5;
    emitterCell.emissionRange = (CGFloat)M_PI_2;
    emitterCell.lifetime = 7.0;
    emitterCell.birthRate = 1;
    emitterCell.velocity = 80;
    emitterCell.velocityRange = 50;
    emitterCell.yAcceleration = -50;
    
    emitterCell.contents = (id)[[UIImage imageNamed:@"particleTexture.png"] CGImage];
    emitterLayer.emitterCells = [NSArray arrayWithObject:emitterCell];
    [self.view.layer addSublayer:emitterLayer];
}



@end
