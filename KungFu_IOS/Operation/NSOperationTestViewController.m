//
//  NSOperationTestViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 16/3/20.
//  Copyright © 2016年 ChildhoodAndy. All rights reserved.
//

#import "NSOperationTestViewController.h"

@interface MyTask : NSOperation

@property (nonatomic, assign) NSInteger operationID;

@end

@implementation MyTask

- (void)main {
    if (!self.isCancelled) {
        @autoreleasepool {
            NSLog(@"Task begin...%@", @(self.operationID));
            [NSThread sleepForTimeInterval:3];
            NSLog(@"Task end...%@", @(self.operationID));
        }
    }
}

@end

@interface NSOperationTestViewController ()

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation NSOperationTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.queue = [[NSOperationQueue alloc] init];
    self.queue.name = @"custom queue name";
    
    MyTask *task1 = [[MyTask alloc] init];
    task1.operationID = 1;
    [self.queue addOperation:task1];
    
    MyTask *task2 = [[MyTask alloc] init];
    task2.operationID = 2;
    [task2 addDependency:task1];
    [self.queue addOperation:task2];
}

@end
