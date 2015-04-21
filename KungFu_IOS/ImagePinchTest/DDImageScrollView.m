//
//  DDImageScrollView.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/4/13.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "DDImageScrollView.h"

@interface DDImageScrollView ()
{
    UITapGestureRecognizer* doubleTapGes;
}

@end

@implementation DDImageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.alwaysBounceHorizontal = YES;
        self.alwaysBounceVertical = YES;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        
        doubleTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTapGes.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTapGes];
    }
    
    return self;
}

- (void)displayImage:(UIImage *)image
{
    [_zoomView removeFromSuperview];
    _zoomView = nil;
    
    self.zoomScale = 1.0;
    _zoomView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:_zoomView];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)doubleTap {
    CGRect frame = CGRectZero;
    CGPoint location;
    CGFloat scale;
    
    if(self.zoomScale == self.minimumZoomScale)
    {
        scale = self.maximumZoomScale;
        location = [doubleTap locationInView:self.zoomView];
        frame = CGRectMake(location.x*self.maximumZoomScale - self.bounds.size.width/2, location.y*self.maximumZoomScale - self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height);
    }
    else
    {
        scale = self.minimumZoomScale;
    }
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void) {
                         self.zoomScale = scale;
                         [self layoutIfNeeded];
                         if(scale == self.maximumZoomScale)
                         {
                             [self scrollRectToVisible:frame animated:NO];
                         }
                     }
                     completion:nil];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.zoomView;
}

@end
