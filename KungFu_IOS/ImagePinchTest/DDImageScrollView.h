//
//  DDImageScrollView.h
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/4/13.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDImageScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *zoomView;

- (void)displayImage:(UIImage *)image;

@end
