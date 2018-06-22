//
//  UITabBar+GTBadge.h
//  GTKit
//
//  Created by liuxc on 2018/5/17.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 UITabBar：badge 样式

 - GTTabBarBadgeTypeRedDot: 小红点
 - GTTabBarBadgeTypeNew: badge with a fixed text "new"
 - GTTabBarBadgeTypeNumber: badge with number
 */
typedef NS_ENUM(NSUInteger, GTTabBarBadgeType){
    GTTabBarBadgeTypeRedDot = 0,
    GTTabBarBadgeTypeNew,
    GTTabBarBadgeTypeNumber
};

@interface UITabBar (GTBadge)

/**
 UITabBar：设置 TabItem 的宽度，用于调整 badge 的位置

 @param width TabBarItem 的 Width
 */
- (void)gt_tabBarSetTabBarItemWidth:(CGFloat)width;

/**
 UITabBar：设置 badge 的 top

 @param top 顶部距离
 */
- (void)gt_tabBarSetBadgeTop:(CGFloat)top;

/**
 UITabBar：设置 badge样、数字

 @param type UITabBar：badge 样式
 @param badgeValue 数字
 @param index 下标
 */
- (void)gt_tabBarSetBadgeType:(GTTabBarBadgeType)type
                   badgeValue:(NSInteger)badgeValue
                        index:(NSInteger)index;

- (void)gt_tabBarBadgeViewClearWithIndndex:(NSInteger)index;


@end
