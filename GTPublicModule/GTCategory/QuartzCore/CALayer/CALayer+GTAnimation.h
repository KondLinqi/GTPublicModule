//
//  CALayer+GTAnimation.h
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (GTAnimation)

/**
 摇晃动画：用于错误提示
 
 @param value 晃动的幅度，默认：5.0f
 @param repeatCount 晃动的次数，默认：5.0f
 */
- (void)gt_layer_animationShakeWithValue:(CGFloat)value repeatCount:(CGFloat)repeatCount;

@end

NS_ASSUME_NONNULL_END
