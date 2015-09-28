//
//  UIImageViewFlipTestViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/9/28.
//  Copyright © 2015年 ChildhoodAndy. All rights reserved.
//

#import "UIImageViewFlipTestViewController.h"

@interface UIImageViewFlipTestViewController () {
    UIView *containerView;
    UIImageView *imageViewFront;
    UIImageView *imageViewBack;
    
    BOOL isFaceFront;
}

@end

@implementation UIImageViewFlipTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    isFaceFront = YES;
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:containerView];
    
    imageViewFront = [[UIImageView alloc] initWithFrame:containerView.bounds];
    imageViewFront.image = [UIImage imageNamed:@"ClockFace"];
    [containerView addSubview:imageViewFront];
    
    imageViewBack = [[UIImageView alloc] initWithFrame:containerView.bounds];
    imageViewBack.image = [UIImage imageNamed:@"Snowman"];
    [containerView addSubview:imageViewBack];
    imageViewBack.hidden = YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self flipImageView];
}

- (void)flipImageView {
    UIViewAnimationOptions option = isFaceFront ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft;
    option |= UIViewAnimationOptionCurveEaseInOut;
    [UIView transitionWithView:containerView duration:0.4 options:option animations:^{
        if (isFaceFront) {
            imageViewFront.hidden = YES;
            imageViewBack.hidden = NO;
        } else {
            imageViewFront.hidden = NO;
            imageViewBack.hidden = YES;
        }
    } completion:^(BOOL finished) {
        if (finished) {
            isFaceFront = !isFaceFront;
        }
    }];
}


@end
