//
//  ImplicitAnimationsViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/3/8.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "ImplicitAnimationsViewController.h"

@interface ImplicitAnimationsViewController ()
{
    CALayer* colorLayer;
    
    UIButton* changeColorLayerBtn;
    UIButton* changeViewColorBtn;
}
@end

@implementation ImplicitAnimationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    colorLayer = [CALayer layer];
    colorLayer.frame = CGRectMake(50, 60, 100, 100);
    colorLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:colorLayer];
    
    changeColorLayerBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(colorLayer.frame)-40, CGRectGetMaxY(colorLayer.frame) + 10, CGRectGetWidth(colorLayer.frame)+80, 30)];
    [changeColorLayerBtn setTitle:@"changeLayerColor" forState:UIControlStateNormal];
    [changeColorLayerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeColorLayerBtn setBackgroundColor:[UIColor yellowColor]];
    [changeColorLayerBtn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeColorLayerBtn];
    
    changeViewColorBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    changeViewColorBtn.center = CGPointMake(kScreen_CenterX, kScreen_CenterY);
    [changeViewColorBtn setTitle:@"changeViewColor" forState:UIControlStateNormal];
    [changeViewColorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeViewColorBtn setBackgroundColor:[UIColor yellowColor]];
    [changeViewColorBtn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeViewColorBtn];
}

- (void)changeColor:(UIButton *)button
{
    if (button == changeColorLayerBtn) {
        // 我们把改变属性时 CALayer 自动应用的动画称作行为
        
        // 我们把改变属性时 CALayer 自动应用的动画称作行为,当 CALayer 的属性被修改时候,它会调用 ‐actionForKey: 方法,传 递属性的名称。剩下的操作都在 CALayer 的头文件中有详细的说明,实质上是如下几步:
        // 1.图层首先检测它是否有委托,并且是否实现 CALayerDelegate 协议指定的 ‐actionForLayer:forKey 方法。如果有,直接 调用并返回结果。
        // 2.如果没有委托,或者委托没有实现 ‐actionForLayer:forKey 方法,图层接着检查包含属性名称对应行为映射的 ￼actions 字典。
        // 3.如果 ￼actions 字典没有包含对应的属性,那么图层接着在它的 style 字典接着搜索属性名。
        // 4.最后,如果在 ￼style 里面也找不到对应的行为,那么图层将会直接调用定义了每个属性的标准行为的 ‐defaultActionForKey: 方法。
        [CATransaction begin];
        [CATransaction setAnimationDuration:1.0]; // default 0.25s
        
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
        
        [CATransaction setCompletionBlock:^{
            // 旋转使用默认的CATranscation，动画时间为0.25s
            CGAffineTransform transform = colorLayer.affineTransform;
            transform = CGAffineTransformRotate(transform, M_PI_2);
            colorLayer.affineTransform = transform;
        }];
        
        [CATransaction commit];
    } else if (button == changeViewColorBtn) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:1.0];
        
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        self.view.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
        
        [CATransaction commit];
    }
}

@end
