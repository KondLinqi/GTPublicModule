//
//  UIButton+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/3.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+GTStyle.h"

NS_ASSUME_NONNULL_BEGIN

/**
 button 的样式，以图片为基准

 - GTButtonLayoutTypeNormal: button 默认样式：内容居中-图左文右
 - GTButtonLayoutTypeCenterImageRight: 内容居中-图右文左
 - GTButtonLayoutTypeCenterImageTop: 内容居中-图上文下
 - GTButtonLayoutTypeCenterImageBottom: 内容居中-图下文上
 - GTButtonLayoutTypeLeftImageLeft: 内容居左-图左文右
 - GTButtonLayoutTypeLeftImageRight: 内容居左-图右文左
 - GTButtonLayoutTypeRightImageLeft: 内容居右-图左文右
 - GTButtonLayoutTypeRightImageRight: 内容居右-图右文左
 */
typedef NS_ENUM(NSInteger, GTButtonLayoutType) {
    GTButtonLayoutTypeNormal = 0,
    GTButtonLayoutTypeCenterImageRight,
    GTButtonLayoutTypeCenterImageTop,
    GTButtonLayoutTypeCenterImageBottom,
    GTButtonLayoutTypeLeftImageLeft,
    GTButtonLayoutTypeLeftImageRight,
    GTButtonLayoutTypeRightImageLeft,
    GTButtonLayoutTypeRightImageRight,
};

/**
 UIButton：点击事件 block 返回

 @param button 当前的 button
 */
typedef void (^GTUIButtonActionBlock)(UIButton * _Nonnull button);

@interface UIButton (GTButton)

/**
 button 的布局样式，默认为：BAKit_ButtonLayoutTypeNormal，注意：文字、字体大小、图片等设置一定要在设置 gt_button_setBAKit_ButtonLayoutType 之前设置，要不然计算会以默认字体大小计算，导致位置偏移
 */
@property(nonatomic, assign) GTButtonLayoutType gt_buttonLayoutType;

/*!
 *  文字与图片之间的间距，默认为：0
 */
@property (nonatomic, assign) CGFloat gt_padding;

/*!
 *  文字或图片距离 button 左右边界的最小距离，默认为：5
 */
@property (nonatomic, assign) CGFloat gt_padding_inset;

/**
 UIButton：点击事件 block 返回
 */
@property(nonatomic, copy) GTUIButtonActionBlock gt_buttonActionBlock;

#pragma mark - 快速创建 button

/**
 UIButton：快速创建 button1：frame、title、titleColor、titleFont

 @param frame frame
 @param title title
 @param titleColor titleColor
 @param titleFont titleFont
 @return button
 */
+ (id)gt_buttonWithFrame:(CGRect)frame
                   title:(NSString * __nullable)title
              titleColor:(UIColor * __nullable)titleColor
               titleFont:(UIFont * __nullable)titleFont;

/**
 UIButton：快速创建 button2：frame、title、backgroundColor

 @param frame frame
 @param title title
 @param backgroundColor backgroundColor
 @return button
 */
+ (id)gt_buttonWithFrame:(CGRect)frame
                   title:(NSString * __nullable)title
         backgroundColor:(UIColor * __nullable)backgroundColor;

/**
 UIButton：快速创建 button3：frame、title、titleColor、titleFont、backgroundColor

 @param frame frame
 @param title title
 @param titleColor titleColor
 @param titleFont titleFont
 @param backgroundColor backgroundColor
 @return button
 */
+ (id)gt_buttonWithFrame:(CGRect)frame
                   title:(NSString * __nullable)title
              titleColor:(UIColor * __nullable)titleColor
               titleFont:(UIFont * __nullable)titleFont
         backgroundColor:(UIColor * __nullable)backgroundColor;

/**
 UIButton：快速创建 button4：frame、title、backgroundImage

 @param frame frame
 @param title title
 @param backgroundImage backgroundImage
 @return button
 */
+ (id)gt_buttonWithFrame:(CGRect)frame
                   title:(NSString * __nullable)title
         backgroundImage:(UIImage * __nullable)backgroundImage;

/**
 UIButton：快速创建 button5：frame、title、titleColor、titleFont、image、backgroundColor

 @param frame frame description
 @param title title description
 @param titleColor titleColor description
 @param titleFont titleFont description
 @param image image description
 @param backgroundColor backgroundColor description
 @return button
 */
+ (instancetype)gt_buttonWithFrame:(CGRect)frame
                             title:(NSString * __nullable)title
                        titleColor:(UIColor * __nullable)titleColor
                         titleFont:(UIFont * __nullable)titleFont
                             image:(UIImage * __nullable)image
                   backgroundColor:(UIColor * __nullable)backgroundColor;

/**
 UIButton：快速创建 button6：frame、title、titleColor、titleFont、image、backgroundImage

 @param frame frame description
 @param title title description
 @param titleColor titleColor description
 @param titleFont titleFont description
 @param image image description
 @param backgroundImage backgroundImage description
 @return button
 */
+ (instancetype)gt_buttonWithFrame:(CGRect)frame
                             title:(NSString * __nullable)title
                        titleColor:(UIColor * __nullable)titleColor
                         titleFont:(UIFont * __nullable)titleFont
                             image:(UIImage * __nullable)image
                   backgroundImage:(UIImage * __nullable)backgroundImage;

/**
 UIButton：快速创建 button7：大汇总-点击事件、圆角

 @param frame frame
 @param title title
 @param selTitle selTitle
 @param titleColor titleColor，默认：黑色
 @param titleFont titleFont默认：15
 @param image image description
 @param selImage selImage
 @param padding padding 文字图片间距
 @param buttonLayoutType buttonLayoutType 文字图片布局样式
 @param viewRectCornerType viewRectCornerType 圆角样式
 @param viewCornerRadius viewCornerRadius 圆角角度
 @param target target
 @param sel sel
 @return button
 */
+ (instancetype __nonnull)gt_creatButtonWithFrame:(CGRect)frame
                                            title:(NSString * __nullable)title
                                         selTitle:(NSString * __nullable)selTitle
                                       titleColor:(UIColor * __nullable)titleColor
                                        titleFont:(UIFont * __nullable)titleFont
                                            image:(UIImage * __nullable)image
                                         selImage:(UIImage * __nullable)selImage
                                          padding:(CGFloat)padding
                              buttonPositionStyle:(GTButtonLayoutType)buttonLayoutType
                               viewRectCornerType:(GTViewCornerType)viewRectCornerType
                                 viewCornerRadius:(CGFloat)viewCornerRadius
                                           target:(id __nullable)target
                                         selector:(SEL __nullable)sel;

/**
 UIButton：快速创建 button8：大汇总-所有 normal、selected、highlighted 样式都有

 @param frame frame
 @param title title description
 @param selectedTitle selectedTitle description
 @param highlightedTitle highlightedTitle description
 @param titleColor titleColor description
 @param selectedTitleColor selectedTitleColor description
 @param highlightedTitleColor highlightedTitleColor description
 @param titleFont titleFont description
 @param image image description
 @param selectedImage selectedImage description
 @param highlightedImage highlightedImage description
 @param backgroundImage backgroundImage description
 @param selectedBackgroundImage selectedBackgroundImage description
 @param highlightedBackgroundImage highlightedBackgroundImage description
 @param backgroundColor backgroundColor description
 @return button
 */
+ (instancetype)gt_buttonWithFrame:(CGRect)frame
                             title:(NSString * __nullable)title
                     selectedTitle:(NSString * __nullable)selectedTitle
                  highlightedTitle:(NSString * __nullable)highlightedTitle
                        titleColor:(UIColor * __nullable)titleColor
                selectedTitleColor:(UIColor * __nullable)selectedTitleColor
             highlightedTitleColor:(UIColor * __nullable)highlightedTitleColor
                         titleFont:(UIFont * __nullable)titleFont
                             image:(UIImage * __nullable)image
                     selectedImage:(UIImage * __nullable)selectedImage
                  highlightedImage:(UIImage * __nullable)highlightedImage
                   backgroundImage:(UIImage * __nullable)backgroundImage
           selectedBackgroundImage:(UIImage * __nullable)selectedBackgroundImage
        highlightedBackgroundImage:(UIImage * __nullable)highlightedBackgroundImage
                   backgroundColor:(UIColor * __nullable)backgroundColor;

/**
 UIButton：快速创建一个纯文字 button

 @param frame frame description
 @param title title description
 @param font font description
 @param horizontalAlignment horizontalAlignment description
 @param verticalAlignment verticalAlignment description
 @param contentEdgeInsets contentEdgeInsets description
 @param target target description
 @param action action description
 @param normalStateColor normalStateColor description
 @param highlightedStateColor highlightedStateColor description
 @param disabledStateColor disabledStateColor description
 @return UIButton
 */
+ (UIButton *)gt_buttonLabelButtonWithFrame:(CGRect)frame
                                      title:(NSString *)title
                                       font:(UIFont *)font
                        horizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment
                          verticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment
                          contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
                                     target:(id)target
                                     action:(SEL)action
                           normalTitleColor:(UIColor *)normalStateColor
                      highlightedTitleColor:(UIColor *)highlightedStateColor
                         disabledTitleColor:(UIColor *)disabledStateColor;

/**
 UIButton：快速创建一个纯图片 button

 @param frame frame description
 @param horizontalAlignment horizontalAlignment description
 @param verticalAlignment verticalAlignment description
 @param contentEdgeInsets contentEdgeInsets description
 @param normalImage normalImage description
 @param highlightImage highlightImage description
 @param disabledImage disabledImage description
 @param target target description
 @param action action description
 @return UIButton
 */
+ (UIButton *)gt_buttonImageButtonWithFrame:(CGRect)frame
                        horizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment
                          verticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment
                          contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
                                normalImage:(UIImage *)normalImage
                             highlightImage:(UIImage *)highlightImage
                              disabledImage:(UIImage *)disabledImage
                                     target:(id)target
                                     action:(SEL)action;

#pragma mark - 自定义：button 颜色
/**
 UIButton：自定义 button backgroundColor

 @param backgroundColor backgroundColor
 */
- (void)gt_buttonSetBackgroundColor:(UIColor * __nullable)backgroundColor;

/**
 UIButton：backgroundColor、normalStateColor、highlightedStateColor、disabledStateColor

 @param normalStateColor normalStateColor description
 @param highlightedStateColor highlightedStateColor description
 @param disabledStateColor disabledStateColor description
 */
- (void)gt_buttonBackgroundColorWithNormalStateColor:(UIColor *)normalStateColor
                               highlightedStateColor:(UIColor *)highlightedStateColor
                                  disabledStateColor:(UIColor *)disabledStateColor;

#pragma mark - 自定义 button backgroundImage
/**
 UIButton：自定义 button backgroundImage、selectedBackgroundImage、highlightedBackgroundImage

 @param backgroundImage backgroundImage
 @param selectedBackgroundImage selectedBackgroundImage
 @param highlightedBackgroundImage highlightedBackgroundImage
 */
- (void)gt_buttonSetBackgroundImage:(UIImage * __nullable)backgroundImage
            selectedBackgroundImage:(UIImage * __nullable)selectedBackgroundImage
         highlightedBackgroundImage:(UIImage * __nullable)highlightedBackgroundImage;

#pragma mark - 自定义 button image
/**
 UIButton：自定义 button image、selectedImage、highlightedImage、disabledImage

 @param image image
 @param selectedImage selectedImage
 @param highlightedImage highlightedImage
 @param disabledImage disabledImage
 */
- (void)gt_buttonSetImage:(UIImage * __nullable)image
            selectedImage:(UIImage * __nullable)selectedImage
         highlightedImage:(UIImage * __nullable)highlightedImage
            disabledImage:(UIImage * __nullable)disabledImage;

#pragma mark - 自定义 button title
/**
 UIButton：自定义 button title、selectedTitle、highlightedTitle

 @param title title
 @param selectedTitle selectedTitle
 @param highlightedTitle highlightedTitle
 */
- (void)gt_buttonSetTitle:(NSString * __nullable)title
            selectedTitle:(NSString * __nullable)selectedTitle
         highlightedTitle:(NSString * __nullable)highlightedTitle;

/**
 UIButton：自定义 button titleColor、selectedTitleColor、highlightedTitleColor、disabledTitleColor

 @param titleColor titleColor
 @param selectedTitleColor selectedTitleColor
 @param highlightedTitleColor highlightedTitleColor
 @param disabledTitleColor disabledTitleColor
 */
- (void)gt_buttonSetTitleColor:(UIColor * __nullable)titleColor
            selectedTitleColor:(UIColor * __nullable)selectedTitleColor
         highlightedTitleColor:(UIColor * __nullable)highlightedTitleColor
            disabledTitleColor:(UIColor * __nullable)disabledTitleColor;

/**
 UIButton：自定义 button 字体、大小

 @param fontName fontName
 @param size size
 */
- (void)gt_buttonSetTitleFontName:(NSString *)fontName
                             size:(CGFloat)size;

#pragma mark - 点击事件
/**
 UIButton：自定义 button 点击事件，默认：UIControlEventTouchUpInside

 @param target target
 @param tag tag
 @param action action
 */
- (void)gt_buttonAddTarget:(nullable id)target
                       tag:(NSInteger)tag
                    action:(SEL)action;

#pragma mark - 布局样式 和 间距
/**
 UIButton：快速设置 button 的布局样式 和 间距

 @param type button 的布局样式
 @param padding 文字与图片之间的间距
 */
- (void)gt_button_setButtonLayoutType:(GTButtonLayoutType)type padding:(CGFloat)padding;

#pragma mark - 快速切圆角
/**
 UIButton：快速切圆角，注意：文字、字体大小、图片等设置一定要在设置 gt_button_setButtonLayoutType 之前设置，要不然计算会以默认字体大小计算，导致位置偏移，如果是 xib，需要要有固定 宽高，要不然 iOS 10 设置无效

 @param type 圆角样式
 @param viewCornerRadius 圆角角度
 */
- (void)gt_button_setViewRectCornerType:(GTViewCornerType)type viewCornerRadius:(CGFloat)viewCornerRadius;

/**
 UIButton：快速切圆角，带边框、边框颜色，如果是 xib，需要要有固定 宽高，要不然 iOS 10 设置无效

 @param type 圆角样式
 @param viewCornerRadius 圆角角度
 @param borderWidth 边线宽度
 @param borderColor 边线颜色
 */
- (void)gt_button_setViewRectCornerType:(GTViewCornerType)type
                       viewCornerRadius:(CGFloat)viewCornerRadius
                            borderWidth:(CGFloat)borderWidth
                            borderColor:(UIColor *)borderColor;

#pragma mark - title 位置
/**
 UIButton：title 位置

 @param horizontalAlignment horizontalAlignment description
 @param verticalAlignment verticalAlignment description
 @param contentEdgeInsets contentEdgeInsets description
 */
- (void)gt_buttonTitleLabelHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment
                             verticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment
                             contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets;

#pragma mark - 给 View 添加点击音效
/**
 UIButton：给 button 添加点击音效（一般用于 button 按钮的点击音效），注意，此方法不带播放结束回调，如果需要播放结束回调，请将 .m 文件中的 C 函数（soundCompleteCallBack）回调复制到播放按钮的.m 里，在里面做相关处理即可

 @param filename 音乐文件名称
 @param isNeedShock 是否播放音效并震动
 */
- (void)gt_buttonPlaySoundEffectWithFileName:(NSString *)filename
                                 isNeedShock:(BOOL)isNeedShock;


@end

@interface UIImage (GTButton)

/**
 UIImage：创建一个 纯颜色 图片【全部铺满】

 @param color color
 @return 纯颜色 图片
 */
+ (UIImage *)gt_image_Color:(UIColor *)color;

/**
 UIImage：创建一个 纯颜色 图片【可以设置 size】

 @param color color
 @param size size
 @return 纯颜色 图片
 */
+ (UIImage *)gt_image_Color:(UIColor *)color size:(CGSize)size;

/**
 UIImage：根据宽比例去缩放图片

 @param width width description
 @return UIImage
 */
- (UIImage *)gt_imageScaleToWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
