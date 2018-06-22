//
//  UIWindow+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/20.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UIWindow+GTKit.h"

@implementation UIWindow (GTKit)

- (UIViewController*)gt_topMostController
{
    UIViewController *topController = [self rootViewController];
    
    //  Getting topMost ViewController
    while ([topController presentedViewController]) topController = [topController presentedViewController];
    
    //  Returning topMost ViewController
    return topController;
}

- (UIViewController*)gt_currentViewController;
{
    UIViewController * currentVC = nil;
    UIViewController * rootVC = self.rootViewController;
    do {
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)rootVC;
            UIViewController * vc = [nav.viewControllers lastObject];
            currentVC = vc;
            rootVC = vc.presentedViewController;
            continue;
        } else if ([rootVC isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)rootVC;
            currentVC = tabVC;
            rootVC = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }
    } while (rootVC != nil);
    
    return currentVC;
}



@end
