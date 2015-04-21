//
//  RuntimeDemoViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/4/12.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "RuntimeDemoViewController.h"
#import <objc/runtime.h>
#import "NSArray+Swizzle.h"

@interface TestClass1 : NSObject

- (void)method1;
- (void)method2:(NSString *)name;

@end

@implementation TestClass1

- (void)method1
{
    NSLog(@"method1...");
}

- (void)method2:(NSString *)name
{
    NSLog(@"name is %@", name);
}

@end

@interface TestClass2 : NSObject

- (void)method3;
- (void)method4;

@end

@implementation TestClass2

- (void)method3
{
    NSLog(@"method3...");
}

- (void)method4
{
    NSLog(@"method4...");
}

@end

@interface RuntimeDemoViewController ()

@end

@implementation RuntimeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    Method ori_method = class_getClassMethod([NSArray class], @selector(lastObject));
    Method my_method = class_getClassMethod([NSArray class], @selector(myLastObject));
    method_exchangeImplementations(ori_method, my_method);
        
    NSArray *array = @[@"0",@"1",@"2",@"3"];
    NSString *string = [array lastObject];
    NSLog(@"TEST RESULT : %@",string);
}

@end
