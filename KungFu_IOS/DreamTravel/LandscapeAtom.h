//
//  LandscapeAtom.h
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/3/6.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LandscapeViewType)
{
    LandscapeViewTypeGraphic,
    LandscapeViewTypeText
};

@interface LandscapeAtom : NSObject

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) LandscapeViewType landscapeViewType;
@property (nonatomic, strong) CALayer* landscapeLayer;
@property (nonatomic, strong) NSString* landscapeName;
@property (nonatomic, assign) CGFloat lifeTime;
@property (nonatomic, assign) NSUInteger zIndex;

- (id)initWithFrame:(CGRect)frame landscapeName:(NSString *)landscapeName;

@end
