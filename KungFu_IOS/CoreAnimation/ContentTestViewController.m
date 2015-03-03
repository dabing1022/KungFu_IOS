//
//  ContentTestViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/2/15.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "ContentTestViewController.h"
#import "CACONSTS.h"

@interface ContentTestViewController ()
{
    UIView* layerView;
    UISlider* contentsGravitySlider;
    UILabel* curContentsGravityLabel;
    NSArray* contentsGravityArr;
}
@end

@implementation ContentTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    contentsGravityArr = @[kCAGravityCenter, kCAGravityTop, kCAGravityBottom, kCAGravityLeft, kCAGravityRight, kCAGravityTopLeft, kCAGravityTopRight, kCAGravityBottomLeft, kCAGravityBottomRight, kCAGravityResize, kCAGravityResizeAspect, kCAGravityResizeAspectFill];

    NSUInteger width = 200;
    NSUInteger height = 200;
    layerView = [[UIView alloc] initWithFrame:CGRectMake((kScreen_Width-width)/2, (kScreen_Height-height)/2, width, height)];
    layerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:layerView];
    
    // Snowman 200 * 280
    UIImage* image = [UIImage imageNamed:@"Snowman.png"];
    layerView.layer.contents = (__bridge id)image.CGImage;
    layerView.layer.contentsGravity = contentsGravityArr[0];
    layerView.layer.contentsScale = [UIScreen mainScreen].scale;
    
    curContentsGravityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, kScreen_Width, 40)];
    curContentsGravityLabel.backgroundColor = [UIColor clearColor];
    curContentsGravityLabel.text = layerView.layer.contentsGravity;
    curContentsGravityLabel.textColor = [UIColor yellowColor];
    curContentsGravityLabel.font = [UIFont systemFontOfSize:30];
    curContentsGravityLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:curContentsGravityLabel];
    
    contentsGravitySlider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMinX(layerView.frame), kScreen_Height-100, width, 20)];
    contentsGravitySlider.minimumValue = 0;
    contentsGravitySlider.maximumValue = contentsGravityArr.count - 1;

    [self.view addSubview:contentsGravitySlider];
    [contentsGravitySlider addTarget:self action:@selector(changeContentsGravity:) forControlEvents:UIControlEventValueChanged];
}

- (void)changeContentsGravity:(UISlider *)slider
{
    NSString* contentsGravity = contentsGravityArr[(int)slider.value];
    curContentsGravityLabel.text = contentsGravity;
    layerView.layer.contentsGravity = contentsGravity;
}

@end
