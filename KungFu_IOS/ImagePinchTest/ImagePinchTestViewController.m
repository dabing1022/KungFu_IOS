//
//  ImagePinchTestViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/4/13.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "ImagePinchTestViewController.h"
#import "RSKImageScrollView.h"
#import "CAImageScrollView.h"
#import "DDImageScrollView.h"

@interface ImagePinchTestViewController () <UIScrollViewDelegate>
{
    UITapGestureRecognizer* singleTapGes;
    DDImageScrollView* scrollView;
}

@end

@implementation ImagePinchTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    scrollView = [[DDImageScrollView alloc] initWithFrame:CGRectMake(50, 250, kScreen_Width-100, 200)];
    scrollView.maximumZoomScale = 3;
    scrollView.minimumZoomScale = 1;
    
    UIImage* zoomView = [UIImage imageNamed:@"angrybird.jpg"];
    [scrollView displayImage:zoomView];
    scrollView.contentSize = zoomView.size;
    
    [self.view addSubview:scrollView];
    
    singleTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapGes.numberOfTapsRequired = 1;
    singleTapGes.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:singleTapGes];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)singleTap
{
    CGPoint tapPos = [singleTapGes locationInView:self.view];
    if (!CGRectContainsPoint(scrollView.frame, tapPos)) {
        [scrollView removeFromSuperview];
    }
}


@end
