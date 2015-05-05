//
//  KungFuDateTest.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/4/23.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface KungFuDateTest : XCTestCase

@end

@implementation KungFuDateTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    NSString *historyTime = @"20150423190800";
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *historyDate = [dateFormatter dateFromString:historyTime];
    NSLog(@"historyDate: %@", historyDate);
    
    NSDate *now = [NSDate date];
    NSUInteger min = ([now timeIntervalSinceReferenceDate] - [historyDate timeIntervalSinceReferenceDate]) / 60;
    NSLog(@"min: %@", @(min));
}


@end
