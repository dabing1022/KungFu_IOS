//
//  CATapImageView.h
//  CityOfHeart
//
//  Created by ChildhoodAndy on 14-10-19.
//  Copyright (c) 2014年 Qioji-ChildhoodAndy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CATapImageViewDelegate <NSObject>

- (void)tappedWithImageView:(id)imageView;

@end

@interface CATapImageView : UIImageView

@property (nonatomic, weak) id<CATapImageViewDelegate> delegate;

@end
