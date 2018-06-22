//
//  UIView+GTStyle.h
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 设置View 圆角、边框、阴影等
 */

/*!
 *  设置 GTViewCornerType 样式，
 *  注意：GTViewCornerType 必须要先设置 viewCornerRadius，才能有效，否则设置无效，
 */
typedef NS_ENUM(NSInteger, GTViewCornerType) {
    /*!
     *  设置下左角 圆角半径
     */
    GTViewCornerTypeBottomLeft = 0,
    /*!
     *  设置下右角 圆角半径
     */
    GTViewCornerTypeBottomRight,
    /*!
     *  设置上左角 圆角半径
     */
    GTViewCornerTypeTopLeft,
    /*!
     *  设置下右角 圆角半径
     */
    GTViewCornerTypeTopRight,
    /*!
     *  设置下左、下右角 圆角半径
     */
    GTViewCornerTypeBottomLeftAndBottomRight,
    /*!
     *  设置上左、上右角 圆角半径
     */
    GTViewCornerTypeTopLeftAndTopRight,
    /*!
     *  设置下左、上左角 圆角半径
     */
    GTViewCornerTypeBottomLeftAndTopLeft,
    /*!
     *  设置下右、上右角 圆角半径
     */
    GTViewCornerTypeBottomRightAndTopRight,
    /*!
     *  设置上左、上右、下右角 圆角半径
     */
    GTViewCornerTypeBottomRightAndTopRightAndTopLeft,
    /*!
     *  设置下右、上右、下左角 圆角半径
     */
    GTViewCornerTypeBottomRightAndTopRightAndBottomLeft,
    /*!
     *  设置全部四个角 圆角半径
     */
    GTViewCornerTypeAllCorners
};

/*!
 *  设置 GTViewBorderPosition 样式，
 *  注意：GTViewBorderPosition 必须要先设置 viewCornerRadius，才能有效，否则设置无效，
 */
typedef NS_ENUM(NSInteger, GTViewBorderPosition) {
    GTViewBorderPositionNone    = 0,
    GTViewBorderPositionTop     = 1 << 0,
    GTViewBorderPositionLeft    = 1 << 1,
    GTViewBorderPositionBottom  = 1 << 2,
    GTViewBorderPositionRight   = 1 << 3,
    GTViewBorderPositionAll     = 1 << 4
};

@interface UIView (GTStyle)

/**
 设置 viewRectCornerType 样式，注意：GTViewRectCornerType 必须要先设置 viewCornerRadius，才能有效，否则设置无效，如果是 xib，需要要有固定 宽高，要不然 iOS 10 设置无效
 */
@property (nonatomic, assign) GTViewCornerType gt_cornerType;

/**
 设置 view ：圆角，如果要全部设置四个角的圆角，可以直接用这个方法，必须要在设置 frame 之后，注意：如果是 xib，需要要有固定 宽高，要不然 iOS 10 设置无效
 */
@property (nonatomic, assign) IBInspectable CGFloat gt_cornerRadius;



/**
 边框的大小，默认为PixelOne
 */
@property(nonatomic, assign) IBInspectable CGFloat gt_borderWidth;

/**
 边框的颜色，默认为UIColorSeparator
 */
@property(nonatomic, strong) IBInspectable UIColor * _Nullable gt_borderColor;

/**
 设置边框类型，支持组合，例如：`gt_borderPosition = GTViewBorderPositionTop|GTViewBorderPositionBottom`
 */
@property(nonatomic, assign) GTViewBorderPosition gt_borderPosition;

/// 虚线 : dashPhase默认是0，且当dashPattern设置了才有效
/// gt_dashPattern 表示虚线起始的偏移，gt_dashPattern 可以传一个数组，表示“lineWidth，lineSpacing，lineWidth，lineSpacing...”的顺序，至少传 2 个。
@property(nonatomic, assign) CGFloat gt_dashPhase;
@property(nonatomic, copy)   NSArray <NSNumber *> * _Nullable gt_dashPattern;

/// border的layer
@property(nonatomic, strong, readonly) CAShapeLayer * _Nullable gt_borderLayer;
/// corner的layer
@property(nonatomic, strong, readonly) CAShapeLayer * _Nullable gt_shapeLayer;

#pragma mark - layer

/**
 Shortcut to set the view.layer's shadow
 
 @param color  Shadow Color
 @param offset Shadow offset
 @param radius Shadow radius
 */
- (void)gt_setLayerShadow:(nullable UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;

@end
