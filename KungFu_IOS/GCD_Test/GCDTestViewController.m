//
//  GCDTestViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/11/5.
//  Copyright © 2015年 ChildhoodAndy. All rights reserved.
//

#import "GCDTestViewController.h"

@interface GCDTestViewController ()

@end

@implementation GCDTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    
    // 依次注释01、02、03、04来观察运行效果
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t serialQueue = dispatch_queue_create("mySerialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t concurrentQueue = dispatch_queue_create("myConcurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    // 01
//    for (NSInteger i = 0; i < 1000; i++) {
//        [self doSomethingHeavey:@(i)];
//    }
    
    // 02
//    for (NSInteger i = 0; i < 1000; i++) {
//        dispatch_async(queue, ^{
//            [self doSomethingHeavey:@(i)];
//        });
//    }
    
    // 03
//    dispatch_group_t group = dispatch_group_create();
//    for (NSInteger i = 0; i < 1000; i++) {
//        dispatch_group_async(group, queue, ^{
//            [self doSomethingHeavey:@(i)];
//        });
//    }
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//    [self doSomethingAfterHeavyWork];
    
    // 04
    dispatch_group_t group = dispatch_group_create();
    for (NSInteger i = 0; i < 1000; i++) {
        dispatch_group_async(group, queue, ^{
            [self doSomethingHeavey:@(i)];
        });
    }
    dispatch_group_notify(group, queue, ^{
        [self doSomethingAfterHeavyWork];
    });
    
    [self performSelector:@selector(logSomething:) withObject:@(YES) afterDelay:2];
    
    
    dispatch_async(serialQueue, ^(void) {
       for (int i = 0 ; i < 100; i ++)
       {
           NSLog(@"%@=========%d"  , [NSThread currentThread] , i);
       }
    });
    dispatch_async(serialQueue, ^(void) {
       for (int i = 0 ; i < 100; i ++)
       {
           NSLog(@"%@---------%d" , [NSThread currentThread] , i);
       }
    });
    
    dispatch_async(concurrentQueue, ^(void) {
       for (int i = 0 ; i < 100; i ++)
       {
           NSLog(@"%@**********%d"  , [NSThread currentThread] , i);
       }
    });
    dispatch_async(concurrentQueue, ^(void) {
       for (int i = 0 ; i < 100; i ++)
       {
           NSLog(@"%@##########%d" , [NSThread currentThread] , i);
       }
    });
}

- (void)doSomethingHeavey:(id)obj {
    NSLog(@"obj %@", obj);
}

- (void)doSomethingAfterHeavyWork {
    NSLog(@"work after heavy work done...");
}

- (void)logSomething:(NSNumber *)log {
    if (log.boolValue) {
        NSLog(@"log something right");
    } else {
        NSLog(@"long something wrong");
    }
}

@end
