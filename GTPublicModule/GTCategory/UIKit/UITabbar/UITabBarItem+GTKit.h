//
//  UITabBarItem+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/17.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (GTKit)

/**
 tabBarItem：默认非选中颜色，注意：只需在第一个 VC 后面设置即可，其他 VC 无需设置
 */
@property(nonatomic, strong) UIColor *gt_tabBarItem_titleColor;

/**
 tabBarItem：默认选中颜色，注意：只需在第一个 VC 后面设置即可，其他 VC 无需设置
 */
@property(nonatomic, strong) UIColor *gt_tabBarItem_titleSelectedColor;

/**
 快速创建 UITabBarItem

 @param title title
 @param image image
 @param selectedImage selectedImage
 @param selectedTitleColor selectedTitleColor
 @param tag tag
 @return UITabBarItem
 */
+ (UITabBarItem *)gt_tabBarItemWithTitle:(NSString *)title
                                   image:(UIImage *)image
                           selectedImage:(UIImage *)selectedImage
                      selectedTitleColor:(UIColor *)selectedTitleColor
                                     tag:(NSInteger)tag;

/**
 设置角标值时，替换系统的 'setBadgeValue:'方法

 @param badgeValue badgeValue description
 */
- (void)gt_tabBarItemSetBadgeValue:(NSString *)badgeValue;

@end
