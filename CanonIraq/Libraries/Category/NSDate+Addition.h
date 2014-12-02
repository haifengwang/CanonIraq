//
//  NSDate+HW.h
//  StringDemo
//
//  Created by 何 振东 on 12-10-11.
//  Copyright (c) 2012年 wsk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Addition)

/**
 *  将日期转化为字符串。
 *  @param  format:转化格式，形如@"yyyy年MM月dd日hh时mm分ss秒"。
 *  return  返回转化后的字符串。
 */
- (NSString *)convertDateToStringWithFormat:(NSString *)format;

/**
 *  将字符串转化为日期。
 *  @param  string:给定的字符串日期。
 *  @param  format:转化格式，形如@"yyyy年MM月dd日hh时mm分ss秒"。日期格式要和string格式一致，否则会为空。
 *  return  返回转化后的日期。
 */
- (NSDate *)convertStringToDate:(NSString *)string format:(NSString *)format;

/**
 * 将将日期转换为字符串
 * @param date:日期类型
 * @param format 制定的格式化字符串 yyyy-MM-dd HH:mm:ss.SSS
 * return 返回转换后的日期
 */
-(NSString *)convertDateToString:(NSData *)date format:(NSString *) format;

@end
