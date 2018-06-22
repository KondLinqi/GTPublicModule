//
//  UIImageView+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/20.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (GTKit)

#pragma mark - Create imageView
///=============================================================================
/// @name Create imageView
///=============================================================================

/**
 *  @brief  根据bundle中的图片名创建imageview
 *
 *  @param imageName bundle中的图片名
 *
 *  @return imageview
 */
+ (id)gt_imageViewWithImageNamed:(NSString*)imageName;
/**
 *  @brief  根据frame创建imageview
 *
 *  @param frame imageview frame
 *
 *  @return imageview
 */
+ (id)gt_imageViewWithFrame:(CGRect)frame;

+ (id)gt_imageViewWithStretchableImage:(NSString*)imageName Frame:(CGRect)frame;
/**
 *  @brief  创建imageview动画
 *
 *  @param imageArray 图片名称数组
 *  @param duration   动画时间
 *
 *  @return imageview
 */
+ (id)gt_imageViewWithImageArray:(NSArray*)imageArray duration:(NSTimeInterval)duration;

/**
 *  @brief  设置图片可伸缩
 */
- (void)gt_setImageWithStretchableImage:(NSString*)imageName;


#pragma mark - 画水印
///=============================================================================
/// @name 画水印
///=============================================================================

// 画水印
// 图片水印
- (void)gt_setImage:(UIImage *)image withWaterMark:(UIImage *)mark inRect:(CGRect)rect;
// 文字水印
- (void)gt_setImage:(UIImage *)image withStringWaterMark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font;
- (void)gt_setImage:(UIImage *)image withStringWaterMark:(NSString *)markString atPoint:(CGPoint)point color:(UIColor *)color font:(UIFont *)font;

#pragma mark - GeometryConversion 几何转换
///=============================================================================
/// @name GeometryConversion 几何转换
///=============================================================================

- (CGPoint)gt_convertPointFromImage:(CGPoint)imagePoint;
- (CGRect)gt_convertRectFromImage:(CGRect)imageRect;

- (CGPoint)gt_convertPointFromView:(CGPoint)viewPoint;
- (CGRect)gt_convertRectFromView:(CGRect)viewRect;


#pragma mark - Letter 文字图片
///=============================================================================
/// @name Letter 文字图片
///=============================================================================

/**
 Sets the image property of the view based on initial text. A random background color is automatically generated.
 
 @param string The string used to generate the initials. This should be a user's full name if available
 */
- (void)gt_setImageWithString:(NSString *)string;

/**
 Sets the image property of the view based on initial text and a specified background color.
 
 @param string The string used to generate the initials. This should be a user's full name if available
 @param color (optional) This optional paramter sets the background of the image. If not provided, a random color will be generated
 */

- (void)gt_setImageWithString:(NSString *)string color:(UIColor *)color;

/**
 Sets the image property of the view based on initial text, a specified background color, and a circular clipping
 
 @param string The string used to generate the initials. This should be a user's full name if available
 @param color (optional) This optional paramter sets the background of the image. If not provided, a random color will be generated
 @param isCircular This boolean will determine if the image view will be clipped to a circular shape
 */
- (void)gt_setImageWithString:(NSString *)string color:(UIColor *)color circular:(BOOL)isCircular;

/**
 Sets the image property of the view based on initial text, a specified background color, a custom font, and a circular clipping
 
 @param string The string used to generate the initials. This should be a user's full name if available
 @param color (optional) This optional paramter sets the background of the image. If not provided, a random color will be generated
 @param isCircular This boolean will determine if the image view will be clipped to a circular shape
 @param fontName This will use a custom font attribute. If not provided, it will default to system font
 */
- (void)gt_setImageWithString:(NSString *)string color:(UIColor *)color circular:(BOOL)isCircular fontName:(NSString *)fontName;

/**
 Sets the image property of the view based on initial text, a specified background color, custom text attributes, and a circular clipping
 
 @param string The string used to generate the initials. This should be a user's full name if available
 @param color (optional) This optional paramter sets the background of the image. If not provided, a random color will be generated
 @param isCircular This boolean will determine if the image view will be clipped to a circular shape
 @param textAttributes This dictionary allows you to specify font, text color, shadow properties, etc., for the letters text, using the keys found in NSAttributedString.h
 */
- (void)gt_setImageWithString:(NSString *)string color:(UIColor *)color circular:(BOOL)isCircular textAttributes:(NSDictionary *)textAttributes;


#pragma mark - 倒影
///=============================================================================
/// @name 倒影
///=============================================================================

/**
 *  @brief  倒影
 */
- (void)gt_reflect;

@end
