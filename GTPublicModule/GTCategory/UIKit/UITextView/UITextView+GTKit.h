//
//  UITextView+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/20.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (GTKit)

#pragma mark - placeHolder
///=============================================================================
/// @name placeHolder
///=============================================================================

@property (nonatomic, strong) UITextView *gt_placeHolderTextView;
- (void)gt_addPlaceHolder:(NSString *)placeHolder;

#pragma mark - maxLength
///=============================================================================
/// @name maxLength
///=============================================================================

@property (assign, nonatomic)  NSInteger gt_maxLength;//if <=0, no limit


#pragma mark - SelectedRange
///=============================================================================
/// @name maxLength
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


#pragma mark - PinchZoom
///=============================================================================
/// @name PinchZoom
///=============================================================================

@property (nonatomic) CGFloat gt_maxFontSize, gt_minFontSize;

@property (nonatomic) BOOL gt_zoomEnabled;

@end
