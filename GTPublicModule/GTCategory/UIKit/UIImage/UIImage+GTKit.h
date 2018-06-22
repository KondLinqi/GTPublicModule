//
//  UIImage+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/20.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GTKit)

#pragma mark - Create image
///=============================================================================
/// @name Create image
///=============================================================================

/**
图片赋值
支持png、jpeg、jpg、gif、webp、apng等格式

@param name 图片名称 如果是.png可以省略 如果是其他格式必须带带上格式
@return U
*/
+ (UIImage *_Nullable)gt_imageNamed:(NSString *_Nullable)name;



#pragma mark - color
///=============================================================================
/// @name color
///=============================================================================

/**
*  @brief  根据颜色生成纯色图片
*
*  @param color 颜色
*
*  @return 纯色图片
*/
+ (UIImage *_Nullable)gt_imageWithColor:(UIColor *_Nullable)color;

/**
 *  @brief  取图片某一点的颜色
 *
 *  @param point 某一点
 *
 *  @return 颜色
 */
- (UIColor *_Nullable)gt_colorAtPoint:(CGPoint )point;
//more accurate method ,colorAtPixel 1x1 pixel
/**
 *  @brief  取某一像素的颜色
 *
 *  @param point 一像素
 *
 *  @return 颜色
 */
- (UIColor *_Nullable)gt_colorAtPixel:(CGPoint)point;
/**
 *  @brief  返回该图片是否有透明度通道
 *
 *  @return 是否有透明度通道
 */
- (BOOL)gt_hasAlphaChannel;

/**
 *  @brief  获得灰度图
 *
 *  @param sourceImage 图片
 *
 *  @return 获得灰度图片
 */
+ (UIImage*_Nullable)gt_covertToGrayImageFromImage:(UIImage*_Nullable)sourceImage;



#pragma mark Alpha
///=============================================================================
/// @name Alpha
///=============================================================================

/**
 *  @brief  是否有alpha通道
 *
 *  @return 是否有alpha通道
 */
- (BOOL)gt_hasAlpha;
/**
 *  @brief  如果没有alpha通道 增加alpha通道
 *
 *  @return 如果没有alpha通道 增加alpha通道
 */
- (UIImage *_Nullable)gt_imageWithAlpha;
/**
 *  @brief  增加透明边框
 *
 *  @param borderSize 边框尺寸
 *
 *  @return 增加透明边框后的图片
 */
- (UIImage *_Nullable)gt_transparentBorderImage:(NSUInteger)borderSize;


//http://stackoverflow.com/questions/6521987/crop-uiimage-to-alpha?answertab=oldest#tab-top
/**
 *  @brief  裁切含透明图片为最小大小
 *
 *  @return 裁切后的图片
 */
- (UIImage *_Nullable)gt_trimmedBetterSize;

#pragma mark FileName
///=============================================================================
/// @name FileName
///=============================================================================

/**
 *  @brief  根据main bundle中的文件名读取图片
 *
 *  @param name 图片名
 *
 *  @return 无缓存的图片
 */
+ (UIImage *_Nullable)gt_imageWithFileName:(NSString *_Nullable)name;
/**
 *  @author JKCategories
 *
 *  根据指定bundle中的文件名读取图片
 *
 *  @param name   图片名
 *  @param bundle bundle
 *
 *  @return 无缓存的图片
 */
+ (UIImage *_Nullable)gt_imageWithFileName:(NSString *_Nullable)name inBundle:(NSBundle*_Nullable)bundle;



#pragma mark SuperCompress
///=============================================================================
/// @name SuperCompress
///=============================================================================

+ (UIImage*_Nullable)gt_resizableHalfImage:(NSString *_Nullable)name;

/**
 *  压缩上传图片到指定字节
 *
 *  @param image     压缩的图片
 *  @param maxLength 压缩后最大字节大小
 *
 *  @return 压缩后图片的二进制
 */
+ (NSData *_Nullable)gt_compressImage:(UIImage * _Nullable)image toMaxLength:(NSInteger) maxLength maxWidth:(NSInteger)maxWidth;

/**
 *  获得指定size的图片
 *
 *  @param image   原始图片
 *  @param newSize 指定的size
 *
 *  @return 调整后的图片
 */
+ (UIImage *_Nullable)gt_resizeImage:(UIImage * _Nullable) image withNewSize:(CGSize) newSize;

/**
 *  通过指定图片最长边，获得等比例的图片size
 *
 *  @param image       原始图片
 *  @param imageLength 图片允许的最长宽度（高度）
 *
 *  @return 获得等比例的size
 */
+ (CGSize)gt_scaleImage:(UIImage *_Nullable) image withLength:(CGFloat) imageLength;

#pragma mark Merge合并
///=============================================================================
/// @name Merge合并
///=============================================================================

/**
 *  @brief  合并两个图片
 *
 *  @param firstImage  一个图片
 *  @param secondImage 二个图片
 *
 *  @return 合并后图片
 */
+ (UIImage*_Nullable)gt_mergeImage:(UIImage*_Nullable)firstImage withImage:(UIImage*_Nullable)secondImage;


#pragma mark capture截图
///=============================================================================
/// @name capture截图
///=============================================================================

/**
 *  @brief  截图指定view成图片
 *
 *  @param view 一个view
 *
 *  @return 图片
 */
+ (UIImage *_Nullable)gt_captureWithView:(UIView *_Nullable)view;

+ (UIImage *_Nullable)gt_getImageWithSize:(CGRect)myImageRect FromImage:(UIImage *_Nullable)bigImage;

/**
 *  @author Jakey
 *
 *  @brief  截图一个view中所有视图 包括旋转缩放效果
 *
 *  aView    指定的view
 *  maxWidth 宽的大小 0为view默认大小
 *
 *  @return 截图
 */
+ (UIImage *_Nullable)gt_screenshotWithView:(UIView *_Nullable)aView limitWidth:(CGFloat)maxWidth;


#pragma mark fix Image
///=============================================================================
/// @name  fix Image
///=============================================================================

- (UIImage *_Nullable)gt_imageCroppedToRect:(CGRect)rect;
- (UIImage *_Nullable)gt_imageScaledToSize:(CGSize)size;
- (UIImage *_Nullable)gt_imageScaledToFitSize:(CGSize)size;
- (UIImage *_Nullable)gt_imageScaledToFillSize:(CGSize)size;
- (UIImage *_Nullable)gt_imageCroppedAndScaledToSize:(CGSize)size
                                contentMode:(UIViewContentMode)contentMode
                                   padToFit:(BOOL)padToFit;

- (UIImage *_Nullable)gt_reflectedImageWithScale:(CGFloat)scale;
- (UIImage *_Nullable)gt_imageWithReflectionWithScale:(CGFloat)scale gap:(CGFloat)gap alpha:(CGFloat)alpha;
- (UIImage *_Nullable)gt_imageWithShadowColor:(UIColor *_Nullable)color offset:(CGSize)offset blur:(CGFloat)blur;
- (UIImage *_Nullable)gt_imageWithCornerRadius:(CGFloat)radius;
- (UIImage *_Nullable)gt_imageWithAlpha:(CGFloat)alpha;
- (UIImage *_Nullable)gt_imageWithMask:(UIImage *_Nullable)maskImage;

- (UIImage *_Nullable)gt_maskImageFromImageAlpha;



#pragma mark Orientation
///=============================================================================
/// @name  Orientation
///=============================================================================

/**
 *  @brief  修正图片的方向
 *
 *  @param srcImg 图片
 *
 *  @return 修正方向后的图片
 */
+ (UIImage *_Nullable)gt_fixOrientation:(UIImage *_Nullable)srcImg;
/**
 *  @brief  旋转图片
 *
 *  @param degrees 角度
 *
 *  @return 旋转后图片
 */
- (UIImage *_Nullable)gt_imageRotatedByDegrees:(CGFloat)degrees;

/**
 *  @brief  旋转图片
 *
 *  @param radians 弧度
 *
 *  @return 旋转后图片
 */
- (UIImage *_Nullable)gt_imageRotatedByRadians:(CGFloat)radians;

/**
 *  @brief  垂直翻转
 *
 *  @return  翻转后的图片
 */
- (UIImage *_Nullable)gt_flipVertical;
/**
 *  @brief  水平翻转
 *
 *  @return 翻转后的图片
 */
- (UIImage *_Nullable)gt_flipHorizontal;

/**
 *  @brief  角度转弧度
 *
 *  @param degrees 角度
 *
 *  @return 弧度
 */
+(CGFloat)gt_degreesToRadians:(CGFloat)degrees;
/**
 *  @brief  弧度转角度
 *
 *  @param radians 弧度
 *
 *  @return 角度
 */
+(CGFloat)gt_radiansToDegrees:(CGFloat)radians;



#pragma mark resize
///=============================================================================
/// @name  resize
///=============================================================================

- (UIImage *_Nullable)gt_croppedImage:(CGRect)bounds;
- (UIImage *_Nullable)gt_thumbnailImage:(NSInteger)thumbnailSize
             transparentBorder:(NSUInteger)borderSize
                  cornerRadius:(NSUInteger)cornerRadius
          interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *_Nullable)gt_resizedImage:(CGSize)newSize
        interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *_Nullable)gt_resizedImageWithContentMode:(UIViewContentMode)contentMode
                                     bounds:(CGSize)bounds
                       interpolationQuality:(CGInterpolationQuality)quality;


#pragma mark cornerRadius
///=============================================================================
/// @name  cornerRadius
///=============================================================================
- (UIImage *_Nullable)gt_roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;


#pragma mark PDF
///=============================================================================
/// @name  PDF
///=============================================================================
/**
 Create a UIImage from an icon font.
 @param font The icon font.
 @param iconNamed The name of the icon in the font.
 @param tintColor The tint color to use for the icon. Defaults to black.
 @param clipToBounds If YES the image will be clipped to the pixel bounds of the icon.
 @param fontSize The font size to draw the icon at.
 @return The resulting image.
 */
+ (UIImage *_Nullable)gt_iconWithFont:(UIFont *_Nullable)font named:(NSString *_Nullable)iconNamed
                        withTintColor:(UIColor *_Nullable)tintColor clipToBounds:(BOOL)clipToBounds forSize:(CGFloat)fontSize;

/**
 Create a UIImage from a PDF icon.
 @param pdfNamed The name of the PDF file in the application's resources directory.
 @param height The height of the resulting image, the width will be based on the aspect ratio of the PDF.
 @return The resulting image.
 */
+ (UIImage *_Nullable)gt_imageWithPDFNamed:(NSString *_Nullable)pdfNamed forHeight:(CGFloat)height;

/**
 Create a UIImage from a PDF icon.
 @param pdfNamed The name of the PDF file in the application's resources directory.
 @param tintColor The tint color to use for the icon. If nil no tint color will be used.
 @param height The height of the resulting image, the width will be based on the aspect ratio of the PDF.
 @return The resulting image.
 */
+ (UIImage *_Nullable)gt_imageWithPDFNamed:(NSString *_Nullable)pdfNamed withTintColor:(UIColor *_Nullable)tintColor forHeight:(CGFloat)height;

/**
 Create a UIImage from a PDF icon.
 @param pdfFile The path of the PDF file.
 @param tintColor The tint color to use for the icon. If nil no tint color will be used.
 @param size The maximum size the resulting image can be. The image will maintain it's aspect ratio and may not encumpas the full size.
 @return The resulting image.
 */
+ (UIImage *_Nullable)gt_imageWithPDFFile:(NSString *_Nullable)pdfFile withTintColor:(UIColor *_Nullable)tintColor forSize:(CGSize)size;


#pragma mark Image Effect
///=============================================================================
/// @name  Image Effect
///=============================================================================

/**
 Tint the image in alpha channel with the given color.
 
 @param color  The color.
 */
- (nullable UIImage *)imageByTintColor:(UIColor *_Nullable)color;

/**
 Returns a grayscaled image.
 */
- (nullable UIImage *)imageByGrayscale;

/**
 Applies a blur effect to this image. Suitable for blur any content.
 */
- (nullable UIImage *)imageByBlurSoft;

/**
 Applies a blur effect to this image. Suitable for blur any content except pure white.
 (same as iOS Control Panel)
 */
- (nullable UIImage *)imageByBlurLight;

/**
 Applies a blur effect to this image. Suitable for displaying black text.
 (same as iOS Navigation Bar White)
 */
- (nullable UIImage *)imageByBlurExtraLight;

/**
 Applies a blur effect to this image. Suitable for displaying white text.
 (same as iOS Notification Center)
 */
- (nullable UIImage *)imageByBlurDark;

/**
 Applies a blur and tint color to this image.
 
 @param tintColor  The tint color.
 */
- (nullable UIImage *)imageByBlurWithTint:(UIColor *_Nullable)tintColor;

/**
 Applies a blur, tint color, and saturation adjustment to this image,
 optionally within the area specified by @a maskImage.
 
 @param blurRadius     The radius of the blur in points, 0 means no blur effect.
 
 @param tintColor      An optional UIColor object that is uniformly blended with
 the result of the blur and saturation operations. The
 alpha channel of this color determines how strong the
 tint is. nil means no tint.
 
 @param tintBlendMode  The @a tintColor blend mode. Default is kCGBlendModeNormal (0).
 
 @param saturation     A value of 1.0 produces no change in the resulting image.
 Values less than 1.0 will desaturation the resulting image
 while values greater than 1.0 will have the opposite effect.
 0 means gray scale.
 
 @param maskImage      If specified, @a inputImage is only modified in the area(s)
 defined by this mask.  This must be an image mask or it
 must meet the requirements of the mask parameter of
 CGContextClipToMask.
 
 @return               image with effect, or nil if an error occurs (e.g. no
 enough memory).
 */
- (nullable UIImage *)imageByBlurRadius:(CGFloat)blurRadius
                              tintColor:(nullable UIColor *)tintColor
                               tintMode:(CGBlendMode)tintBlendMode
                             saturation:(CGFloat)saturation
                              maskImage:(nullable UIImage *)maskImage;


@end
