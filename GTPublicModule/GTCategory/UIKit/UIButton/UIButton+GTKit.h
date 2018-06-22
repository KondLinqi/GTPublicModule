//
//  UIButton+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GTImagePosition) {
    GTImagePositionLeft = 0,              //图片在左，文字在右，默认
    GTImagePositionRight = 1,             //图片在右，文字在左
    GTImagePositionTop = 2,               //图片在上，文字在下
    GTImagePositionBottom = 3,            //图片在下，文字在上
};

typedef void (^GTTouchedButtonBlock)(NSInteger tag);

@interface UIButton (GTKit)

/**
 *  @brief  设置按钮额外热区
 */
@property (nonatomic, assign) UIEdgeInsets gt_touchAreaInsets;

/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)gt_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)gt_setImagePosition:(GTImagePosition)postion spacing:(CGFloat)spacing;

/**
 This method will show the activity indicator in place of the button text.
 */
- (void)gt_showIndicator;

/**
 This method will remove the indicator and put thebutton text back in place.
 */
- (void)gt_hideIndicator;
/*
 add Action Block
 */
-(void)gt_addActionHandler:(GTTouchedButtonBlock)touchHandler;

@end

NS_ASSUME_NONNULL_END
