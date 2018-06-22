//
//  UITabBarItem+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/17.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UITabBarItem+GTKit.h"
#import <objc/runtime.h>
@implementation UITabBarItem (GTKit)


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
                                     tag:(NSInteger)tag
{
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:tag];
    tabBarItem.selectedImage = selectedImage;
    if (selectedTitleColor)
    {
        [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : selectedTitleColor} forState:UIControlStateSelected];
    }

    return tabBarItem;
}

/**
 设置角标值时，替换系统的 'setBadgeValue:'方法

 @param badgeValue badgeValue description
 */
- (void)gt_tabBarItemSetBadgeValue:(NSString *)badgeValue
{
    // 先设置角标值
    [self setBadgeValue:badgeValue];

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_10_0
    // 如果系统是iOS10 以上的就使用系统方法修改
    UIColor *badgeColor = [UIColor blueColor];
    [self setBadgeColor:badgeColor];
#else
    // 这里替换角标颜色的图片，需要注意的时：这个图片size=(36px,36px)，圆的
    UIImage *badgeImage = [UIImage imageNamed:@"blueBadge"];
    [self customBadgeColorWith:badgeImage];
#endif
}

- (void)customBadgeColorWith:(UIImage *)badgeImage
{
    UIView *tabBarButton = (UIView *)[self performSelector:@selector(view)];

    // iOS10以下的版本 角标其实是一张图片，所以我们一直找下去这个图片，然后替换他
    for(UIView *subview in tabBarButton.subviews)
    {
        NSString *classString = NSStringFromClass([subview class]);
        if([classString rangeOfString:@"UIBadgeView"].location != NSNotFound)
        {
            for(UIView *badgeSubview in subview.subviews)
            {
                NSString *badgeSubviewClassString = NSStringFromClass([badgeSubview class]);
                if([badgeSubviewClassString rangeOfString:@"BadgeBackground"].location != NSNotFound)
                {
                    [badgeSubview setValue:badgeImage forKey:@"image"];
                }
            }
        }
    }
}

#pragma mark - setter / getter
- (void)setGt_tabBarItem_titleColor:(UIColor *)gt_tabBarItem_titleColor
{
    objc_setAssociatedObject(self, @selector(gt_tabBarItem_titleColor), gt_tabBarItem_titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSDictionary <NSString *, id> *textAttributes = @{NSForegroundColorAttributeName: gt_tabBarItem_titleColor};
    [[UITabBarItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
}

- (UIColor *)gt_tabBarItem_titleColor
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_tabBarItem_titleSelectedColor:(UIColor *)gt_tabBarItem_titleSelectedColor
{
    objc_setAssociatedObject(self, @selector(gt_tabBarItem_titleSelectedColor), gt_tabBarItem_titleSelectedColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSDictionary <NSString *, id> *textAttributes = @{NSForegroundColorAttributeName: gt_tabBarItem_titleSelectedColor};
    [[UITabBarItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
}

- (UIColor *)gt_tabBarItem_titleSelectedColor
{
    return objc_getAssociatedObject(self, _cmd);
}




@end
