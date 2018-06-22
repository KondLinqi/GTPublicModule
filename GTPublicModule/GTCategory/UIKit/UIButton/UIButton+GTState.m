//
//  UIButton+GTState.m
//  GTKit
//
//  Created by liuxc on 2018/5/3.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#define GTBackgroundColorKEY(state) [NSString stringWithFormat:@"backgroundColor%zd",(long)state]
#define GTBorderColorKEY(state) [NSString stringWithFormat:@"borderColor%zd",(long)state]

#import "UIButton+GTState.h"
#import <objc/runtime.h>
#import "GTMacros.h"

// Model
@interface GTPropertyModel : NSObject

@property (nonatomic, assign) UIControlState state;
@property (nonatomic, copy)   NSString *keyPath;
@property (nonatomic, weak)   id value;

+ (instancetype)propertyModelWithValue:(nullable id)value keyPath:(NSString *)keyPath state:(UIControlState)state;

@end

@implementation GTPropertyModel

+ (instancetype)propertyModelWithValue:(id)value keyPath:(NSString *)keyPath state:(UIControlState)state {
    GTPropertyModel *model = [GTPropertyModel new];
    model.value = value;
    model.keyPath = keyPath;
    model.state = state;
    return model;
}

@end

@interface UIView (BAButton)

/**
 UIView：创建圆角半径阴影，带半径、阴影颜色

 @param cornerRadius 半径
 @param shadowColor 阴影颜色
 @param offset 偏移量
 @param opacity 透明度
 @param shadowRadius 模糊程度
 */
- (void)gt_viewSetRoundShadowWithCornerRadius:(CGFloat)cornerRadius
                                  shadowColor:(UIColor *)shadowColor
                                       offset:(CGSize)offset
                                      opacity:(CGFloat)opacity
                                 shadowRadius:(CGFloat)shadowRadius;

@end

@implementation UIView (BAButton)

/**
 UIView：创建圆角半径阴影，带半径、阴影颜色

 @param cornerRadius 半径
 @param shadowColor 阴影颜色
 @param offset 偏移量
 @param opacity 透明度
 @param shadowRadius 模糊程度
 */
- (void)gt_viewSetRoundShadowWithCornerRadius:(CGFloat)cornerRadius
                                  shadowColor:(UIColor *)shadowColor
                                       offset:(CGSize)offset
                                      opacity:(CGFloat)opacity
                                 shadowRadius:(CGFloat)shadowRadius
{
    if (!shadowColor)
    {
        shadowColor = [UIColor blackColor];
    }
    // 设置阴影的颜色
    self.layer.shadowColor = shadowColor.CGColor;
    // 设置阴影的透明度
    self.layer.shadowOpacity = opacity;
    // 设置阴影的偏移量
    self.layer.shadowOffset = offset;
    // 设置阴影的模糊程度
    self.layer.shadowRadius = shadowRadius;
    // 设置是否栅格化
    self.layer.shouldRasterize = YES;
    // 设置圆角半径
    self.layer.cornerRadius = cornerRadius;
    // 设置阴影的路径
    //    self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:[self bounds]
    //                                                        cornerRadius:cornerRadius] CGPath];
    // 设置边界是否遮盖
    self.layer.masksToBounds = NO;
}

@end

@interface UIButton ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *animates;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIColor *> *borderColors;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIColor *> *backgroundColors;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, UIFont *> *titleLabelFonts;
@property (nonatomic, strong) NSMutableArray<GTPropertyModel *> *subViewPropertyArr;
@property (nonatomic, assign) NSInteger subViewTag;

@end

@implementation UIButton (GTState)

#pragma mark - lefe cycle

+ (void)load {
    kObjc_ReplaceMethod([self class], @selector(setHighlighted:), @selector(gt_setHighlighted:));
    kObjc_ReplaceMethod([self class], @selector(setEnabled:), @selector(gt_setEnabled:));
    kObjc_ReplaceMethod([self class], @selector(setSelected:), @selector(gt_setSelected:));
}

#pragma mark - public method

- (UIColor *)gt_currentBorderColor {
    UIColor *color = [self gt_buttonBorderColorForState:self.state];
    if (!color) {
        color = [UIColor colorWithCGColor:self.layer.borderColor];
    }
    return color;
}

- (UIColor *)gt_currentBackgroundColor {
    UIColor *color = [self gt_buttonBackgroundColorForState:self.state];
    if (!color) {
        color = self.backgroundColor;
    }
    return color;
}

- (UIFont *)gt_currentTitleLabelFont {
    UIFont *font = [self gt_buttonTitleLabelFontForState:(self.state-1)];
    if (!font) {
        font = self.titleLabel.font;
    }
    return font;
}

- (void)gt_buttonSetBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state animated:(BOOL)animated {
    if (backgroundColor) {
        [self.backgroundColors setObject:backgroundColor forKey:@(state)];
        [self.animates setObject:@(animated) forKey:GTBackgroundColorKEY(state)];
    }
    if(self.state == state) {
        self.backgroundColor = backgroundColor;
    }
}

- (void)gt_buttonSetborderColor:(UIColor *)borderColor forState:(UIControlState)state animated:(BOOL)animated {
    if (borderColor) {
        [self.borderColors setObject:borderColor forKey:@(state)];
        [self.animates setObject:@(animated) forKey:GTBorderColorKEY(state)];
    }
    if(self.state == state) {
        self.layer.borderColor = borderColor.CGColor;
    }
}

- (void)gt_buttonSetTitleLabelFont:(UIFont *)titleLabelFont forState:(UIControlState)state {
    if (titleLabelFont) {
        [self.titleLabelFonts setObject:titleLabelFont forKey:@(state)];
    }
    if(self.state == state) {
        self.titleLabel.font = titleLabelFont;
    }
}

- (UIColor *)gt_buttonBorderColorForState:(UIControlState)state {
    return [self.borderColors objectForKey:@(state)];
}

- (UIColor *)gt_buttonBackgroundColorForState:(UIControlState)state {
    return [self.backgroundColors objectForKey:@(state)];
}

- (UIFont *)gt_buttonTitleLabelFontForState:(UIControlState)state {
    return [self.titleLabelFonts objectForKey:@(state)];
}

- (void)gt_buttonConfigBorderColors:(NSDictionary <NSNumber *,UIColor *>*)borderColors {
    self.borderColors = [borderColors mutableCopy];
    [borderColors enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.animates setObject:@(NO) forKey:GTBorderColorKEY(key.integerValue)];
    }];
    [self updateButton];
}

- (void)gt_buttonConfigBackgroundColors:(NSDictionary <NSNumber *,UIColor *>*)backgroundColors {
    self.backgroundColors = [backgroundColors mutableCopy];
    [backgroundColors enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.animates setObject:@(NO) forKey:GTBackgroundColorKEY(key.integerValue)];
    }];
    [self updateButton];
}

- (void)gt_buttonConfigTitleLabelFont:(NSDictionary<NSNumber *,UIFont *> *)titleLabelFonts {
    self.titleLabelFonts = [titleLabelFonts mutableCopy];
    [self updateButton];
}

#pragma mark - override

- (void)gt_setSelected:(BOOL)selected {
    [self gt_setSelected:selected];
    [self updateButton];
}

- (void)gt_setEnabled:(BOOL)enabled {
    [self gt_setEnabled:enabled];
    [self updateButton];
}

- (void)gt_setHighlighted:(BOOL)highlighted {
    [self gt_setHighlighted:highlighted];
    [self updateButton];
}

#pragma mark - private method

- (void)updateButton {
    // updateBackgroundColor
    UIColor *backgroundColor = [self gt_buttonBackgroundColorForState:self.state];
    if (backgroundColor) {
        [self updateBackgroundColor:backgroundColor];
    } else {
        UIColor *normalColor = [self gt_buttonBackgroundColorForState:UIControlStateNormal];
        if (normalColor) {
            [self updateBackgroundColor:normalColor];
        }
    }

    // updateBorderColor
    UIColor *borderColor = [self gt_buttonBorderColorForState:self.state];
    if (borderColor) {
        [self updateBorderColor:borderColor];
    } else {
        UIColor *normalColor = [self gt_buttonBorderColorForState:UIControlStateNormal];
        if (normalColor) {
            [self updateBorderColor:normalColor];
        }
    }

    // updateTitleLabelFont
    UIFont *titleLabelFont = [self gt_buttonTitleLabelFontForState:self.state];
    if (titleLabelFont) {
        self.titleLabel.font = titleLabelFont;
    } else {
        UIFont *normalFont = [self gt_buttonTitleLabelFontForState:UIControlStateNormal];
        if (normalFont) {
            self.titleLabel.font = normalFont;
        }
    }

    // updateSubViewProperty
    UIView *subView = [self viewWithTag:self.subViewTag];
    if (subView && self.subViewPropertyArr.count>0) {
        [self.subViewPropertyArr enumerateObjectsUsingBlock:^(GTPropertyModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            //点击一次,方法多次调用,model.value可能为nil,此时不应进入赋值,否则覆盖掉之前的值
            if (self.state == model.state && model.value) {
                //转换成nil
                id nullableValue = (model.value == [NSNull null]) ? nil : model.value;
                [subView setValue:nullableValue forKeyPath:model.keyPath];
            }
        }];
    }
}

- (void)updateBackgroundColor:(UIColor *)backgroundColor {
    NSNumber *animateValue = [self.animates objectForKey:GTBackgroundColorKEY(self.state)];
    if (!animateValue) return;//不存在

    if (animateValue.integerValue == self.subViewTag) {
        self.backgroundColor = backgroundColor;
    } else { //等于1
        [UIView animateWithDuration:self.gt_animatedDuration animations:^{
            self.backgroundColor = backgroundColor;
        }];
    }
}

- (void)updateBorderColor:(UIColor *)borderColor {
    NSNumber *animateValue = [self.animates objectForKey:GTBorderColorKEY(self.state)];

    if (!animateValue) return;//不存在

    if (animateValue.integerValue == 0) {
        self.layer.borderColor = borderColor.CGColor;
        [self.layer removeAnimationForKey:@"KEYAnimation"];
    } else {//等于1
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
        animation.fromValue = (__bridge id _Nullable)(self.layer.borderColor);
        animation.toValue = (__bridge id _Nullable)(borderColor.CGColor);
        animation.duration = self.gt_animatedDuration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [self.layer addAnimation:animation forKey:@"KEYAnimation"];
        self.layer.borderColor = borderColor.CGColor;
    }
}

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
                                       forState:(UIControlState)state
{
    [self gt_viewSetRoundShadowWithCornerRadius:0 shadowColor:nil offset:CGSizeZero opacity:0 shadowRadius:0];

    [self gt_viewSetRoundShadowWithCornerRadius:cornerRadius shadowColor:shadowColor offset:offset opacity:opacity shadowRadius:shadowRadius];
}

#pragma mark - getters and setters

- (void)setAnimates:(NSMutableDictionary *)animates {
    objc_setAssociatedObject(self, @selector(animates), animates, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)animates {
    NSMutableDictionary *animates = objc_getAssociatedObject(self, _cmd);
    if (!animates) {
        animates = [NSMutableDictionary new];
        self.animates = animates;
    }
    return animates;
}

- (void)setBorderColors:(NSMutableDictionary *)borderColors {
    objc_setAssociatedObject(self, @selector(borderColors), borderColors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)borderColors {
    NSMutableDictionary *borderColors = objc_getAssociatedObject(self, _cmd);
    if (!borderColors) {
        borderColors = [NSMutableDictionary new];
        self.borderColors = borderColors;
    }
    return borderColors;
}

- (void)setBackgroundColors:(NSMutableDictionary *)backgroundColors {
    objc_setAssociatedObject(self, @selector(backgroundColors), backgroundColors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (NSMutableDictionary *)backgroundColors {
    NSMutableDictionary *backgroundColors = objc_getAssociatedObject(self, _cmd);
    if(!backgroundColors) {
        backgroundColors = [[NSMutableDictionary alloc] init];
        self.backgroundColors = backgroundColors;
    }
    return backgroundColors;
}

- (void)setTitleLabelFonts:(NSMutableDictionary *)titleLabelFonts {
    objc_setAssociatedObject(self, @selector(titleLabelFonts), titleLabelFonts, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (NSMutableDictionary *)titleLabelFonts {
    NSMutableDictionary *titleLabelFonts = objc_getAssociatedObject(self, _cmd);
    if(!titleLabelFonts) {
        titleLabelFonts = [[NSMutableDictionary alloc] init];
        self.titleLabelFonts = titleLabelFonts;
    }
    return titleLabelFonts;
}

- (void)setGt_animatedDuration:(NSTimeInterval)gt_animatedDuration {
    objc_setAssociatedObject(self, @selector(gt_animatedDuration), @(gt_animatedDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)gt_animatedDuration {
    NSTimeInterval duartion = [objc_getAssociatedObject(self, _cmd) doubleValue];
    if (duartion == 0) {
        duartion = 0.25;
    }
    return duartion;
}

- (void)setSubViewPropertyArr:(NSMutableArray<GTPropertyModel *> *)subViewPropertyArr {
    objc_setAssociatedObject(self, @selector(subViewPropertyArr), subViewPropertyArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (NSMutableArray<GTPropertyModel *> *)subViewPropertyArr {
    NSMutableArray *subViewPropertyArr = objc_getAssociatedObject(self, _cmd);
    if(!subViewPropertyArr) {
        subViewPropertyArr = [[NSMutableArray alloc] init];
        self.subViewPropertyArr = subViewPropertyArr;
    }
    return subViewPropertyArr;
}

- (void)setSubViewTag:(NSInteger)subViewTag {
    objc_setAssociatedObject(self, @selector(subViewTag), @(subViewTag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)subViewTag {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}



@end
