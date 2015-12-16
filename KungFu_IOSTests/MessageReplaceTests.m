//
//  MessageReplaceTests.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/11/13.
//  Copyright © 2015年 ChildhoodAndy. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface MessageReplaceTests : XCTestCase

@end

@implementation MessageReplaceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMessageReplace {
    NSString *oldMessage = @"捎句话1；捎句话2；已加5元感谢费";
    NSArray *msgArr = [oldMessage componentsSeparatedByString:@"；"];
    NSString *newMessage = nil;
    NSInteger newThanksFee = 30;
    if (msgArr.count > 0) {
        NSString *oldThanksInfo = (NSString *)msgArr.lastObject;
        
        NSError *error;
        NSRegularExpression *thanksRegE = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+" options:NSRegularExpressionCaseInsensitive error:&error];
        if (!error) {
            NSTextCheckingResult *firstMatch = [thanksRegE firstMatchInString:oldThanksInfo options:NSMatchingReportProgress range:NSMakeRange(0, oldThanksInfo.length)];
            if (firstMatch) {
                NSRange thanksfeeNumberRange = [firstMatch rangeAtIndex:0];
                NSString *oldThanksfeeStr = [oldThanksInfo substringWithRange:thanksfeeNumberRange];
                newMessage = [oldMessage stringByReplacingOccurrencesOfString:oldThanksfeeStr withString:[NSString stringWithFormat:@"%@", @(newThanksFee)]];
            }
        }
    } else {
        newMessage = oldMessage;
    }
    
    XCTAssertTrue(newMessage);
    NSLog(@"new message : %@", newMessage);

}

@end
