//
//  CAImageScrollView.h
//  CityOfHeart
//
//  Created by ChildhoodAndy on 14-10-19.
//  Copyright (c) 2014年 Qioji-ChildhoodAndy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CAImageScrollViewDelegate <NSObject>

- (void)tappedWithImageScrollView:(id)scrollView;

@end

@interface CAImageScrollView : UIScrollView

@property (nonatomic, weak) id<CAImageScrollViewDelegate> i_delegate;

- (void) setContentWithFrame:(CGRect) rect;
- (void) setImage:(UIImage *) image;
- (void) setAnimationRect;
- (void) rechangeInitRdct;

@end
