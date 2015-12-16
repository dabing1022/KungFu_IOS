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
    self.view.backgroundColor = [UIColor whiteColor];
    
    isFaceFront = YES;
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    containerView.backgroundColor = [UIColor clearColor];
    containerView.tintColor = [UIColor blueColor];
    [self.view addSubview:containerView];
    
    imageViewFront = [[UIImageView alloc] initWithFrame:containerView.bounds];
    imageViewFront.image = [UIImage imageNamed:@"ClockFace"];
    [containerView addSubview:imageViewFront];
    
    imageViewBack = [[UIImageView alloc] initWithFrame:containerView.bounds];
    imageViewBack.image = [UIImage imageNamed:@"Snowman"];
    [containerView addSubview:imageViewBack];
    imageViewBack.hidden = YES;
    NSLog(@"test %d", imageViewFront.window ? 1 : 0);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self flipImageView];
}

- (void)flipImageView {
//    UIViewAnimationOptions option = isFaceFront ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft;
//    option |= UIViewAnimationOptionCurveEaseInOut;
//    [UIView transitionWithView:containerView duration:0.4 options:option animations:^{
//        containerView.superview.backgroundColor = [UIColor whiteColor];
//        if (isFaceFront) {
//            imageViewFront.hidden = YES;
//            imageViewBack.hidden = NO;
//        } else {
//            imageViewFront.hidden = NO;
//            imageViewBack.hidden = YES;
//        }
//    } completion:^(BOOL finished) {
//        if (finished) {
//            isFaceFront = !isFaceFront;
//        }
//    }];
    
    [UIView flipTransitionFromView:imageViewFront toView:imageViewBack duration:0.4 completion:^(BOOL finished) {
        if (finished) {
            isFaceFront = !isFaceFront;
        }
    }];
}
@end


@implementation UIView (UIView_FlipTransition)

+ (void)flipTransitionFromView:(UIView *)firstView toView:(UIView *)secondView duration:(float)aDuration completion:(void (^)(BOOL finished))completion {
    firstView.layer.doubleSided = NO;
    secondView.layer.doubleSided = NO;
    
    firstView.layer.zPosition = firstView.layer.bounds.size.width / 2;
    secondView.layer.zPosition = secondView.layer.bounds.size.width / 2;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0f/500.0f;
    
    CGAffineTransform translation = CGAffineTransformMakeTranslation(secondView.layer.position.x - firstView.layer.position.x, secondView.layer.position.y - firstView.layer.position.y);
    
    CGAffineTransform scaling = CGAffineTransformMakeScale(secondView.bounds.size.width / firstView.bounds.size.width, secondView.bounds.size.height / firstView.bounds.size.height);
    
    CATransform3D rotation = CATransform3DRotate(transform, -0.999 * M_PI, 1.0f, 0.0f, 0.0f);
    
    CATransform3D firstViewTransform = CATransform3DConcat(rotation, CATransform3DMakeAffineTransform(CGAffineTransformConcat(scaling, translation)));
    
    CATransform3D secondViewTransform = CATransform3DConcat(CATransform3DInvert(rotation), CATransform3DMakeAffineTransform(CGAffineTransformConcat(CGAffineTransformInvert(scaling), CGAffineTransformInvert(translation))));
    
    if (secondView.hidden)
    {
        secondView.layer.transform = secondViewTransform;
    }
    
    firstView.hidden = NO;
    secondView.hidden = NO;
    
    CATransform3D firstToTransform = firstViewTransform;
    CATransform3D secondToTransform = CATransform3DIdentity;
    BOOL firstViewWillHide = YES;
    
    if (CATransform3DIsIdentity(secondView.layer.transform))
    {
        firstToTransform = CATransform3DIdentity;
        secondToTransform = secondViewTransform;
        firstViewWillHide = NO;
    }
    
    [UIView animateWithDuration:aDuration
                     animations:^(void){
                         firstView.layer.transform = firstToTransform;
                         secondView.layer.transform = secondToTransform;
                     }
                     completion:^(BOOL finished) {
                         firstView.hidden = firstViewWillHide;
                         secondView.hidden = !firstView.hidden;
                         if (completion)
                             completion(finished);
                     }];
}

@end
