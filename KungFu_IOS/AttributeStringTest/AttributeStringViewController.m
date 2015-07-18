//
//  AttributeStringViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/4/28.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "AttributeStringViewController.h"
#include <sys/sysctl.h>

@interface AttributeStringViewController ()
{
    UILabel *label;
}
@end

@implementation AttributeStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    NSString *str = @"33.00";
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.backgroundColor = [UIColor clearColor];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22.0] range:NSMakeRange(0, str.length - 2)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0] range:NSMakeRange(str.length - 2, 2)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, str.length - 2)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(str.length - 2, 2)];
    
    label.attributedText = attrStr;
    [label sizeToFit];
    
    [self.view addSubview:label];
    
    label.layer.borderColor = [UIColor greenColor].CGColor;
    label.layer.borderWidth = 1.0f;
    
    NSString *platform = [self getPlatform];
    NSLog(@"platform: %@", platform);
    
    
    NSString *test = @"12345678";
    test = [test substringToIndex:5];
    NSLog(@"test %@", test);
    
    NSString *test2 = @"123";
    test2 = [test2 substringToIndex:2];
    NSLog(@"test2 %@", test2);
}


- (NSString *)getPlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

@end
