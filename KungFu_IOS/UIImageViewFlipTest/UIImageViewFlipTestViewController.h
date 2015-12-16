//
//  UIImageViewFlipTestViewController.h
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/9/28.
//  Copyright © 2015年 ChildhoodAndy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageViewFlipTestViewController : UIViewController

@end

@interface UIView (UIView_FlipTransition)

+ (void)flipTransitionFromView:(UIView *)firstView toView:(UIView *)secondView duration:(float)aDuration completion:(void (^)(BOOL finished))completion;

@end
