//
//  UIView+BAGlowView.m
//  GTKit
//
//  Created by boai on 2017/7/18.
//  Copyright © 2017年 boai. All rights reserved.
//

#import "UIView+GTGlowView.h"
#import "CABasicAnimation+GTKit.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic, strong) CALayer           *gt_glowLayer;
@property (nonatomic, strong) dispatch_source_t  gt_dispatchSource;

@end

@implementation UIView (GTGlowView)

/**
 *  创建出辉光 layer
 */
- (void)gt_viewCreateGlowLayer
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    [[self gt_accessGlowColor] setFill];
    [path fillWithBlendMode:kCGBlendModeSourceAtop alpha:1.0f];
    
    self.gt_glowLayer = [CALayer layer];
    self.gt_glowLayer.frame = self.bounds;
    self.gt_glowLayer.contents = (__bridge id _Nullable)(UIGraphicsGetImageFromCurrentImageContext().CGImage);
    self.gt_glowLayer.opacity = 0.f;
    self.gt_glowLayer.shadowOffset = CGSizeMake(0, 0);
    self.gt_glowLayer.shadowOpacity = 1.0f;
    
    UIGraphicsEndImageContext();
}

/**
 *  插入辉光的 layer
 */
- (void)gt_viewInsertGlowLayer
{
    if (self.gt_glowLayer)
    {
        [self.layer addSublayer:self.gt_glowLayer];
    }
}

/**
 *  移除辉光的layer
 */
- (void)gt_viewRemoveGlowLayer
{
    if (self.gt_glowLayer)
    {
        [self.gt_glowLayer removeFromSuperlayer];
    }
}

/**
 *  显示辉光
 */
- (void)gt_viewGlowToShowAnimated:(BOOL)animated
{
    self.gt_glowLayer.shadowColor = [self gt_accessGlowColor].CGColor;
    self.gt_glowLayer.shadowRadius = [self gt_accessGlowRadius].floatValue;
    
    if (animated)
    {
        CABasicAnimation *animation = [CABasicAnimation gt_basicAnimation_opacityWithDuration:[self gt_accessAnimationDuration].floatValue repeatCount:0 beginTime:0 fromValueOpacity:0.f toValueOpacity:[self gt_accessGlowOpacity].floatValue autoreverses:NO];
        self.gt_glowLayer.opacity = [self gt_accessGlowOpacity].floatValue;

        [self.gt_glowLayer addAnimation:animation forKey:@"glowLayerOpacity"];
    }
    else
    {
        [self.gt_glowLayer removeAnimationForKey:@"glowLayerOpacity"];
        self.gt_glowLayer.opacity = [self gt_accessGlowOpacity].floatValue;
    }
}

/**
 *  隐藏辉光
 */
- (void)gt_viewGlowToHideAnimated:(BOOL)animated
{
    self.gt_glowLayer.shadowColor = [self gt_accessGlowColor].CGColor;
    self.gt_glowLayer.shadowRadius = [self gt_accessGlowRadius].floatValue;
    
    if (animated)
    {
        CABasicAnimation *animation = [CABasicAnimation gt_basicAnimation_opacityWithDuration:[self gt_accessAnimationDuration].floatValue repeatCount:0 beginTime:0 fromValueOpacity:[self gt_accessGlowOpacity].floatValue toValueOpacity:0.f autoreverses:NO];
        self.gt_glowLayer.opacity = 0.f;
        
        [self.gt_glowLayer addAnimation:animation forKey:@"glowLayerOpacity"];
    }
    else
    {
        [self.gt_glowLayer removeAnimationForKey:@"glowLayerOpacity"];
        self.gt_glowLayer.opacity = 0.f;
    }
}

/**
 *  开始循环辉光
 */
- (void)gt_viewStartGlowLoop
{
    if (self.gt_dispatchSource == nil)
    {
        CGFloat seconds      = [self gt_accessAnimationDuration].floatValue * 2 + [self gt_accessGlowDuration].floatValue + [self gt_accessHideDuration].floatValue;
        CGFloat delaySeconds = [self gt_accessAnimationDuration].floatValue + [self gt_accessGlowDuration].floatValue;
        
        self.gt_dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        
        __weak UIView *weakSelf = self;
        dispatch_source_set_timer(self.gt_dispatchSource, dispatch_time(DISPATCH_TIME_NOW, 0), NSEC_PER_SEC * seconds, 0);
        dispatch_source_set_event_handler(self.gt_dispatchSource, ^{
            
            [weakSelf gt_viewGlowToShowAnimated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * delaySeconds), dispatch_get_main_queue(), ^{
                
                [weakSelf gt_viewGlowToHideAnimated:YES];
            });
        });
        
        dispatch_resume(self.gt_dispatchSource);
    }
    
}


#pragma mark - setter getter

- (UIColor *)gt_accessGlowColor
{
    if (self.gt_glowColor)
    {
        return self.gt_glowColor;
    }
    else
    {
        return UIColor.redColor;
    }
}

- (NSNumber *)gt_accessGlowRadius
{
    if (self.gt_glowRadius)
    {
        if (self.gt_glowRadius.floatValue <= 0)
        {
            return @(2.0f);
        }
        else
        {
            return self.gt_glowRadius;
        }
    }
    else
    {
        return @(2.0f);
    }
}

- (NSNumber *)gt_accessAnimationDuration
{
    if (self.gt_glowAnimationDuration)
    {
        if (self.gt_glowAnimationDuration.floatValue <= 0)
        {
            return @(1.0f);
        }
        else
        {
            return self.gt_glowAnimationDuration;
        }
    }
    else
    {
        return @(1.0f);
    }
}

- (NSNumber *)gt_accessHideDuration
{
    if (self.gt_hideDuration)
    {
        if (self.gt_hideDuration.floatValue < 0)
        {
            return @(0.5f);
        }
        else
        {
            return self.gt_hideDuration;
        }
    }
    else
    {
        return @(0.5f);
    }
}

- (NSNumber *)gt_accessGlowDuration
{
    if (self.gt_glowDuration)
    {
        if (self.gt_glowDuration.floatValue <= 0)
        {
            return @(0.5f);
        }
        else
        {
            return self.gt_glowDuration;
        }
    }
    else
    {
        return @(0.5f);
    }
}

- (NSNumber *)gt_accessGlowOpacity
{
    if (self.gt_glowOpacity)
    {
        if (self.gt_glowOpacity.floatValue <= 0 || self.gt_glowOpacity.floatValue > 1)
        {
            return @(0.8f);
        }
        else
        {
            return self.gt_glowOpacity;
        }
    }
    else
    {
        return @(0.8f);
    }
}

- (void)setGt_dispatchSource:(dispatch_source_t)gt_dispatchSource
{
    objc_setAssociatedObject(self, @selector(gt_dispatchSource), gt_dispatchSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (dispatch_source_t)gt_dispatchSource
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_glowColor:(UIColor *)gt_glowColor
{
    objc_setAssociatedObject(self, @selector(gt_glowColor), gt_glowColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)gt_glowColor
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_glowOpacity:(NSNumber *)gt_glowOpacity
{
    objc_setAssociatedObject(self, @selector(gt_glowOpacity), gt_glowOpacity, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)gt_glowOpacity
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_glowRadius:(NSNumber *)gt_glowRadius
{
    objc_setAssociatedObject(self, @selector(gt_glowRadius), gt_glowRadius, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)gt_glowRadius
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_glowAnimationDuration:(NSNumber *)gt_glowAnimationDuration
{
    objc_setAssociatedObject(self, @selector(gt_glowAnimationDuration), gt_glowAnimationDuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)gt_glowAnimationDuration
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_glowDuration:(NSNumber *)gt_glowDuration
{
    objc_setAssociatedObject(self, @selector(gt_glowDuration), gt_glowDuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)gt_glowDuration
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_hideDuration:(NSNumber *)gt_hideDuration
{
    objc_setAssociatedObject(self, @selector(gt_hideDuration), gt_hideDuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)gt_hideDuration
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_glowLayer:(CALayer *)gt_glowLayer
{
    objc_setAssociatedObject(self, @selector(gt_glowLayer), gt_glowLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)gt_glowLayer
{
    return objc_getAssociatedObject(self, _cmd);
}

@end
