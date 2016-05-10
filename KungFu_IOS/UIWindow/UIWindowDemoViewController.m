//
//  UIWindowDemoViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 16/5/10.
//  Copyright © 2016年 ChildhoodAndy. All rights reserved.
//

#import "UIWindowDemoViewController.h"

@interface UIWindowDemoViewController () <UIAlertViewDelegate>

@end

// 测试UIApplication的windows
@implementation UIWindowDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *testBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [testBtn setTitle:@"test button" forState:UIControlStateNormal];
    [testBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(testBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AlertTest" message:@"alert message" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"confirm", nil];
    [alertView show];
    
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows) {
        // 01 UIWindow
        // 02 UITextEffectsWindow
        NSLog(@"window %@, isKeyWindow:%@, windowLevel:%f", window, [window isKeyWindow] ? @"1" : @"0", window.windowLevel);
    }
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    // _UIAlertControllerShimPresenterWindow
    NSLog(@"key window %@, windowLevel:%f", keyWindow, keyWindow.windowLevel);
    
    [self performSelector:@selector(hideAlert) withObject:nil afterDelay:3];
}

- (void)testBtnDidClicked:(UIButton *)button {
    NSLog(@"test btn did clicked...");
}

- (void)hideAlert {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow resignKeyWindow];
    keyWindow.rootViewController = nil;
    keyWindow.hidden = YES;
    [keyWindow removeFromSuperview];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"cancel");
    } else {
        NSLog(@"confirm");
    }
}



@end
