//
//  UITabBarController+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/17.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (GTKit)

/**
 tabBar：默认选中颜色
 */
@property(nonatomic, strong) UIColor *gt_tabBar_tintColor;

/**
 tabBar：默认背景颜色
 */
@property(nonatomic, strong) UIColor *gt_tabBar_backgroundColor;

/**
 tabBar：默认背景图片
 */
@property(nonatomic, strong) UIImage *gt_tabBar_backgroundImage;


/*!
 获取tabbar当前显示的控制器
 */
- (UIViewController*)gt_topViewController;

@end
