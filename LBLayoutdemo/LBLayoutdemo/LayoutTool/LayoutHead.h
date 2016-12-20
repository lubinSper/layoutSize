//
//  LayoutHead.h
//  LBLayoutdemo
//
//  Created by Mianji.Gu on 16/12/20.
//  Copyright © 2016年 lb. All rights reserved.
//

#ifndef LayoutHead_h
#define LayoutHead_h


/* 不同的IPHONE屏幕尺寸 */
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0f)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0f)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0f)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0f)
#define IS_IPHONE_5_ABOVE (IS_IPHONE_6P || IS_IPHONE_6 || IS_IPHONE_5)
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

#endif /* LayoutHead_h */
