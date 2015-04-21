//
//  ImageResizableTestViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/4/11.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "ImageResizableTestViewController.h"

@interface ImageResizableTestViewController ()

@end

@implementation ImageResizableTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 140, 110, 200)];
    [self.view addSubview:imageView];
    imageView.image = [[UIImage imageNamed:@"bj_dropdown"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 9, 9, 110 - 9)];
    
    
    NSString *input = @"0.0";
    NSString *input2 = @"0";
    if (input.integerValue == 0) {
        NSLog(@"0.0 integerValue is 0");
    }
    
    if (input2.integerValue == 0) {
        NSLog(@"0 integerValue is 0");
    }
    
}


@end
