//
//  HDEFINE.h
//  Fill-Select
//
//  Created by fcz on 2017/8/8.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#ifndef HDEFINE_h
#define HDEFINE_h

#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width


#define Clear [UIColor clearColor]
#define Black [UIColor blackColor]
#define White [UIColor whiteColor]
#define Color(x, a) RGBA(x, x, x, a)
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


#define Font(a) [UIFont systemFontOfSize:a]
#define FontBold(a) [UIFont boldSystemFontOfSize:a]

typedef void (^BasicBlock) (void);
typedef void (^ObjBlock) (id obj);
typedef void (^UIntegerBlock) (NSUInteger x);

#endif /* HDEFINE_h */
