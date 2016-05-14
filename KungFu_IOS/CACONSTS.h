//
//  CACONSTS.h
//  TextTravel
//
//  Created by ChildhoodAndy on 15/2/9.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#ifndef CACONSTS_h
#define CACONSTS_h

#define kScreen_Height                      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width                       ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame                       ([UIScreen mainScreen].bounds)
#define kScreen_CenterX                     kScreen_Width/2
#define kScreen_CenterY                     kScreen_Height/2



#define ARC4RANDOM_MAX      0x100000000
#define RAND_BETWEEN_0_1    ((double)arc4random() / ARC4RANDOM_MAX)

#define RANDOM_COLOR        [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.0]

#endif
