//
//  CardView.h
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/7/18.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CardViewLeaveWay)
{
    CardViewLeaveWayLeft,
    CardViewLeaveWayRight
};

@interface CardView : UIView

@property (nonatomic, assign) CardViewLeaveWay leaveWay;

- (void)show;
- (void)dismiss;

@end
