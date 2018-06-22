//
//  NSDate+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/18.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "NSDate+GTKit.h"
#import <UIKit/UIKit.h>
#import <time.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
#define gt_NSDATE_UTILITIES_COMPONENT_FLAGS \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
({ \
unsigned components;\
if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){ \
components = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit); \
}else{ \
components = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit); \
} \
components; \
})\
_Pragma("clang diagnostic pop") \

#else
#define gt_NSDATE_UTILITIES_COMPONENT_FLAGS \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
({\
unsigned components = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit); \
components; \
})\
_Pragma("clang diagnostic pop") \

#endif

#define gt_ChineseMonths @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",@"九月", @"十月", @"冬月", @"腊月"]

#define ChineseFestival @[@"除夕",@"春节",@"中秋",@"五一",@"国庆",@"儿童",@"圣诞",@"七夕",@"端午"]

#define gt_ChineseDays @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"]

#define ChineseWeatherFestival @[@"立春",@"雨水",@"惊蛰",@"春分",@"清明",@"谷雨",@"立夏",@"小满",@"忙种",@"夏至",@"小暑",@"大暑",@"立秋",@"处暑",@"寒露",@"霜降",@"白露",@"秋分",@"立冬",@"小雪",@"大雪",@"冬至",@"小寒",@"大寒"]

#define gt_ChineseYears  @[@"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉", @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未", @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳", @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑", @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",  @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥"]

@implementation NSDate (GTKit)

#pragma mark ---- Decomposing dates 分解的日期

- (NSInteger)gt_year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)gt_month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)gt_day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)gt_hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)gt_nearestHour
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + gt_D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    NSDateComponents *components;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:newDate];
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:newDate];
#pragma clang diagnostic pop
    }
#else
    NSDateComponents *components =  [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:newDate];
#endif
    return components.hour;
}
- (NSInteger)gt_minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)gt_second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)gt_nanosecond {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

- (NSInteger)gt_weekday {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)gt_weekdayOrdinal {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)gt_weekOfMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)gt_weekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)gt_yearForWeekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

- (NSInteger)gt_quarter {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

#pragma mark ----short time 格式化的时间

- (NSString *) gt_shortString
{
    return [self gt_stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *) gt_shortTimeString
{
    return [self gt_stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}

- (NSString *) gt_shortDateString
{
    return [self gt_stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSString *) gt_mediumString
{
    return [self gt_stringWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle ];
}

- (NSString *) gt_mediumTimeString
{
    return [self gt_stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle ];
}

- (NSString *) gt_mediumDateString
{
    return [self gt_stringWithDateStyle:NSDateFormatterMediumStyle  timeStyle:NSDateFormatterNoStyle];
}

- (NSString *) gt_longString
{
    return [self gt_stringWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle ];
}

- (NSString *) gt_longTimeString
{
    return [self gt_stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle ];
}

- (NSString *) gt_longDateString
{
    return [self gt_stringWithDateStyle:NSDateFormatterLongStyle  timeStyle:NSDateFormatterNoStyle];
}


#pragma mark ---- 从当前日期相对日期时间

+ (NSDate *) gt_dateTomorrow
{
    return [NSDate gt_dateWithDaysFromNow:1];
}

+ (NSDate *) gt_dateYesterday
{
    return [NSDate gt_dateWithDaysBeforeNow:1];
}

+ (NSDate *)gt_dateWithDaysFromNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] gt_dateByAddingDays:days];
}

+ (NSDate *)gt_dateWithDaysBeforeNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] gt_dateBySubtractingDays:days];
}

+ (NSDate *) gt_dateWithHoursFromNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + gt_D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) gt_dateWithHoursBeforeNow: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - gt_D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) gt_dateWithMinutesFromNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + gt_D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *) gt_dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - gt_D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark ---- 获取零点或24点
+ (NSDate *)gt_zeroTodayDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:[NSDate date]];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [calendar dateFromComponents:components];
}

+ (NSDate *)gt_zero24TodayDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:[NSDate date]];
    components.hour = 23;
    components.minute = 59;
    components.second = 0;
    return [calendar dateFromComponents:components];
}

- (NSDate *)gt_zeroDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [calendar dateFromComponents:components];
}
- (NSDate *)gt_zero24Date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:self];
    components.hour = 23;
    components.minute = 59;
    components.second = 0;
    return [calendar dateFromComponents:components];
}

#pragma mark ---- 农历大写日期

+ (NSCalendar *)gt_chineseCalendar
{
    static NSCalendar *gt_chineseCalendar_sharedCalendar = nil;
    if (!gt_chineseCalendar_sharedCalendar)
        gt_chineseCalendar_sharedCalendar =[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    return gt_chineseCalendar_sharedCalendar;
}
+ (NSString*)gt_currentMDDateString{
    
    NSDate *date = [NSDate date];
    NSCalendar *chineseCalendar = [self gt_chineseCalendar];
    
    NSDateComponents *components = [chineseCalendar components:NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    NSString *month = gt_ChineseMonths[components.month -1];
    NSString *day  = gt_ChineseDays[components.day -1];
    
    return [month stringByAppendingString:day];
}
+ (NSString*)gt_currentYMDDateString{
    NSCalendar *chineseCalendar = [[self class] gt_chineseCalendar];
    NSDate *date = [NSDate date];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *localeComp = [chineseCalendar components:unitFlags fromDate:date];
    
    NSLog(@"%ld_%ld_%ld",(long)localeComp.year,(long)localeComp.month,(long)localeComp.day);
    
    NSString *y_str = [gt_ChineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [gt_ChineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [gt_ChineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat:@"%@%@%@",y_str,m_str,d_str];
    
    return chineseCal_str;
}

+ (NSString *)gt_currentWeekWithDateString:(NSString*)datestring{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:datestring];
    return [self gt_currentWeek:date];
}
+ (NSString *)gt_currentWeek:(NSDate*)date{
    NSArray *weeks =@[@"星期",@"星期日",@"星期一", @"星期二", @"星期三",@"星期四", @"星期五", @"星期六"];
    
    NSCalendar *gregorian = [self gt_chineseCalendar];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    
    int week = (int)comps.weekday;
    
    return weeks[week];
}
+ (NSString*)gt_currentCapitalDateString{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:(NSCalendarUnitMonth| NSCalendarUnitDay) fromDate:[NSDate date]];
    
    
    NSArray *months = @[@"月",@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
    
    NSArray *days = @[@"零",@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十",
                      @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                      @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三十一"];
    
    int day = (int)comps.day;
    int month = (int)comps.month;
    return [[months objectAtIndex:month] stringByAppendingString:[days objectAtIndex:day]];
}

#pragma mark - Comparing Dates

- (BOOL) gt_isEqualToDateIgnoringTime: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:gt_NSDATE_UTILITIES_COMPONENT_FLAGS fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:gt_NSDATE_UTILITIES_COMPONENT_FLAGS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}


- (BOOL) gt_isToday
{
    return [self gt_isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) gt_isTomorrow
{
    return [self gt_isEqualToDateIgnoringTime:[NSDate gt_dateTomorrow]];
}

- (BOOL) gt_isYesterday
{
    return [self gt_isEqualToDateIgnoringTime:[NSDate gt_dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL)gt_isSameWeekAsDate: (NSDate *) aDate
{
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:gt_NSDATE_UTILITIES_COMPONENT_FLAGS fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:gt_NSDATE_UTILITIES_COMPONENT_FLAGS fromDate:aDate];
    
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.weekOfYear != components2.weekOfYear) return NO;
    
    // Must have a time interval under 1 week. Thanks @aclark
    return (fabs([self timeIntervalSinceDate:aDate]) < gt_D_WEEK);
    
}

- (BOOL) gt_isThisWeek
{
    return [self gt_isSameWeekAsDate:[NSDate date]];
}

- (BOOL) gt_isNextWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + gt_D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self gt_isSameWeekAsDate:newDate];
}

- (BOOL) gt_isLastWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - gt_D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self gt_isSameWeekAsDate:newDate];
}

- (BOOL)gt_isLeapYear {
    NSUInteger year = self.gt_year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

// Thanks, mspasov
- (BOOL) gt_isSameMonthAsDate: (NSDate *) aDate
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    NSDateComponents *components1;
    NSDateComponents *components2;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
        components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        components1 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
        components2 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:aDate];
#pragma clang diagnostic pop
    }
#else
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:aDate];
#endif
    
    return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL) gt_isThisMonth
{
    return [self gt_isSameMonthAsDate:[NSDate date]];
}

// Thanks Marcin Krzyzanowski, also for adding/subtracting years and months
- (BOOL) gt_isLastMonth
{
    return [self gt_isSameMonthAsDate:[[NSDate date] gt_dateBySubtractingMonths:1]];
}

- (BOOL)gt_isLeapMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

- (BOOL) gt_isNextMonth
{
    return [self gt_isSameMonthAsDate:[[NSDate date] gt_dateByAddingMonths:1]];
}

- (BOOL) gt_isSameYearAsDate: (NSDate *) aDate
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    NSDateComponents *components1;
    NSDateComponents *components2;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
        components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:aDate];
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        components1 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];
        components2 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit  fromDate:aDate];
#pragma clang diagnostic pop
    }
#else
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:aDate];
#endif
    return (components1.year == components2.year);
}

- (BOOL) gt_isThisYear
{
    // Thanks, baspellis
    return [self gt_isSameYearAsDate:[NSDate date]];
}

- (BOOL) gt_isNextYear
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    NSDateComponents *components1;
    NSDateComponents *components2;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
        components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        components1 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];
        components2 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit  fromDate:[NSDate date]];
#pragma clang diagnostic pop
    }
#else
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
#endif
    
    return (components1.year == (components2.year + 1));
}

- (BOOL) gt_isLastYear
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    NSDateComponents *components1;
    NSDateComponents *components2;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self];
        components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        components1 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];
        components2 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit  fromDate:[NSDate date]];
#pragma clang diagnostic pop
    }
#else
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
#endif
    return (components1.year == (components2.year - 1));
}

- (BOOL) gt_isEarlierThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) gt_isLaterThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

// Thanks, markrickert
- (BOOL) gt_isInFuture
{
    return ([self gt_isLaterThanDate:[NSDate date]]);
}

// Thanks, markrickert
- (BOOL) gt_isInPast
{
    return ([self gt_isEarlierThanDate:[NSDate date]]);
}


#pragma mark - Roles
- (BOOL) gt_isTypicallyWeekend
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    NSDateComponents *components;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday | NSCalendarUnitMonth fromDate:self];
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];
#pragma clang diagnostic pop
    }
#else
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:self];
#endif
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL) gt_isTypicallyWorkday
{
    return ![self gt_isTypicallyWeekend];
}

#pragma mark ---- Adjusting dates 调节时间

// Thaks, rsjohnson
- (NSDate *) gt_dateByAddingYears: (NSInteger) dYears
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:dYears];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) gt_dateBySubtractingYears: (NSInteger) dYears
{
    return [self gt_dateByAddingYears:-dYears];
}

- (NSDate *) gt_dateByAddingMonths: (NSInteger) dMonths
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:dMonths];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) gt_dateBySubtractingMonths: (NSInteger) dMonths
{
    return [self gt_dateByAddingMonths:-dMonths];
}

// Courtesy of dedan who mentions issues with Daylight Savings
- (NSDate *) gt_dateByAddingDays: (NSInteger) dDays
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) gt_dateBySubtractingDays: (NSInteger) dDays
{
    return [self gt_dateByAddingDays: (dDays * -1)];
}

- (NSDate *) gt_dateByAddingHours: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + gt_D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) gt_dateBySubtractingHours: (NSInteger) dHours
{
    return [self gt_dateByAddingHours: (dHours * -1)];
}

- (NSDate *) gt_dateByAddingMinutes: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + gt_D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) gt_dateBySubtractingMinutes: (NSInteger) dMinutes
{
    return [self gt_dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *)gt_dateByAddingSeconds:(NSInteger)dSeconds
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + dSeconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)gt_dateBySubtractingSeconds:(NSInteger)dSeconds
{
    return [self gt_dateByAddingSeconds: (dSeconds * -1)];
}

- (NSDateComponents *) gt_componentsWithOffsetFromDate: (NSDate *) aDate
{
    NSDateComponents *dTime = [[NSCalendar currentCalendar] components:gt_NSDATE_UTILITIES_COMPONENT_FLAGS fromDate:aDate toDate:self options:0];
    return dTime;
}

#pragma mark - Extremes

- (NSDate *) gt_dateAtStartOfDay
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:gt_NSDATE_UTILITIES_COMPONENT_FLAGS fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

// Thanks gsempe & mteece
- (NSDate *) gt_dateAtEndOfDay
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:gt_NSDATE_UTILITIES_COMPONENT_FLAGS fromDate:self];
    
    components.hour = 23; // Thanks Aleksey Kononov
    components.minute = 59;
    components.second = 59;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

#pragma mark - Retrieving Intervals

- (NSInteger) gt_minutesAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / gt_D_MINUTE);
}

- (NSInteger) gt_minutesBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / gt_D_MINUTE);
}

- (NSInteger) gt_hoursAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / gt_D_HOUR);
}

- (NSInteger) gt_hoursBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / gt_D_HOUR);
}

- (NSInteger) gt_daysAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti / gt_D_DAY);
}

- (NSInteger) gt_daysBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / gt_D_DAY);
}

// Thanks, dmitrydims
// I have not yet thoroughly tested this
- (NSInteger)gt_distanceDaysToDate:(NSDate *)anotherDate
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    NSDateComponents *components;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self toDate:anotherDate options:0];
#pragma clang diagnostic pop
    }
#else
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:self toDate:anotherDate options:0]
#endif
    
    return components.day;
}
- (NSInteger)gt_distanceMonthsToDate:(NSDate *)anotherDate{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    NSDateComponents *components;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self toDate:anotherDate options:0];
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self toDate:anotherDate options:0];
#pragma clang diagnostic pop
    }
#else
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self toDate:anotherDate options:0]
#endif
    return components.month;
}
- (NSInteger)gt_distanceYearsToDate:(NSDate *)anotherDate{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    NSDateComponents *components;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f){
        components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self toDate:anotherDate options:0];
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self toDate:anotherDate options:0];
#pragma clang diagnostic pop
    }
#else
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self toDate:anotherDate options:0]
#endif
    return components.year;
}



#pragma mark - Date Format

- (NSString *)gt_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

- (NSString *)gt_stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = dateStyle;
    formatter.timeStyle = timeStyle;
    formatter.locale = [NSLocale currentLocale]; // Necessary?
    return [formatter stringFromDate:self];
}

- (NSString *)gt_stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

- (NSString *)gt_stringWithISOFormat {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return [formatter stringFromDate:self];
}

+ (NSDate *)gt_dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)gt_dateWithString:(NSString *)dateString format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)gt_dateWithISOFormatString:(NSString *)dateString {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    });
    return [formatter dateFromString:dateString];
}

@end

#pragma mark ---- GTTimeAgo Category

@interface NSDate()
-(NSString *)getLocaleFormatUnderscoresWithValue:(double)value;
@end

@implementation NSDate (GTTimeAgo)

#ifndef NSDateTimeAgoLocalizedStrings
#define NSDateTimeAgoLocalizedStrings(key) \
NSLocalizedStringFromTableInBundle(key, @"NSDateTimeAgo", [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"NSDateTimeAgo.bundle"]], nil)
#endif

// shows 1 or two letter abbreviation for units.
// does not include 'ago' text ... just {value}{unit-abbreviation}
// does not include interim summary options such as 'Just now'
- (NSString *)gt_timeAgoSimple
{
    NSDate *now = [NSDate date];
    double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    
    int value;
    
    if(deltaSeconds < 60)
    {
        return [self stringFromFormat:@"%%d%@s" withValue:deltaSeconds];
    }
    else if (deltaMinutes < 60)
    {
        return [self stringFromFormat:@"%%d%@m" withValue:deltaMinutes];
    }
    else if (deltaMinutes < (24 * 60))
    {
        value = (int)floor(deltaMinutes/60);
        return [self stringFromFormat:@"%%d%@h" withValue:value];
    }
    else if (deltaMinutes < (24 * 60 * 7))
    {
        value = (int)floor(deltaMinutes/(60 * 24));
        return [self stringFromFormat:@"%%d%@d" withValue:value];
    }
    else if (deltaMinutes < (24 * 60 * 31))
    {
        value = (int)floor(deltaMinutes/(60 * 24 * 7));
        return [self stringFromFormat:@"%%d%@w" withValue:value];
    }
    else if (deltaMinutes < (24 * 60 * 365.25))
    {
        value = (int)floor(deltaMinutes/(60 * 24 * 30));
        return [self stringFromFormat:@"%%d%@mo" withValue:value];
    }
    
    value = (int)floor(deltaMinutes/(60 * 24 * 365));
    return [self stringFromFormat:@"%%d%@yr" withValue:value];
}

- (NSString *)gt_timeAgo
{
    NSDate *now = [NSDate date];
    double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    
    int minutes;
    
    if(deltaSeconds < 5)
    {
        return NSDateTimeAgoLocalizedStrings(@"Just now");
    }
    else if(deltaSeconds < 60)
    {
        return [self stringFromFormat:@"%%d %@seconds ago" withValue:deltaSeconds];
    }
    else if(deltaSeconds < 120)
    {
        return NSDateTimeAgoLocalizedStrings(@"A minute ago");
    }
    else if (deltaMinutes < 60)
    {
        return [self stringFromFormat:@"%%d %@minutes ago" withValue:deltaMinutes];
    }
    else if (deltaMinutes < 120)
    {
        return NSDateTimeAgoLocalizedStrings(@"An hour ago");
    }
    else if (deltaMinutes < (24 * 60))
    {
        minutes = (int)floor(deltaMinutes/60);
        return [self stringFromFormat:@"%%d %@hours ago" withValue:minutes];
    }
    else if (deltaMinutes < (24 * 60 * 2))
    {
        return NSDateTimeAgoLocalizedStrings(@"Yesterday");
    }
    else if (deltaMinutes < (24 * 60 * 7))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24));
        return [self stringFromFormat:@"%%d %@days ago" withValue:minutes];
    }
    else if (deltaMinutes < (24 * 60 * 14))
    {
        return NSDateTimeAgoLocalizedStrings(@"Last week");
    }
    else if (deltaMinutes < (24 * 60 * 31))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24 * 7));
        return [self stringFromFormat:@"%%d %@weeks ago" withValue:minutes];
    }
    else if (deltaMinutes < (24 * 60 * 61))
    {
        return NSDateTimeAgoLocalizedStrings(@"Last month");
    }
    else if (deltaMinutes < (24 * 60 * 365.25))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24 * 30));
        return [self stringFromFormat:@"%%d %@months ago" withValue:minutes];
    }
    else if (deltaMinutes < (24 * 60 * 731))
    {
        return NSDateTimeAgoLocalizedStrings(@"Last year");
    }
    
    minutes = (int)floor(deltaMinutes/(60 * 24 * 365));
    return [self stringFromFormat:@"%%d %@years ago" withValue:minutes];
}

// Similar to timeAgo, but only returns "
- (NSString *)gt_dateTimeAgo
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate * now = [NSDate date];
    NSDateComponents *components = [calendar components:
                                    NSCalendarUnitYear|
                                    NSCalendarUnitMonth|
                                    NSCalendarUnitWeekOfYear|
                                    NSCalendarUnitDay|
                                    NSCalendarUnitHour|
                                    NSCalendarUnitMinute|
                                    NSCalendarUnitSecond
                                               fromDate:self
                                                 toDate:now
                                                options:0];
    
    if (components.year >= 1)
    {
        if (components.year == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"1 year ago");
        }
        return [self stringFromFormat:@"%%d %@years ago" withValue:components.year];
    }
    else if (components.month >= 1)
    {
        if (components.month == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"1 month ago");
        }
        return [self stringFromFormat:@"%%d %@months ago" withValue:components.month];
    }
    else if (components.weekOfYear >= 1)
    {
        if (components.weekOfYear == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"1 week ago");
        }
        return [self stringFromFormat:@"%%d %@weeks ago" withValue:components.weekOfYear];
    }
    else if (components.day >= 1)    // up to 6 days ago
    {
        if (components.day == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"1 day ago");
        }
        return [self stringFromFormat:@"%%d %@days ago" withValue:components.day];
    }
    else if (components.hour >= 1)   // up to 23 hours ago
    {
        if (components.hour == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"An hour ago");
        }
        return [self stringFromFormat:@"%%d %@hours ago" withValue:components.hour];
    }
    else if (components.minute >= 1) // up to 59 minutes ago
    {
        if (components.minute == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"A minute ago");
        }
        return [self stringFromFormat:@"%%d %@minutes ago" withValue:components.minute];
    }
    else if (components.second < 5)
    {
        return NSDateTimeAgoLocalizedStrings(@"Just now");
    }
    
    // between 5 and 59 seconds ago
    return [self stringFromFormat:@"%%d %@seconds ago" withValue:components.second];
}



- (NSString *)gt_dateTimeUntilNow
{
    NSDate * now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitHour
                                               fromDate:self
                                                 toDate:now
                                                options:0];
    
    if (components.hour >= 6) // if more than 6 hours ago, change precision
    {
        NSInteger startDay = [calendar ordinalityOfUnit:NSCalendarUnitDay
                                                 inUnit:NSCalendarUnitEra
                                                forDate:self];
        NSInteger endDay = [calendar ordinalityOfUnit:NSCalendarUnitDay
                                               inUnit:NSCalendarUnitEra
                                              forDate:now];
        
        NSInteger diffDays = endDay - startDay;
        if (diffDays == 0) // today!
        {
            NSDateComponents * startHourComponent = [calendar components:NSCalendarUnitHour fromDate:self];
            NSDateComponents * endHourComponent = [calendar components:NSCalendarUnitHour fromDate:self];
            if (startHourComponent.hour < 12 &&
                endHourComponent.hour > 12)
            {
                return NSDateTimeAgoLocalizedStrings(@"This morning");
            }
            else if (startHourComponent.hour >= 12 &&
                     startHourComponent.hour < 18 &&
                     endHourComponent.hour >= 18)
            {
                return NSDateTimeAgoLocalizedStrings(@"This afternoon");
            }
            return NSDateTimeAgoLocalizedStrings(@"Today");
        }
        else if (diffDays == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"Yesterday");
        }
        else
        {
            NSInteger startWeek = [calendar ordinalityOfUnit:NSCalendarUnitWeekOfYear
                                                      inUnit:NSCalendarUnitEra
                                                     forDate:self];
            NSInteger endWeek = [calendar ordinalityOfUnit:NSCalendarUnitWeekOfYear
                                                    inUnit:NSCalendarUnitEra
                                                   forDate:now];
            NSInteger diffWeeks = endWeek - startWeek;
            if (diffWeeks == 0)
            {
                return NSDateTimeAgoLocalizedStrings(@"This week");
            }
            else if (diffWeeks == 1)
            {
                return NSDateTimeAgoLocalizedStrings(@"Last week");
            }
            else
            {
                NSInteger startMonth = [calendar ordinalityOfUnit:NSCalendarUnitMonth
                                                           inUnit:NSCalendarUnitEra
                                                          forDate:self];
                NSInteger endMonth = [calendar ordinalityOfUnit:NSCalendarUnitMonth
                                                         inUnit:NSCalendarUnitEra
                                                        forDate:now];
                NSInteger diffMonths = endMonth - startMonth;
                if (diffMonths == 0)
                {
                    return NSDateTimeAgoLocalizedStrings(@"This month");
                }
                else if (diffMonths == 1)
                {
                    return NSDateTimeAgoLocalizedStrings(@"Last month");
                }
                else
                {
                    NSInteger startYear = [calendar ordinalityOfUnit:NSCalendarUnitYear
                                                              inUnit:NSCalendarUnitEra
                                                             forDate:self];
                    NSInteger endYear = [calendar ordinalityOfUnit:NSCalendarUnitYear
                                                            inUnit:NSCalendarUnitEra
                                                           forDate:now];
                    NSInteger diffYears = endYear - startYear;
                    if (diffYears == 0)
                    {
                        return NSDateTimeAgoLocalizedStrings(@"This year");
                    }
                    else if (diffYears == 1)
                    {
                        return NSDateTimeAgoLocalizedStrings(@"Last year");
                    }
                }
            }
        }
    }
    
    // anything else uses "time ago" precision
    return [self gt_dateTimeAgo];
}



- (NSString *) stringFromFormat:(NSString *)format withValue:(NSInteger)value
{
    NSString * localeFormat = [NSString stringWithFormat:format, [self getLocaleFormatUnderscoresWithValue:value]];
    return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), value];
}

- (NSString *) gt_timeAgoWithLimit:(NSTimeInterval)limit
{
    return [self gt_timeAgoWithLimit:limit dateFormat:NSDateFormatterFullStyle andTimeFormat:NSDateFormatterFullStyle];
}

- (NSString *) gt_timeAgoWithLimit:(NSTimeInterval)limit dateFormat:(NSDateFormatterStyle)dFormatter andTimeFormat:(NSDateFormatterStyle)tFormatter
{
    if (fabs([self timeIntervalSinceDate:[NSDate date]]) <= limit)
        return [self gt_timeAgo];
    
    return [NSDateFormatter localizedStringFromDate:self
                                          dateStyle:dFormatter
                                          timeStyle:tFormatter];
}

- (NSString *) gt_timeAgoWithLimit:(NSTimeInterval)limit dateFormatter:(NSDateFormatter *)formatter
{
    if (fabs([self timeIntervalSinceDate:[NSDate date]]) <= limit)
        return [self gt_timeAgo];
    
    return [formatter stringFromDate:self];
}

// Helper functions

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

/*
 - Author  : Almas Adilbek
 - Method  : getLocaleFormatUnderscoresWithValue
 - Param   : value (Double value of seconds or minutes)
 - Return  : @"" or the set of underscores ("_")
 in order to define exact translation format for specific translation rules.
 (Ex: "%d _seconds ago" for "%d секунды назад", "%d __seconds ago" for "%d секунда назад",
 and default format without underscore %d seconds ago" for "%d секунд назад")
 Updated : 12/12/2012
 
 Note    : This method must be used for all languages that have specific translation rules.
 Using method argument "value" you must define all possible conditions language have for translation
 and return set of underscores ("_") as it is an ID for locale format. No underscore ("") means default locale format;
 */
-(NSString *)getLocaleFormatUnderscoresWithValue:(double)value
{
    NSString *localeCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    // Russian (ru)
    if([localeCode isEqual:@"ru"]) {
        int XY = (int)floor(value) % 100;
        int Y = (int)floor(value) % 10;
        
        if(Y == 0 || Y > 4 || (XY > 10 && XY < 15)) return @"";
        if(Y > 1 && Y < 5 && (XY < 10 || XY > 20))  return @"_";
        if(Y == 1 && XY != 11)                      return @"__";
    }
    
    // Add more languages here, which are have specific translation rules...
    
    return @"";
}

#pragma clang diagnostic pop

@end
