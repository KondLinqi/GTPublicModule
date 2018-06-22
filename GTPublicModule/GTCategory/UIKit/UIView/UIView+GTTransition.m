//
//  UIView+GTTransition.m
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UIView+GTTransition.h"

@implementation UIView (GTTransition)

#pragma mark - CATransition动画实现
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
                      forView:(UIView *)forView
{
    if (!duration)
    {
        duration = 0.8f;
    }
    /*! 定义个转场动画 */
    CATransition *transition = [CATransition animation];
    
    /*! 转场动画持续时间 */
    transition.duration = duration;
    /*! 转场动画类型【过渡效果】 */
    [self gt_selectTransitionType:type subType:subType timingFunction:timingFunction transition:transition];
    
    /*! 计时函数，从头到尾的流畅度 */
    //    transition.timingFunction = timingFunction;
    /*! 在动画执行完时是否被移除 */
    transition.removedOnCompletion = removedOnCompletion;
    /*! 暂时不知,感觉与Progress一起用的,如果不加,Progress好像没有效果  */
    //    transition.fillMode = fillMode;
    
    //    transition.beginTime = beginTime;
    /*!
     图层的速率。 用于将父时间缩放为本地时间，例如
     *如果rate为2，本地时间的进度是父时间的两倍。
     *默认为1.  */
    //    transition.speed = beginTime;
    /*! 动画停止(在整体动画的百分比).  */
    //    transition.endProgress = beginTime;
    /*! 动画开始(在整体动画的百分比).   */
    //    transition.startProgress = beginTime;
    
    /*! 添加动画（转场动画是添加在层上的动画） */
    [forView.layer addAnimation:transition forKey:nil];
}

#pragma - UIView 实现动画
/*!
 *  UIView 实现动画
 *
 *  @param duration       转场动画持续时间，默认：0.8f
 *  @param animationCurve 动画曲线，默认：UIViewAnimationCurveEaseInOut
 *  @param transition     动画过渡，默认：UIViewAnimationTransitionNone
 *  @param forView        添加动画（转场动画是添加在层上的动画）
 */
- (void)gt_transitionViewWithDuration:(CFTimeInterval)duration
                       animationCurve:(UIViewAnimationCurve)animationCurve
                           transition:(UIViewAnimationTransition)transition
                              forView:(UIView *)forView
{
    if (!duration)
    {
        duration = 0.8f;
    }
    if (!animationCurve)
    {
        animationCurve = UIViewAnimationCurveEaseInOut;
    }
    if (!transition)
    {
        transition = UIViewAnimationTransitionNone;
    }
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:animationCurve];
        [UIView setAnimationTransition:transition forView:forView cache:YES];
    }];
}

- (void)gt_selectTransitionType:(GTViewTransitionType)type
                        subType:(GTViewTransitionSubtype)subType
                 timingFunction:(GTViewTransitionTimingFunctionType)timingFunction
                     transition:(CATransition *)transition
{
    if (!type)
    {
        type = GTViewTransitionTypeFade;
    }
    switch (type) {
        case GTViewTransitionTypeFade:
            transition.type = kCATransitionFade;
            break;
            
        case GTViewTransitionTypePush:
            transition.type = kCATransitionPush;
            break;
            
        case GTViewTransitionTypeReveal:
            transition.type = kCATransitionReveal;
            break;
            
        case GTViewTransitionTypeMoveIn:
            transition.type = kCATransitionMoveIn;
            break;
            
        case GTViewTransitionTypeCube:
            transition.type = @"cube";
            break;
            
        case GTViewTransitionTypeSuckEffect:
            transition.type = @"suckEffect";
            break;
            
        case GTViewTransitionTypeOglFlip:
            transition.type = @"oglFlip";
            break;
            
        case GTViewTransitionTypeRippleEffect:
            transition.type = @"rippleEffect";
            break;
            
        case GTViewTransitionTypePageCurl:
            transition.type = @"pageCurl";
            break;
            
        case GTViewTransitionTypePageUnCurl:
            transition.type = @"pageUnCurl";
            break;
            
        case GTViewTransitionTypeCameraIrisHollowOpen:
            transition.type = @"cameraIrisHollowOpen";
            break;
            
        case GTViewTransitionTypeCameraIrisHollowClose:
            transition.type = @"cameraIrisHollowClose";
            break;
            
        default:
            break;
    }
    
    if (!subType)
    {
        subType = GTViewTransitionSubtypeFromRight;
    }
    switch (subType) {
        case GTViewTransitionSubtypeFromTop:
            transition.subtype = kCATransitionFromTop;
            break;
        case GTViewTransitionSubtypeFromBottom:
            transition.subtype = kCATransitionFromBottom;
            break;
        case GTViewTransitionSubtypeFromLeft:
            transition.subtype = kCATransitionFromLeft;
            break;
        case GTViewTransitionSubtypeFromRight:
            transition.subtype = kCATransitionFromRight;
            break;
            
        default:
            break;
    }
    
    if (!timingFunction)
    {
        timingFunction = GTViewTransitionTimingFunctionTypeDefault;
    }
    switch (timingFunction) {
        case GTViewTransitionTimingFunctionTypeDefault:
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            break;
            
        case GTViewTransitionTimingFunctionTypeLinear:
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            break;
        case GTViewTransitionTimingFunctionTypeEaseIn:
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            break;
        case GTViewTransitionTimingFunctionTypeEaseOut:
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            break;
        case GTViewTransitionTimingFunctionTypeEaseInEaseOut:
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            break;
            
        default:
            break;
    }
}

@end
