//
//  UIView+GTStyle.m
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//
#import "UIView+GTStyle.h"
#import "CALayer+GTKit.h"
#import "GTMacros.h"

@implementation UIView (GTStyle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kObjc_ReplaceMethod([self class], @selector(initWithFrame:), @selector(gt_initWithFrame:));
        kObjc_ReplaceMethod([self class], @selector(initWithCoder:), @selector(gt_initWithCoder:));
        kObjc_ReplaceMethod([self class], @selector(layoutSublayersOfLayer:), @selector(gt_layoutSublayersOfLayer:));
    });
}

- (instancetype)gt_initWithFrame:(CGRect)frame {
    [self gt_initWithFrame:frame];
    [self setDefaultStyle];
    return self;
}

- (instancetype)gt_initWithCoder:(NSCoder *)aDecoder {
    [self gt_initWithCoder:aDecoder];
    [self setDefaultStyle];
    return self;
}


- (void)gt_layoutSublayersOfLayer:(CALayer *)layer {
    [self gt_layoutSublayersOfLayer: layer];
    
    [self setupCornerType];
    [self setupBorderType];

}

- (void)setDefaultStyle {
    self.gt_borderWidth = CGFloatFromPixel(1);
    self.gt_borderColor = [UIColor lightGrayColor];
    self.gt_cornerRadius = 0.0f;
    self.gt_cornerType = GTViewCornerTypeAllCorners;
}

#pragma mark - setter / getter
- (void)setGt_cornerType:(GTViewCornerType)gt_cornerType
{
    objc_setAssociatedObject(self, @selector(gt_cornerType), @(gt_cornerType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (GTViewCornerType)gt_cornerType
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setGt_cornerRadius:(CGFloat)gt_cornerRadius
{
    objc_setAssociatedObject(self, @selector(gt_cornerRadius), @(gt_cornerRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)gt_cornerRadius
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}


- (void)setGt_borderPosition:(GTViewBorderPosition)gt_borderPosition {
    objc_setAssociatedObject(self, @selector(gt_borderPosition), @(gt_borderPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (GTViewBorderPosition)gt_borderPosition {
    return (GTViewBorderPosition)[objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}

- (void)setGt_borderWidth:(CGFloat)gt_borderWidth {
    objc_setAssociatedObject(self, @selector(gt_borderWidth), @(gt_borderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (CGFloat)gt_borderWidth {
    return (CGFloat)[objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setGt_borderColor:(UIColor *)gt_borderColor {
    objc_setAssociatedObject(self, @selector(gt_borderColor), gt_borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (UIColor *)gt_borderColor {
    return (UIColor *)objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_dashPhase:(CGFloat)gt_dashPhase {
    objc_setAssociatedObject(self, @selector(gt_dashPhase), @(gt_dashPhase), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (CGFloat)gt_dashPhase {
    return (CGFloat)[objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setGt_dashPattern:(NSArray<NSNumber *> *)gt_dashPattern {
    objc_setAssociatedObject(self, @selector(gt_dashPattern), gt_dashPattern, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
}

- (NSArray *)gt_dashPattern {
    return (NSArray<NSNumber *> *)objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_borderLayer:(CAShapeLayer *)gt_borderLayer {
    objc_setAssociatedObject(self, @selector(gt_borderLayer), gt_borderLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)gt_borderLayer {
    return (CAShapeLayer *)objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_shapeLayer:(CAShapeLayer *)gt_shapeLayer
{
    objc_setAssociatedObject(self, @selector(gt_shapeLayer), gt_shapeLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)gt_shapeLayer {
    return (CAShapeLayer *)objc_getAssociatedObject(self, _cmd);
}


#pragma mark - view 的 角半径，默认 CGSizeMake(0, 0)
- (void)setupCornerType
{

    if (self.gt_cornerRadius == 0) {
        return;
    }

    UIRectCorner corners;
    CGSize cornerRadii;
    
    cornerRadii = CGSizeMake(self.gt_cornerRadius, self.gt_cornerRadius);
    if (self.gt_cornerRadius == 0)
    {
        cornerRadii = CGSizeMake(0, 0);
    }
    
    switch (self.gt_cornerType)
    {
        case GTViewCornerTypeBottomLeft:
        {
            corners = UIRectCornerBottomLeft;
        }
            break;
        case GTViewCornerTypeBottomRight:
        {
            corners = UIRectCornerBottomRight;
        }
            break;
        case GTViewCornerTypeTopLeft:
        {
            corners = UIRectCornerTopLeft;
        }
            break;
        case GTViewCornerTypeTopRight:
        {
            corners = UIRectCornerTopRight;
        }
            break;
        case GTViewCornerTypeBottomLeftAndBottomRight:
        {
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        }
            break;
        case GTViewCornerTypeTopLeftAndTopRight:
        {
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
        }
            break;
        case GTViewCornerTypeBottomLeftAndTopLeft:
        {
            corners = UIRectCornerBottomLeft | UIRectCornerTopLeft;
        }
            break;
        case GTViewCornerTypeBottomRightAndTopRight:
        {
            corners = UIRectCornerBottomRight | UIRectCornerTopRight;
        }
            break;
        case GTViewCornerTypeBottomRightAndTopRightAndTopLeft:
        {
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerTopLeft;
        }
            break;
        case GTViewCornerTypeBottomRightAndTopRightAndBottomLeft:
        {
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerBottomLeft;
        }
            break;
        case GTViewCornerTypeAllCorners:
        {
            corners = UIRectCornerAllCorners;
        }
            break;
            
        default:
            break;
    }
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                     byRoundingCorners:corners
                                                           cornerRadii:cornerRadii];
    
    self.gt_shapeLayer = [CAShapeLayer layer];
    self.gt_shapeLayer.path = bezierPath.CGPath;
    self.gt_shapeLayer.frame = self.bounds;
    self.layer.mask = self.gt_shapeLayer;
}

- (void)setupBorderType
{
    if ((!self.gt_borderLayer && self.gt_borderPosition == GTViewBorderPositionNone) || (!self.gt_borderLayer && self.gt_borderWidth == 0)) {
        return;
    }

    if (self.gt_borderLayer && self.gt_borderPosition == GTViewBorderPositionNone && !self.gt_borderLayer.path) {
        return;
    }


    if (self.gt_borderLayer && self.gt_borderWidth == 0 && self.gt_borderLayer.lineWidth == 0) {
        return;
    }

    if (!self.gt_borderLayer) {
        self.gt_borderLayer = [CAShapeLayer layer];
        [self.gt_borderLayer gt_removeDefaultAnimations];
        [self.layer addSublayer:self.gt_borderLayer];
    }
    self.gt_borderLayer.frame = self.bounds;


    CGFloat borderWidth = self.gt_borderWidth;
    self.gt_borderLayer.lineWidth = borderWidth;
    self.gt_borderLayer.fillColor = [UIColor clearColor].CGColor;
    self.gt_borderLayer.strokeColor = self.gt_borderColor.CGColor;
    self.gt_borderLayer.lineDashPhase = self.gt_dashPhase;
    if (self.gt_dashPattern) {
        self.gt_borderLayer.lineDashPattern = self.gt_dashPattern;
    }

    if (self.gt_borderPosition == GTViewBorderPositionAll) {
        self.gt_borderLayer.path = self.gt_shapeLayer.path;
        return;
    }

    UIBezierPath *path = nil;
    if (self.gt_borderPosition != GTViewBorderPositionNone ) {
        path = [UIBezierPath bezierPath];
    }

    if ((self.gt_borderPosition & GTViewBorderPositionTop) == GTViewBorderPositionTop) {
        [path moveToPoint:CGPointMake(0, borderWidth / 2)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), borderWidth / 2)];
    }

    if ((self.gt_borderPosition & GTViewBorderPositionLeft) == GTViewBorderPositionLeft) {
        [path moveToPoint:CGPointMake(borderWidth / 2, 0)];
        [path addLineToPoint:CGPointMake(borderWidth / 2, CGRectGetHeight(self.bounds) - 0)];
    }

    if ((self.gt_borderPosition & GTViewBorderPositionBottom) == GTViewBorderPositionBottom) {
        [path moveToPoint:CGPointMake(0, CGRectGetHeight(self.bounds) - borderWidth / 2)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - borderWidth / 2)];
    }

    if ((self.gt_borderPosition & GTViewBorderPositionRight) == GTViewBorderPositionRight) {
        [path moveToPoint:CGPointMake(CGRectGetWidth(self.bounds) - borderWidth / 2, 0)];
        [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) - borderWidth / 2, CGRectGetHeight(self.bounds))];
    }

    self.gt_borderLayer.path = path.CGPath;
}


#pragma mark - layer

- (void)gt_setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {

    CALayer *layer = nil;
    if (self.gt_shapeLayer) {
        layer = self.gt_shapeLayer;
    } else {
        layer = self.layer;
    }

    layer.shadowColor = color.CGColor;
    layer.shadowOffset = offset;
    layer.shadowRadius = radius;
    layer.shadowOpacity = 10;
    layer.shouldRasterize = YES;
    layer.rasterizationScale = [UIScreen mainScreen].scale;
}


@end
