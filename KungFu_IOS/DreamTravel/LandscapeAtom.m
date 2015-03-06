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
    self = [super initWithFrame:frame];
    if (self) {
        _landscapeName = landscapeName;
        _landscapeViewType = LandscapeViewTypeText;
        
        [self addLandscapeViewWithText];
    }
    
    return self;
}

- (void)addLandscapeViewWithText
{
    UILabel* landscapeLabel = [[UILabel alloc] initWithFrame:self.bounds];
    landscapeLabel.text = _landscapeName;
    landscapeLabel.textColor = [UIColor blackColor];
    landscapeLabel.textAlignment = NSTextAlignmentLeft;
    landscapeLabel.backgroundColor = [UIColor clearColor];
    landscapeLabel.font = [UIFont systemFontOfSize:25];
    
    _landscapeView = landscapeLabel;
    [self addSubview:_landscapeView];
}


@end
