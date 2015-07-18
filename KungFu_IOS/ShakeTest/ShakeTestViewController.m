//
//  ShakeTestViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/7/18.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "ShakeTestViewController.h"
#import "ShakeResponderView.h"

@interface ShakeTestViewController () {
    ShakeResponderView *shakeView;
}

@end

@implementation ShakeTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    shakeView = [[ShakeResponderView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:shakeView];
    shakeView.shakeEnabled = YES;
}

@end
