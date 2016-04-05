//
//  RuntimeMethodForwardDemoViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 16/4/5.
//  Copyright © 2016年 ChildhoodAndy. All rights reserved.
//

#import "RuntimeMethodForwardDemoViewController.h"
#import <objc/runtime.h>

@interface Replacement : NSObject

@end

@implementation Replacement

- (void)helloWorld {
    NSLog(@"hello world from replacement.");
}

@end

@implementation RuntimeMethodForwardDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self helloWorld];
}

//-----------------------------------------------------------
// 01 step
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selectorString = NSStringFromSelector(sel);
    
    if ([selectorString isEqualToString:@"helloWorld"]) {
        class_addMethod(self, sel, (IMP)dynamicMethodTry, "@@:");
    }
    
    return YES;
}

id dynamicMethodTry(id self, SEL _cmd) {
    NSLog(@"First, try to add method dynamically");
    return @"First, try to add method dynamically";
}

//-----------------------------------------------------------
// 02 step
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return [Replacement new];
}

//-----------------------------------------------------------
// 03 step
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        if ([self respondsToSelector:@selector(anotherHelloWorld)]) {
            signature = [[self class] instanceMethodSignatureForSelector:@selector(anotherHelloWorld)];
        }
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation setSelector:@selector(anotherHelloWorld)];
    [anInvocation invokeWithTarget:self];
}

- (void)anotherHelloWorld {
    NSLog(@"A ha, this is another hello world");
}

@end
