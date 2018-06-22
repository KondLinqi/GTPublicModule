//
//  NSDate+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/18.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define gt_D_MINUTE    60
#define gt_D_HOUR    3600
#define gt_D_DAY    86400
#define gt_D_WEEK    604800
#define gt_D_YEAR    31556926

/**
 Provides extensions for `NSDate`.
 */
@interface NSDate (GTKit)
#pragma mark - Component Properties
///=============================================================================
/// @name Component Properties
///=============================================================================
#pragma mark ---- Decomposing dates 分解的日期
@property (nonatomic, readonly) NSInteger gt_year; ///< Year component
@property (nonatomic, readonly) NSInteger gt_month; ///< Month component (1~12)
@property (nonatomic, readonly) NSInteger gt_day; ///< Day component (1~31)
@property (nonatomic, readonly) NSInteger gt_hour; ///< Hour component (0~23)
@property (nonatomic, readonly) NSInteger gt_nearestHour;
@property (nonatomic, readonly) NSInteger gt_minute; ///< Minute component (0~59)
@property (nonatomic, readonly) NSInteger gt_second; ///< Second component (0~59)
@property (nonatomic, readonly) NSInteger gt_nanosecond; ///< Nanosecond component
@property (nonatomic, readonly) NSInteger gt_weekday; ///< Weekday component (1~7, first day is based on user setting)
@property (nonatomic, readonly) NSInteger gt_weekdayOrdinal; ///< WeekdayOrdinal component
@property (nonatomic, readonly) NSInteger gt_weekOfMonth; ///< WeekOfMonth component (1~5)
@property (nonatomic, readonly) NSInteger gt_weekOfYear; ///< WeekOfYear component (1~53)
@property (nonatomic, readonly) NSInteger gt_yearForWeekOfYear; ///< YearForWeekOfYear component
@property (nonatomic, readonly) NSInteger gt_quarter; ///< Quarter component


#pragma mark ----short time 格式化的时间
@property (nonatomic, readonly) NSString *gt_shortString;
@property (nonatomic, readonly) NSString *gt_shortDateString;
@property (nonatomic, readonly) NSString *gt_shortTimeString;
@property (nonatomic, readonly) NSString *gt_mediumString;
@property (nonatomic, readonly) NSString *gt_mediumDateString;
@property (nonatomic, readonly) NSString *gt_mediumTimeString;
@property (nonatomic, readonly) NSString *gt_longString;
@property (nonatomic, readonly) NSString *gt_longDateString;
@property (nonatomic, readonly) NSString *gt_longTimeString;


#pragma mark - Date modify
///=============================================================================
/// @name Date modify
///=============================================================================

#pragma mark ---- 从当前日期相对日期时间
///明天
+ (NSDate *)gt_dateTomorrow;
///昨天
+ (NSDate *)gt_dateYesterday;
///今天后几天
+ (NSDate *)gt_dateWithDaysFromNow:(NSInteger)days;
///今天前几天
+ (NSDate *)gt_dateWithDaysBeforeNow:(NSInteger)days;
///当前小时后dHours个小时
+ (NSDate *)gt_dateWithHoursFromNow:(NSInteger)dHours;
///当前小时前dHours个小时
+ (NSDate *)gt_dateWithHoursBeforeNow:(NSInteger)dHours;
///当前分钟后dMinutes个分钟
+ (NSDate *)gt_dateWithMinutesFromNow:(NSInteger)dMinutes;
///当前分钟前dMinutes个分钟
+ (NSDate *)gt_dateWithMinutesBeforeNow:(NSInteger)dMinutes;

#pragma mark ---- 获取零点或24点
///今天零点
+ (NSDate *)gt_zeroTodayDate;
///今天24点
+ (NSDate *)gt_zero24TodayDate;
///获取零点
- (NSDate *)gt_zeroDate;
///获取24点
- (NSDate *)gt_zero24Date;

#pragma mark ---- 农历大写日期
+ (NSCalendar *)gt_chineseCalendar;
//例如 五月初一
+ (NSString*)gt_currentMDDateString;
//例如 乙未年五月初一
+ (NSString*)gt_currentYMDDateString;
//例如 星期一
+ (NSString *)gt_currentWeek:(NSDate*)date;
//例如 星期一
+ (NSString *)gt_currentWeekWithDateString:(NSString*)datestring;
//例如 五月一
+ (NSString*)gt_currentCapitalDateString;


#pragma mark ---- Comparing dates 比较时间
///比较年月日是否相等
- (BOOL)gt_isEqualToDateIgnoringTime:(NSDate *)aDate;
///是否是今天
- (BOOL)gt_isToday;
///是否是明天
- (BOOL)gt_isTomorrow;
///是否是昨天
- (BOOL)gt_isYesterday;

///是否是同一周
- (BOOL)gt_isSameWeekAsDate:(NSDate *)aDate;
///是否是本周
- (BOOL)gt_isThisWeek;
///是否是本周的下周
- (BOOL)gt_isNextWeek;
///是否是本周的上周
- (BOOL)gt_isLastWeek;
///是否是闰年
- (BOOL)gt_isLeapYear;


///是否是同一月
- (BOOL)gt_isSameMonthAsDate:(NSDate *)aDate;
///是否是本月
- (BOOL)gt_isThisMonth;
///是否是本月的下月
- (BOOL)gt_isNextMonth;
///是否是本月的上月
- (BOOL)gt_isLastMonth;
///是否是闰月
- (BOOL)gt_isLeapMonth;


///是否是同一年
- (BOOL)gt_isSameYearAsDate:(NSDate *)aDate;
///是否是今年
- (BOOL)gt_isThisYear;
///是否是今年的下一年
- (BOOL)gt_isNextYear;
///是否是今年的上一年
- (BOOL)gt_isLastYear;

///是否提前aDate
- (BOOL)gt_isEarlierThanDate:(NSDate *)aDate;
///是否晚于aDate
- (BOOL)gt_isLaterThanDate:(NSDate *)aDate;
///是否晚是未来
- (BOOL)gt_isInFuture;
///是否晚是过去
- (BOOL)gt_isInPast;



///是否是工作日
- (BOOL)gt_isTypicallyWorkday;
///是否是周末
- (BOOL)gt_isTypicallyWeekend;

#pragma mark ---- Adjusting dates 调节时间
///增加dYears年
- (NSDate *)gt_dateByAddingYears:(NSInteger)dYears;
///减少dYears年
- (NSDate *)gt_dateBySubtractingYears:(NSInteger)dYears;
///增加dMonths月
- (NSDate *)gt_dateByAddingMonths:(NSInteger)dMonths;
///减少dMonths月
- (NSDate *)gt_dateBySubtractingMonths:(NSInteger)dMonths;
///增加dDays天
- (NSDate *)gt_dateByAddingDays:(NSInteger)dDays;
///减少dDays天
- (NSDate *)gt_dateBySubtractingDays:(NSInteger)dDays;
///增加dHours小时
- (NSDate *)gt_dateByAddingHours:(NSInteger)dHours;
///减少dHours小时
- (NSDate *)gt_dateBySubtractingHours:(NSInteger)dHours;
///增加dMinutes分钟
- (NSDate *)gt_dateByAddingMinutes:(NSInteger)dMinutes;
///减少dMinutes分钟
- (NSDate *)gt_dateBySubtractingMinutes:(NSInteger)dMinutes;
///增加dSeconds秒
- (NSDate *)gt_dateByAddingSeconds:(NSInteger)dSeconds;
///增加dSeconds秒
- (NSDate *)gt_dateBySubtractingSeconds:(NSInteger)dSeconds;


#pragma mark ---- 时间间隔
///比aDate晚多少分钟
- (NSInteger)gt_minutesAfterDate:(NSDate *)aDate;
///比aDate早多少分钟
- (NSInteger)gt_minutesBeforeDate:(NSDate *)aDate;
///比aDate晚多少小时
- (NSInteger)gt_hoursAfterDate:(NSDate *)aDate;
///比aDate早多少小时
- (NSInteger)gt_hoursBeforeDate:(NSDate *)aDate;
///比aDate晚多少天
- (NSInteger)gt_daysAfterDate:(NSDate *)aDate;
///比aDate早多少天
- (NSInteger)gt_daysBeforeDate:(NSDate *)aDate;

///与anotherDate间隔几天
- (NSInteger)gt_distanceDaysToDate:(NSDate *)anotherDate;
///与anotherDate间隔几月
- (NSInteger)gt_distanceMonthsToDate:(NSDate *)anotherDate;
///与anotherDate间隔几年
- (NSInteger)gt_distanceYearsToDate:(NSDate *)anotherDate;


#pragma mark - Date Format
///=============================================================================
/// @name Date Format
///=============================================================================

/**
 Returns a formatted string representing this date.
 see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 for format description.
 
 @param format   String representing the desired date format.
 e.g. @"yyyy-MM-dd HH:mm:ss"
 
 @return NSString representing the formatted date string.
 */
- (nullable NSString *)gt_stringWithFormat:(NSString *)format;

/**
 Returns a formatted string representing this date.
 see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 for format description.
 
 @param dateStyle   NSDateFormatterStyle
 @param timeStyle   NSDateFormatterStyle
 
 @return NSString representing the formatted date string.
 */
- (nullable NSString *)gt_stringWithDateStyle:(NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle;

/**
 Returns a formatted string representing this date.
 see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 for format description.
 
 @param format    String representing the desired date format.
 e.g. @"yyyy-MM-dd HH:mm:ss"
 
 @param timeZone  Desired time zone.
 
 @param locale    Desired locale.
 
 @return NSString representing the formatted date string.
 */
- (nullable NSString *)gt_stringWithFormat:(NSString *)format
                               timeZone:(nullable NSTimeZone *)timeZone
                                 locale:(nullable NSLocale *)locale;

/**
 Returns a string representing this date in ISO8601 format.
 e.g. "2010-07-09T16:13:30+12:00"
 
 @return NSString representing the formatted date string in ISO8601.
 */
- (nullable NSString *)gt_stringWithISOFormat;

/**
 Returns a date parsed from given string interpreted using the format.
 
 @param dateString The string to parse.
 @param format     The string's date format.
 
 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (nullable NSDate *)gt_dateWithString:(NSString *)dateString format:(NSString *)format;

/**
 Returns a date parsed from given string interpreted using the format.
 
 @param dateString The string to parse.
 @param format     The string's date format.
 @param timeZone   The time zone, can be nil.
 @param locale     The locale, can be nil.
 
 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (nullable NSDate *)gt_dateWithString:(NSString *)dateString
                             format:(NSString *)format
                           timeZone:(nullable NSTimeZone *)timeZone
                             locale:(nullable NSLocale *)locale;

/**
 Returns a date parsed from given string interpreted using the ISO8601 format.
 
 @param dateString The date string in ISO8601 format. e.g. "2010-07-09T16:13:30+12:00"
 
 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (nullable NSDate *)gt_dateWithISOFormatString:(NSString *)dateString;


@end



@interface NSDate (GTTimeAgo)

///提示 %天前；
- (NSString *) gt_timeAgoSimple;
- (NSString *) gt_timeAgo;
- (NSString *) gt_timeAgoWithLimit:(NSTimeInterval)limit;
- (NSString *) gt_timeAgoWithLimit:(NSTimeInterval)limit dateFormat:(NSDateFormatterStyle)dFormatter andTimeFormat:(NSDateFormatterStyle)tFormatter;
- (NSString *) gt_timeAgoWithLimit:(NSTimeInterval)limit dateFormatter:(NSDateFormatter *)formatter;


// this method only returns "{value} {unit} ago" strings and no "yesterday"/"last month" strings
- (NSString *)gt_dateTimeAgo;

// this method gives when possible the date compared to the current calendar date: "this morning"/"yesterday"/"last week"/..
// when more precision is needed (= less than 6 hours ago) it returns the same output as dateTimeAgo
- (NSString *)gt_dateTimeUntilNow;

@end

NS_ASSUME_NONNULL_END
