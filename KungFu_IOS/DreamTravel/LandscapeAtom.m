//
//  LandscapeAtom.m
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/3/6.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#import "LandscapeAtom.h"

@implementation LandscapeAtom

- (id)initWithFrame:(CGRect)frame landscapeName:(NSString *)landscapeName
{
    self = [super init];
    if (self) {
        _frame = frame;
        _landscapeName = landscapeName;
        _landscapeViewType = LandscapeViewTypeText;
        
        [self initLandscapeLayerWithText];
    }
    
    return self;
}

- (void)initLandscapeLayerWithText
{   
    CATextLayer* landscapeLayer = [CATextLayer layer];
    landscapeLayer.frame = _frame;
    landscapeLayer.string = _landscapeName;
    landscapeLayer.foregroundColor = [UIColor blackColor].CGColor;
    landscapeLayer.alignmentMode = kCAAlignmentLeft;
    landscapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    UIFont* font = [UIFont systemFontOfSize:25];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    landscapeLayer.font = fontRef;
    landscapeLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    _landscapeLayer = landscapeLayer;
}


@end
