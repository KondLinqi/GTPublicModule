//
//  CALayer+GTAnimation.m
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "CALayer+GTAnimation.h"

static NSString * const kAnimationKey_shake = @"kAnimationKey_shake";

@implementation CALayer (GTAnimation)

/**
 摇晃动画：用于错误提示
 
 @param value 晃动的幅度，默认：5.0f
 @param repeatCount 晃动的次数，默认：5.0f
 */
- (void)gt_layer_animationShakeWithValue:(CGFloat)value repeatCount:(CGFloat)repeatCount
{
    if (!value)
    {
        value = 5.0f;
    }
    if (!repeatCount)
    {
        repeatCount = 4.0f;
    }
    // 创建关键帧动画类
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    //    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    
    // 设置每个关键帧的值对象的数组
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-value, 0.0f, 0.0f)], [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f)], [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(value, 0.0f, 0.0f)]];
    //    animation.values = @[@(-value),@(0),@(value),@(0),@(-value),@(0),@(value),@(0)];
    
    // 设置是否自动翻转
    animation.autoreverses = YES;
    // 设置重复次数
    animation.repeatCount = repeatCount;
    // 设置间隔时间
    animation.duration = 0.08f;
    // 添加动画
    [self addAnimation:animation forKey:kAnimationKey_shake];
}




@end
