//
//  InteractiveCardDemoViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 16/5/12.
//  Copyright © 2016年 ChildhoodAndy. All rights reserved.
//

#import "InteractiveCardDemoViewController.h"

@interface InteractiveView : UIImageView

@property (nonatomic, strong) UIView *gestureView;

@end

@implementation InteractiveView

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.layer.cornerRadius = 6.0f;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [[UIColor redColor] CGColor];
        self.layer.borderWidth = 1.0f;
    }
    
    return self;
}

- (void)setGestureView:(UIView *)gestureView {
    _gestureView = gestureView;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    [_gestureView addGestureRecognizer:pan];
}

#define SCROLLDISTANCE 200.0f
- (void)panHandler:(UIPanGestureRecognizer *)panGes {
    static CGPoint startPoint;
    CGFloat factorOfAngle = 0.0f;
    CGFloat factorOfScale = 0.0f;
    CGPoint translation = [panGes translationInView:panGes.view];
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        startPoint = self.center;
    } else if (panGes.state == UIGestureRecognizerStateChanged) {
        self.center = CGPointMake(startPoint.x + translation.x, startPoint.y + translation.y);
        
        CGFloat maxY = MIN(SCROLLDISTANCE, MAX(0, ABS(translation.y)));
        factorOfAngle = MAX(0,-4/(SCROLLDISTANCE*SCROLLDISTANCE)*maxY*(maxY-SCROLLDISTANCE));
        factorOfScale = MAX(0,-1/(SCROLLDISTANCE*SCROLLDISTANCE)*maxY*(maxY-2*SCROLLDISTANCE));
        
        CATransform3D t = CATransform3DIdentity;
        t.m34  = -1.0f / 500.0f;
        t = CATransform3DRotate(t, factorOfAngle*(M_PI / 5), translation.y > 0 ? -1 : 1, 0, 0);
        t = CATransform3DScale(t, 1 - factorOfScale * 0.2, 1 - factorOfScale * 0.2, 0);
        self.layer.transform = t;
    } else if (panGes.state == UIGestureRecognizerStateEnded || panGes.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.layer.transform = CATransform3DIdentity;
            self.center = startPoint;
        } completion:^(BOOL finished) {
            
        }];
    }
}

@end

@interface InteractiveCardDemoViewController ()

@end

@implementation InteractiveCardDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    InteractiveView *interactiveView = [[InteractiveView alloc]initWithImage:[UIImage imageNamed:@"cocos2d"]];
    interactiveView.center = self.view.center;
    interactiveView.bounds = CGRectMake(0, 0, 200, 150);
    interactiveView.gestureView = self.view;
    
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    [backView addSubview:interactiveView];
    [self.view addSubview:backView];
}

@end
