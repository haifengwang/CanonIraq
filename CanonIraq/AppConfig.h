//
//  AppConfig.h
//  CanonIraq
//  用于项目共有的宏配置
//  Created by onskyline on 14-6-10.
//  Copyright (c) 2014年 onskyline. All rights reserved.
//

#import <Foundation/Foundation.h>

//IOS版本号
#define versionNO [[[UIDevice currentDevice]systemVersion]doubleValue]
//屏幕的宽
#define screenWidth  [[UIScreen mainScreen]bounds].size.width
//屏幕的高
#define screenHight [[UIScreen mainScreen]bounds].size.height
//适配的frame
#define fitFrame versionNO>=7.0?CGRectMake(0, [[UIScreen mainScreen]bounds].size.height -[[UIScreen mainScreen]applicationFrame].size.height , [[UIScreen mainScreen]bounds].size.width ,[[UIScreen mainScreen]applicationFrame].size.height):[[UIScreen mainScreen]bounds];

#define screenFrame [[UIScreen mainScreen]bounds]

//文件是否存在
#define isfileExist @"fileExist"

//文件是否更新
#define isUpdate @"updateState"

//书籍的版本
#define bookVersion @"bookVersion"








