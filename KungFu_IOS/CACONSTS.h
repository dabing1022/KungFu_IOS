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

#endif
