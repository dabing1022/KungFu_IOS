//
//  GCDTestViewController2.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 16/5/1.
//  Copyright © 2016年 ChildhoodAndy. All rights reserved.
//

#import "GCDTestViewController2.h"

@interface GCDTestViewController2 () {
    UIImage *_image1;
    UIImage *_image2;
}

@end

@implementation GCDTestViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    self.testImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self.view addSubview:self.testImageView];
    self.testImageView.center = CGPointMake(200, 200);
    
//    [self dispatchGroupWay];
    [self dispatchBarrierWay];
}

- (void)dispatchGroupWay {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, globalQueue, ^{
        NSURL *url = [NSURL URLWithString:@"http://f.hiphotos.baidu.com/image/pic/item/d788d43f8794a4c2e882eb8b0df41bd5ac6e39e8.jpg"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        _image1 = [UIImage imageWithData:imageData];
    });
    dispatch_group_async(group, globalQueue, ^{
        NSURL *url = [NSURL URLWithString:@"http://h.hiphotos.baidu.com/image/pic/item/ac6eddc451da81cbd668501c5666d01608243151.jpg"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        _image2 = [UIImage imageWithData:imageData];
    });
    
    dispatch_group_notify(group, globalQueue, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(200, 200), NO, 0);
        [_image1 drawAsPatternInRect:CGRectMake(0, 0, 100, 200)];
        [_image2 drawAsPatternInRect:CGRectMake(100, 0, 100, 200)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.testImageView.image = image;
        });
    });
}

- (void)dispatchBarrierWay {
    dispatch_queue_t queue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:@"http://f.hiphotos.baidu.com/image/pic/item/d788d43f8794a4c2e882eb8b0df41bd5ac6e39e8.jpg"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        _image1 = [UIImage imageWithData:imageData];
    });
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:@"http://h.hiphotos.baidu.com/image/pic/item/ac6eddc451da81cbd668501c5666d01608243151.jpg"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        _image2 = [UIImage imageWithData:imageData];
    });
    
    dispatch_barrier_async(queue, ^{
        
    });
    
    dispatch_async(queue, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(200, 200), NO, 0);
        [_image1 drawAsPatternInRect:CGRectMake(0, 0, 100, 200)];
        [_image2 drawAsPatternInRect:CGRectMake(100, 0, 100, 200)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.testImageView.image = image;
        });
    });
}

@end
