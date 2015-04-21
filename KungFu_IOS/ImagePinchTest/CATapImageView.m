//
//  CATapImageView.m
//  CityOfHeart
//
//  Created by ChildhoodAndy on 14-10-19.
//  Copyright (c) 2014年 Qioji-ChildhoodAndy. All rights reserved.
//

#import "CATapImageView.h"

@implementation CATapImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        [self addGestureRecognizer:tap];
        
        self.clipsToBounds = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)imageTapped:(UITapGestureRecognizer*)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tappedWithImageView:)]) {
        [self.delegate performSelector:@selector(tappedWithImageView:) withObject:self];
    }
}

- (void)dealloc
{
    self.delegate = nil;
}

@end
