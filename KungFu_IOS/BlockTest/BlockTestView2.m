//
//  BlockTestView2.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 16/6/15.
//  Copyright © 2016年 ChildhoodAndy. All rights reserved.
//

#import "BlockTestView2.h"

@interface BlockTestView2 ()

@property (readonly) int val;
@property (nonatomic, strong) id obj;

@property (strong) dispatch_block_t work;

@end

@implementation BlockTestView2

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _obj = @1;
        [self setup];
    }
    
    return self;
}

- (void)setup {
    _val = 5;
    
    // retain cycle
    self.work = ^{
        NSLog(@"BlockTestView2 %d", _val);
    };
}

// 1. Scoping
// Avoid capturing self
- (void)setup1 {
    int local = self.val;
    self.work = ^{
        NSLog(@"BlockTestView2 %d", local);
    };
}

// 2. Programmatically
// nil the block property
- (void)setup2 {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
    self.work = ^{
        NSLog(@"BlockTestView2 %d", _val);
    };
#pragma clang diagnostic pop
    
    // nil the block property somewhere, please ignore
    // this call at this point
    [self cancel];
}
- (void)cancel {
    self.work = nil;
}

// 3. Attributes
// Use __weak
- (void)setup3 {
    __weak __typeof(self) weakSelf = self;
    self.work = ^{
        __strong __typeof(self) strongSelf = weakSelf;
        NSLog(@"BlockTestView2 %@", strongSelf.obj);
    };
}

- (void)someMethodBlock:(int (^)(int))addByOneBlock {
    
}


@end
