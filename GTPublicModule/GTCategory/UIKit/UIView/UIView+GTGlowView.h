//
//  UIView+BAGlowView.h
//  GTKit
//
//  Created by boai on 2017/7/18.
//  Copyright © 2017年 boai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GTGlowView)

//
//                                     == 动画时间解析 ==
//
//  0.0 ------------- 0.0 ------------> glowOpacity [-------------] glowOpacity ------------> 0.0
//           T                 T                           T                          T
//           |                 |                           |                          |
//           |                 |                           |                          |
//           .                 .                           .                          .
//     hideDuration  glowAnimationDuration           glowDuration            glowAnimationDuration
//

#pragma mark - 设置辉光效果

/**
 *  辉光的颜色
 */
@property (nonatomic, strong) UIColor  *gt_glowColor;

/**
 *  辉光的透明度
 */
@property (nonatomic, strong) NSNumber *gt_glowOpacity;

/**
 *  辉光的阴影半径
 */
@property (nonatomic, strong) NSNumber *gt_glowRadius;

#pragma mark - 设置辉光时间间隔

/**
 *  一次完整的辉光周期（从显示到透明或者从透明到显示），默认1s
 */
@property (nonatomic, strong) NSNumber *gt_glowAnimationDuration;

/**
 *  保持辉光时间（不设置，默认为0.5s）
 */
@property (nonatomic, strong) NSNumber *gt_glowDuration;

/**
 *  不显示辉光的周期（不设置默认为0.5s）
 */
@property (nonatomic, strong) NSNumber *gt_hideDuration;


/**
 *  创建出辉光 layer
 */
- (void)gt_viewCreateGlowLayer;

/**
 *  插入辉光的 layer
 */
- (void)gt_viewInsertGlowLayer;

/**
 *  移除辉光的layer
 */
- (void)gt_viewRemoveGlowLayer;

/**
 *  显示辉光
 */
- (void)gt_viewGlowToShowAnimated:(BOOL)animated;

/**
 *  隐藏辉光
 */
- (void)gt_viewGlowToHideAnimated:(BOOL)animated;

/**
 *  开始循环辉光
 */
- (void)gt_viewStartGlowLoop;


@end
