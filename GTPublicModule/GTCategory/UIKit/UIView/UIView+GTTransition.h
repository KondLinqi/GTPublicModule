//
//  UIView+GTTransition.h
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

/*! Common transition types. */
typedef NS_ENUM(NSUInteger, GTViewTransitionType) {
    /*! 淡入淡出 */
    GTViewTransitionTypeFade = 0,
    /*! 推挤 */
    GTViewTransitionTypePush,
    /*! 揭开 */
    GTViewTransitionTypeReveal,
    /*! 覆盖 */
    GTViewTransitionTypeMoveIn,
    /*! 立方体 */
    GTViewTransitionTypeCube,
    /*! 吮吸 */
    GTViewTransitionTypeSuckEffect,
    /*! 翻转 */
    GTViewTransitionTypeOglFlip,
    /*! 波纹 */
    GTViewTransitionTypeRippleEffect,
    /*! 翻页 */
    GTViewTransitionTypePageCurl,
    /*! 反翻页 */
    GTViewTransitionTypePageUnCurl,
    /*! 开镜头 */
    GTViewTransitionTypeCameraIrisHollowOpen,
    /*! 关镜头 */
    GTViewTransitionTypeCameraIrisHollowClose,
    // 下翻页效果
    GTViewTransitionTypeCurlDown,
    // 上翻页效果
    GTViewTransitionTypeCurlUp,
    // 左翻转效果
    GTViewTransitionTypeFlipFromLeft,
    // 右翻转效果
    GTViewTransitionTypeFlipFromRight
};

/*! Common transition subtypes. */
typedef NS_ENUM(NSUInteger, GTViewTransitionSubtype) {
    GTViewTransitionSubtypeFromRight = 0,
    GTViewTransitionSubtypeFromLeft,
    GTViewTransitionSubtypeFromTop,
    GTViewTransitionSubtypeFromBottom
};

/*!  Timing function names.  */
typedef NS_ENUM(NSUInteger, GTViewTransitionTimingFunctionType) {
    /*! 默认 */
    GTViewTransitionTimingFunctionTypeDefault = 0,
    /*! 线性,即匀速 */
    GTViewTransitionTimingFunctionTypeLinear,
    /*! 先慢后快 */
    GTViewTransitionTimingFunctionTypeEaseIn,
    /*! 先快后慢 */
    GTViewTransitionTimingFunctionTypeEaseOut,
    /*! 先慢后快再慢 */
    GTViewTransitionTimingFunctionTypeEaseInEaseOut
};

@interface UIView (GTTransition)

/*!
 *  CATransition动画实现
 *
 *  @param type                转场动画类型【过渡效果】，默认：GTViewTransitionTypeFade
 *  @param subType             转场动画将去的方向，默认：GTViewTransitionSubtypeFromRight
 *  @param duration            转场动画持续时间，默认：0.8f
 *  @param timingFunction      计时函数，从头到尾的流畅度，默认：GTViewTransitionTimingFunctionTypeDefault
 *  @param removedOnCompletion 在动画执行完时是否被移除，默认：YES
 *  @param forView             添加动画（转场动画是添加在层上的动画）
 */
- (void)gt_transitionWithType:(GTViewTransitionType)type
                      subType:(GTViewTransitionSubtype)subType
                     duration:(CFTimeInterval)duration
               timingFunction:(GTViewTransitionTimingFunctionType)timingFunction
          removedOnCompletion:(BOOL)removedOnCompletion
                      forView:(UIView *)forView;

/*!
 *  UIView实现动画
 *
 *  @param duration       转场动画持续时间，默认：0.8f
 *  @param animationCurve 动画曲线，默认：UIViewAnimationCurveEaseInOut
 *  @param transition     动画过渡，默认：UIViewAnimationTransitionNone
 *  @param forView        添加动画（转场动画是添加在层上的动画）
 */
- (void)gt_transitionViewWithDuration:(CFTimeInterval)duration
                       animationCurve:(UIViewAnimationCurve)animationCurve
                           transition:(UIViewAnimationTransition)transition
                              forView:(UIView *)forView;

@end
