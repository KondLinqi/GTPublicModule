//
//  UIButton+GTState.h
//  GTKit
//
//  Created by liuxc on 2018/5/3.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIButton (GTState)

/**
 * 获取当前borderColor
 */
@property(nonatomic, readonly, strong) UIColor *gt_currentBorderColor;

/**
 * 获取当前backgroundColor
 */
@property(nonatomic, readonly, strong) UIColor *gt_currentBackgroundColor;

/**
 * 获取当前titleLabelFont
 */
@property(nonatomic, readonly, strong) UIFont *gt_currentTitleLabelFont;

/**
 * 切换按钮状态时,执行动画的时间,默认0.25s(只有动画执行完毕后,才能会执行下一个点击事件)
 */
@property (nonatomic, assign) NSTimeInterval gt_animatedDuration;

/**
 * 设置不同状态下的borderColor(支持动画效果)
 */
- (void)gt_buttonSetborderColor:(UIColor *)borderColor forState:(UIControlState)state animated:(BOOL)animated;

/**
 * 设置不同状态下的backgroundColor(支持动画效果)
 */
- (void)gt_buttonSetBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state animated:(BOOL)animated;

/**
 * 设置不同状态下的titleLabelFont
 */
- (void)gt_buttonSetTitleLabelFont:(UIFont *)titleLabelFont forState:(UIControlState)state;

/**
 * 获取某个状态的borderColor
 */
- (UIColor *)gt_buttonBorderColorForState:(UIControlState)state;

/**
 * 获取某个状态的backgroundColor
 */
- (UIColor *)gt_buttonBackgroundColorForState:(UIControlState)state;

/**
 * 获取某个状态的titleLabelFont
 */
- (UIFont *)gt_buttonTitleLabelFontForState:(UIControlState)state;

/**
 BAButton：创建圆角半径阴影，带半径、阴影颜色

 @param cornerRadius 半径
 @param shadowColor 阴影颜色
 @param offset 偏移量
 @param opacity 透明度
 @param shadowRadius 模糊程度
 @param state 状态
 */
- (void)gt_buttonSetRoundShadowWithCornerRadius:(CGFloat)cornerRadius
                                    shadowColor:(UIColor *)shadowColor
                                         offset:(CGSize)offset
                                        opacity:(CGFloat)opacity
                                   shadowRadius:(CGFloat)shadowRadius
                                       forState:(UIControlState)state;

#pragma mark - 使用key-value方式设置

/**
 * key:@(UIControlState枚举)
 * 注：此方式无动画
 */
- (void)gt_buttonConfigBorderColors:(NSDictionary <NSNumber *,UIColor *>*)borderColors;

/**
 * key:@(UIControlState枚举)
 * 注：此方式无动画
 */
- (void)gt_buttonConfigBackgroundColors:(NSDictionary <NSNumber *,UIColor *>*)backgroundColors;

/**
 * key:@(UIControlState枚举)
 */
- (void)gt_buttonConfigTitleLabelFont:(NSDictionary <NSNumber *,UIFont *>*)titleLabelFonts;

@end

NS_ASSUME_NONNULL_END
