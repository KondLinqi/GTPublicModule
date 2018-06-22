//
//  NSNumber+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/18.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (GTKit)

#pragma mark - stringNumber


/**
 Creates and returns an NSNumber object from a string.
 Valid format: @"12", @"12.345", @" -0xFF", @" .23e99 "...

 @param string  The string described an number.

 @return an NSNumber when parse succeed, or nil if an error occurs.
 */
+ (nullable NSNumber *)gt_numberWithString:(NSString *)string;


#pragma mark - RomanNumeral

/**
 *  @author GTCategories
 *
 *   A category on NSNumber that returns the value as a roman numeral
 *
 *  @return Roman Number
*/
- (NSString *)gt_romanNumeral;




#pragma mark - Display Digit
/* 展示 */
- (NSString*)gt_toDisplayNumberWithDigit:(NSInteger)digit;
- (NSString*)gt_toDisplayPercentageWithDigit:(NSInteger)digit;


/*　四舍五入 */
/**
 *  @brief  四舍五入
 *
 *  @param digit  限制最大位数
 *
 *  @return 结果
 */
- (NSNumber*)gt_doRoundWithDigit:(NSUInteger)digit;
/**
 *  @brief  取上整
 *
 *  @param digit  限制最大位数
 *
 *  @return 结果
 */
- (NSNumber*)gt_doCeilWithDigit:(NSUInteger)digit;
/**
 *  @brief  取下整
 *
 *  @param digit  限制最大位数
 *
 *  @return 结果
 */
- (NSNumber*)gt_doFloorWithDigit:(NSUInteger)digit;

@end

NS_ASSUME_NONNULL_END
