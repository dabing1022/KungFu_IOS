//
//  SimpleClockViewController.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/2/15.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "SimpleClockViewController.h"

@interface SimpleClockViewController ()
{
    UIImageView* clockFace;
    UIImageView* hourHand;
    UIImageView* minHand;
    UIImageView* secHand;
    
    NSTimer* timer;
    NSCalendar* calendar;
    NSUInteger calendarUnit;
    NSDateComponents* dateComponent;
}

@end

@implementation SimpleClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    clockFace = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ClockFace"]];
    clockFace.center = CGPointMake(kScreen_Width/2, kScreen_Height/2);
    [self.view addSubview:clockFace];
    
    hourHand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HourHand"]];
    hourHand.center = clockFace.center;
    hourHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    [self.view addSubview:hourHand];
    
    minHand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MinuteHand"]];
    minHand.center = clockFace.center;
    minHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    [self.view addSubview:minHand];
    
    secHand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SecondHand"]];
    secHand.center = clockFace.center;
    secHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    [self.view addSubview:secHand];
    
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendarUnit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    [self tick:nil];
    
    timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)tick:(NSTimer *)timer
{
    dateComponent = [calendar components:calendarUnit fromDate:[NSDate date]];
    
    CGFloat hourAngle = (dateComponent.hour / 12.0) * M_PI * 2;
    CGFloat minAngle = (dateComponent.minute / 60.0) * M_PI * 2;
    CGFloat secAngle = (dateComponent.second / 60.0) * M_PI * 2;
    
    hourHand.transform = CGAffineTransformMakeRotation(hourAngle);
    minHand.transform = CGAffineTransformMakeRotation(minAngle);
    secHand.transform = CGAffineTransformMakeRotation(secAngle);
}

@end
