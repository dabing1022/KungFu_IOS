//
//  FuntionalMacro.h
//  KungFu_IOS
//
//  Created by ChildhoodAndy on 15/3/6.
//  Copyright (c) 2015年 ChildhoodAndy. All rights reserved.
//

#ifndef KungFu_IOS_FuntionalMacro_h
#define KungFu_IOS_FuntionalMacro_h

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define DLog(fmt, ...) NSLog((@"\n[文件名:%s]\n""[函数名:%s]\n""[行号:%d] \n" fmt), __FILE__, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#define DebugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define DLog(...)
#define ULog(...)
#define DebugMethod()
#endif

#define ALog(fmt, ...) NSLog((@"\n[文件名:%s]\n""[函数名:%s]\n""[行号:%d] \n" fmt), __FILE__, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#endif
