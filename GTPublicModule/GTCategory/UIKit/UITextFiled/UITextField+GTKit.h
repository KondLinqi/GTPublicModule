//
//  UITextField+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/20.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GTShakedDirection) {
    GTShakedDirectionHorizontal,
    GTShakedDirectionVertical
};


@interface UITextField (GTKit)

#pragma mark - maxLength
///=============================================================================
/// @name maxLength
///=============================================================================

@property (assign, nonatomic)  NSInteger gt_maxLength;//if <=0, no limit

#pragma mark - Select
///=============================================================================
/// @name Select
///=============================================================================

/**
 *  @brief  当前选中的字符串范围
 *
 *  @return NSRange
 */
- (NSRange)gt_selectedRange;
/**
 *  @brief  选中所有文字
 */
- (void)gt_selectAllText;
/**
 *  @brief  选中指定范围的文字
 *
 *  @param range NSRange范围
 */
- (void)gt_setSelectedRange:(NSRange)range;


#pragma mark - Shake
///=============================================================================
/// @name Shake
///=============================================================================

/** Shake the UITextField
 *
 * Shake the text field with default values
 */
- (void)gt_shake;

/** Shake the UITextField
 *
 * Shake the text field a given number of times
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 */
- (void)gt_shake:(int)times withDelta:(CGFloat)delta;

/** Shake the UITextField
 *
 * Shake the text field a given number of times
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param handler A block object to be executed when the shake sequence ends
 */
- (void)gt_shake:(int)times withDelta:(CGFloat)delta completion:(void((^)(void)))handler;

/** Shake the UITextField at a custom speed
 *
 * Shake the text field a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 */
- (void)gt_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval;

/** Shake the UITextField at a custom speed
 *
 * Shake the text field a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 * @param handler A block object to be executed when the shake sequence ends
 */
- (void)gt_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void((^)(void)))handler;

/** Shake the UITextField at a custom speed
 *
 * Shake the text field a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 * @param shakeDirection of the shake
 */
- (void)gt_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(GTShakedDirection)shakeDirection;

/** Shake the UITextField at a custom speed
 *
 * Shake the text field a given number of times with a given speed
 *
 * @param times The number of shakes
 * @param delta The width of the shake
 * @param interval The duration of one shake
 * @param shakeDirection of the shake
 * @param handler A block object to be executed when the shake sequence ends
 */
- (void)gt_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(GTShakedDirection)shakeDirection completion:(void((^)(void)))handler;


@end
