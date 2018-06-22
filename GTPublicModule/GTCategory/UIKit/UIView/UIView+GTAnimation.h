//
//  UIView+GTAnimation.h
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CALayer+GTAnimation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Provides normal animation extensions for `UIView`.
 */

/**
 view 的 进出场动画 方向
 
 - GTViewAnimationEnterDirectionTypeTop: 从 top 进入
 - GTViewAnimationEnterDirectionTypeLeft: 从 left 进入
 - GTViewAnimationEnterDirectionTypeBottom: 从 bottom 进入
 - GTViewAnimationEnterDirectionTypeRitht: 从 right 进入
 */
typedef NS_ENUM(NSUInteger, GTViewAnimationEnterDirectionType) {
    GTViewAnimationEnterDirectionTypeTop,
    GTViewAnimationEnterDirectionTypeLeft,
    GTViewAnimationEnterDirectionTypeBottom,
    GTViewAnimationEnterDirectionTypeRitht,
};

/**
 view 的 翻动动画 方向
 
 - GTViewAnimationFlipDirectionTypeTop: 向 top 翻动
 - GTViewAnimationFlipDirectionTypeLeft: 向 left 翻动
 - GTViewAnimationFlipDirectionTypeBottom: 向 bottom 翻动
 - GTViewAnimationFlipDirectionTypeRight: 向 right 翻动
 */
typedef NS_ENUM(NSUInteger, GTViewAnimationFlipDirectionType)
{
    GTViewAnimationFlipDirectionTypeTop = 0,
    GTViewAnimationFlipDirectionTypeLeft,
    GTViewAnimationFlipDirectionTypeBottom,
    GTViewAnimationFlipDirectionTypeRight,
};

/**
 *  Direction of the translation
 */
typedef NS_ENUM(NSInteger, UIViewAnimationTranslationDirection)
{
    /**
     *  Translation from left to right
     */
    UIViewAnimationTranslationDirectionFromLeftToRight = 0,
    /**
     *  Translation from right to left
     */
    UIViewAnimationTranslationDirectionFromRightToLeft
};

/**
 *  Direction of the linear gradient
 */
typedef NS_ENUM(NSInteger, UIViewLinearGradientDirection)
{
    /**
     *  Linear gradient vertical
     */
    UIViewLinearGradientDirectionVertical = 0,
    /**
     *  Linear gradient horizontal
     */
    UIViewLinearGradientDirectionHorizontal,
    /**
     *  Linear gradient from left to right and top to down
     */
    UIViewLinearGradientDirectionDiagonalFromLeftToRightAndTopToDown,
    /**
     *  Linear gradient from left to right and down to top
     */
    UIViewLinearGradientDirectionDiagonalFromLeftToRightAndDownToTop,
    /**
     *  Linear gradient from right to left and top to down
     */
    UIViewLinearGradientDirectionDiagonalFromRightToLeftAndTopToDown,
    /**
     *  Linear gradient from right to left and down to top
     */
    UIViewLinearGradientDirectionDiagonalFromRightToLeftAndDownToTop
};


@interface UIView (GTAnimation)

/*!
 *  缩放显示动画
 *
 *  @param duration    持续时间，默认：1.0f
 *  @param scaleRatio  缩放比率，默认：1.6f
 *  @param finishBlock 缩放完成回调
 */
- (void)gt_animation_scaleShowWithDuration:(CGFloat)duration
                                     ratio:(CGFloat)scaleRatio
                               finishBlock:(void(^)(void))finishBlock;

/*!
 *  缩放消失动画
 *
 *  @param duration    持续时间，默认：1.0f
 *  @param scaleRatio  缩放比率，默认：1.6f
 *  @param finishBlock 缩放完成回调
 */
- (void)gt_animation_scaleDismissWithDuration:(CGFloat)duration
                                        ratio:(CGFloat)scaleRatio
                                  finishBlock:(void(^)(void))finishBlock;

/*!
 *  透明度动画
 *
 *  @param duration    持续时间，默认：1.5f
 *  @param startAlpha  开始的 alpha，默认：0.2f
 *  @param finishAlpha 结束的 alpha，默认：1.0f
 */
- (void)gt_animation_alphaWithDuration:(CGFloat)duration
                            startAlpha:(CGFloat)startAlpha
                           finishAlpha:(CGFloat)finishAlpha;

/*!
 *  转场动画
 *
 *  @param duration      持续时间，默认：1.5f
 *  @param startOptions  开始转场动画样式
 *  @param finishOptions 结束转场动画样式
 *  @param finishBlock   转场结束回调
 */
- (void)gt_animation_transitionWithDuration:(CGFloat)duration
                               startOptions:(UIViewAnimationOptions)startOptions
                              finishOptions:(UIViewAnimationOptions)finishOptions
                                finishBlock:(void(^)(void))finishBlock;

/*!
 *  改变 frame 动画
 *
 *  @param duration      持续时间，默认：1.5f
 *  @param originalFrame 原始 frame
 *  @param newFrame      更改后的 frame
 *  @param finishBlock   结束回调
 */
- (void)gt_animation_changFrameWithDuration:(CGFloat)duration
                              originalFrame:(CGRect)originalFrame
                                   newFrame:(CGRect)newFrame
                                finishBlock:(void(^)(void))finishBlock;

/*!
 *  改变 Bounds 动画
 *
 *  @param duration       持续时间，默认：1.5f
 *  @param originalBounds 原始 Bounds
 *  @param newBounds      更改后的 Bounds
 *  @param finishBlock    结束回调
 */
- (void)gt_animation_changBoundsWithDuration:(CGFloat)duration
                              originalBounds:(CGRect)originalBounds
                                   newBounds:(CGRect)newBounds
                                 finishBlock:(void(^)(void))finishBlock;

/*!
 *  改变 Center 动画
 *
 *  @param duration       持续时间，默认：1.5f
 *  @param originalCenter 原始 Center
 *  @param newCenter      更改后的 Center
 *  @param finishBlock    结束回调
 */
- (void)gt_animation_changCenterWithDuration:(CGFloat)duration
                              originalCenter:(CGPoint)originalCenter
                                   newCenter:(CGPoint)newCenter
                                 finishBlock:(void(^)(void))finishBlock;

/**
 弹簧动画
 
 @param duration 持续时间，默认：1.5f
 @param delay delay
 @param damping 震动效果，范围 0~1，数值越小震动效果越明显
 @param initialSpringVelocity 初始速度，数值越大初始速度越快，默认：1.0f
 @param startOptions 动画的过渡效果
 @param finishOptions 动画的过渡效果
 @param startBlock 开始动画回调
 @param finishBlock 结束动画回调
 */
- (void)gt_animation_springWithDuration:(CGFloat)duration
                                  delay:(CGFloat)delay
                                damping:(CGFloat)damping
                  initialSpringVelocity:(CGFloat)initialSpringVelocity
                           startOptions:(UIViewAnimationOptions)startOptions
                          finishOptions:(UIViewAnimationOptions)finishOptions
                             startBlock:(void(^)(void))startBlock
                            finishBlock:(void(^)(void))finishBlock;

/**
 view 出现动画
 
 @param positionType 位置类型
 @param duration duration 默认：1.0f
 @param finishBlock finishBlock
 */
- (void)gt_animation_showFromPositionType:(GTViewAnimationEnterDirectionType)positionType
                                 duration:(CGFloat)duration
                              finishBlock:(void(^)(void))finishBlock;

/**
 view 消失动画
 
 @param positionType 位置类型
 @param duration duration 默认：1.0f
 @param finishBlock finishBlock
 */
- (void)gt_animation_dismissFromPositionType:(GTViewAnimationEnterDirectionType)positionType
                                    duration:(CGFloat)duration
                                 finishBlock:(void(^)(void))finishBlock;

/**
 view 翻转动画
 
 @param duration 位置类型
 @param direction duration 默认：1.0f
 */
- (void)gt_animation_flipWithDuration:(NSTimeInterval)duration
                            direction:(GTViewAnimationFlipDirectionType)direction;

- (void)gt_animation_translateAroundTheView:(UIView *)topView
                                   duration:(CGFloat)duration
                                  direction:(UIViewAnimationTranslationDirection)direction
                                     repeat:(BOOL)repeat
                              startFromEdge:(BOOL)startFromEdge;

/**
 线性梯度：渐变色，注意：渐变颜色必须要有两个及两个以上颜色，否则设置无效！
 
 @param colorArray 颜色数组，至少两个
 @param frame frame
 @param direction 方向，横向还是纵向
 */
- (void)gt_animation_createGradientWithColorArray:(NSArray *)colorArray
                                            frame:(CGRect)frame
                                        direction:(UIViewLinearGradientDirection)direction;

/**
 *  摇晃动画：用于错误提示，晃动的幅度，默认：5.0f，晃动的次数，默认：5.0f
 */
- (void)gt_animation_viewAnimationShake;

/**
 脉冲动画
 
 @param duration duration
 */
- (void)gt_animation_pulseViewWithDuration:(CGFloat)duration;

/**
 运动效果
 */
- (void)gt_animation_applyMotionEffects;

/**
 UIView：简单的 alpha 动画
 
 @param alpha alpha description
 @param duration duration description
 @param animated animated description
 */
- (void)gt_animationWithAlpha:(CGFloat)alpha
                     duration:(NSTimeInterval)duration
                     animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
