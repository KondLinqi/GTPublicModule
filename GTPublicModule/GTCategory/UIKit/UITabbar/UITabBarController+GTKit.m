//
//  UITabBarController+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/17.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UITabBarController+GTKit.h"
#import "UIImage+GTKit.h"
#import <objc/runtime.h>

@implementation UITabBarController (GTKit)

- (void)setGt_tabBar_tintColor:(UIColor *)gt_tabBar_tintColor
{
    objc_setAssociatedObject(self, @selector(gt_tabBar_tintColor), gt_tabBar_tintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [UITabBar appearance].tintColor = gt_tabBar_tintColor;
}

- (UIColor *)gt_tabBar_tintColor
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_tabBar_backgroundColor:(UIColor *)gt_tabBar_backgroundColor
{
    objc_setAssociatedObject(self, @selector(gt_tabBar_backgroundColor), gt_tabBar_backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [UITabBar appearance].backgroundImage = [UIImage gt_imageWithColor:gt_tabBar_backgroundColor];
}

- (UIColor *)gt_tabBar_backgroundColor
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGt_tabBar_backgroundImage:(UIImage *)gt_tabBar_backgroundImage
{
    objc_setAssociatedObject(self, @selector(gt_tabBar_backgroundImage), gt_tabBar_backgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [UITabBar appearance].backgroundImage = gt_tabBar_backgroundImage;
}

- (UIImage *)gt_tabBar_backgroundImage
{
    return objc_getAssociatedObject(self, _cmd);
}


- (UIViewController*)gt_topViewController;
{
    UIViewController * topVC = nil;
    UIViewController * selectVC = self.selectedViewController;
    if ([selectVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController *)selectVC;
        UIViewController * vc = [nav.viewControllers lastObject];
        topVC = vc;
    }
    return topVC;
}

@end
