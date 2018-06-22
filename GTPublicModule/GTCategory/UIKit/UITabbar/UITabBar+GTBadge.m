//
//  UITabBar+GTBadge.m
//  GTKit
//
//  Created by liuxc on 2018/5/17.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UITabBar+GTBadge.h"
#import <objc/runtime.h>

static NSString * const kTabBarItemWidthKey = @"kTabBarItemWidthKey";
static NSString * const kBadgeViewInitedKey = @"kBadgeViewInited";
static NSString * const kBadgeDotViewsKey = @"kBadgeDotViewsKey";
static NSString * const kBadgeNumberViewsKey = @"kBadgeNumberViewsKey";
static NSString * const kBadgeNewViewsKey = @"kBadgeNewViewsKey";
static NSString * const kBadgeTopKey = @"kBadgeTopKey";

@implementation UITabBar (GTBadge)

/**
 UITabBar：设置 TabItem 的宽度，用于调整 badge 的位置

 @param width TabBarItem 的 Width
 */
- (void)gt_tabBarSetTabBarItemWidth:(CGFloat)width
{
    [self setValue:@(width) forUndefinedKey:kTabBarItemWidthKey];
}

/**
 UITabBar：设置 badge 的 top

 @param top 顶部距离
 */
- (void)gt_tabBarSetBadgeTop:(CGFloat)top
{
    [self setValue:@(top) forUndefinedKey:kBadgeTopKey];
}


/**
 UITabBar：设置 badge样、数字

 @param type UITabBar：badge 样式
 @param badgeValue 数字
 @param index 下标
 */
- (void)gt_tabBarSetBadgeType:(GTTabBarBadgeType)type
                   badgeValue:(NSInteger)badgeValue
                        index:(NSInteger)index
{
    if (![[self valueForKey:kBadgeViewInitedKey] boolValue])
    {
        [self setValue:@(YES) forKey:kBadgeViewInitedKey];
        [self gt_addBadgeView];
    }

    NSMutableArray *badgeDotViewArray = [self valueForKey:kBadgeDotViewsKey];
    NSMutableArray *badgeNumberViewArray = [self valueForKey:kBadgeNumberViewsKey];
    NSMutableArray *badgeNewViewArray = [self valueForKey:kBadgeNewViewsKey];

    [((UIView *)badgeDotViewArray[index]) setHidden:YES];
    [((UIView *)badgeNumberViewArray[index]) setHidden:YES];
    [(UIView *)badgeNewViewArray[index] setHidden:YES];

    if (type == GTTabBarBadgeTypeRedDot)
    {
        [((UIView *)badgeDotViewArray[index]) setHidden:NO];
    }
    else if (type == GTTabBarBadgeTypeNew)
    {
        [(UIView *)badgeNewViewArray[index] setHidden:NO];
        UILabel *label = badgeNewViewArray[index];
        label.text = @"new";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
    }
    else if (type == GTTabBarBadgeTypeNumber)
    {
        [((UIView *)badgeNumberViewArray[index]) setHidden:NO];
        UILabel *label = badgeNumberViewArray[index];

        [self gt_adjustBadgeNumberViewWithLabel:label number:badgeValue];
    }
}

- (void)gt_tabBarBadgeViewClearWithIndndex:(NSInteger)index
{
    NSMutableArray *badgeDotViewArray = [self valueForKey:kBadgeDotViewsKey];
    NSMutableArray *badgeNumberViewArray = [self valueForKey:kBadgeNumberViewsKey];
    NSMutableArray *badgeNewViewArray = [self valueForKey:kBadgeNewViewsKey];

    [((UIView *)badgeDotViewArray[index]) setHidden:YES];
    [((UIView *)badgeNumberViewArray[index]) setHidden:YES];
    [(UIView *)badgeNewViewArray[index] setHidden:YES];
}

- (void)gt_addBadgeView
{
    id idItemWidth = [self valueForKey:kTabBarItemWidthKey];
    id idBadgeTop = [self valueForKey:kBadgeTopKey];

    CGFloat tabbarItemWidth = idItemWidth ? [idItemWidth floatValue] : 32;
    CGFloat badgeTop = idBadgeTop ? [idBadgeTop floatValue] : 11;

    NSInteger itemCount = self.items.count;
    CGFloat itemWidth = self.bounds.size.width / itemCount;

    // dot views
    NSMutableArray *badgeDotViews = [NSMutableArray new];
    for(int i = 0;i < itemCount;i ++)
    {
        UIView *redDot = [UIView new];
        redDot.bounds = CGRectMake(0, 0, 10, 10);
        redDot.center = CGPointMake(itemWidth * (i + 0.5) + tabbarItemWidth / 2, badgeTop);
        redDot.layer.cornerRadius = redDot.bounds.size.width / 2;
        redDot.clipsToBounds = YES;
        redDot.backgroundColor = [UIColor redColor];
        redDot.hidden = YES;
        [self addSubview:redDot];
        [badgeDotViews addObject:redDot];
    }
    [self setValue:badgeDotViews forKey:kBadgeDotViewsKey];

    // number views
    NSMutableArray *badgeNumberViews = [NSMutableArray new];
    for(int i = 0;i < itemCount;i ++){
        UILabel *redNum = [UILabel new];
        redNum.layer.anchorPoint = CGPointMake(0, 0.5);
        redNum.bounds = CGRectMake(0, 0, 20, 14);
        redNum.center = CGPointMake(itemWidth * (i + 0.5) + tabbarItemWidth / 2 - 10, badgeTop);
        redNum.layer.cornerRadius = redNum.bounds.size.height/2;
        redNum.clipsToBounds = YES;
        redNum.backgroundColor = [UIColor redColor];
        redNum.hidden = YES;

        redNum.textAlignment = NSTextAlignmentCenter;
        redNum.font = [UIFont systemFontOfSize:12];
        redNum.textColor = [UIColor whiteColor];

        [self addSubview:redNum];
        [badgeNumberViews addObject:redNum];
    }
    [self setValue:badgeNumberViews forKey:kBadgeNumberViewsKey];
}

- (void)gt_adjustBadgeNumberViewWithLabel:(UILabel *)label
                                   number:(NSInteger)number
{
    [label setText:(number > 99 ? @"..." : @(number).stringValue)];
    if(number < 10){
        label.bounds = CGRectMake(0, 0, 14, 14);
    }else if(number < 99){
        label.bounds = CGRectMake(0, 0, 20, 14);
    }else{
        label.bounds = CGRectMake(0, 0, 20, 14);
    }
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return objc_getAssociatedObject(self, (__bridge const void *)(key));
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    objc_setAssociatedObject(self, (__bridge const void *)(key), value, OBJC_ASSOCIATION_COPY);
}


@end
