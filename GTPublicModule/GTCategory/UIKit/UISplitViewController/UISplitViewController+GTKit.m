//
//  UISplitViewController+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UISplitViewController+GTKit.h"

@implementation UISplitViewController (GTKit)

- (UIViewController *)gt_leftController {
    UIViewController * leftVC = [[self viewControllers] objectAtIndex:0];
    
    if ([leftVC isKindOfClass:[UINavigationController class]]) {
        leftVC = [(UINavigationController *)leftVC topViewController];
    }
    return  leftVC;
}

- (UIViewController *)gt_rightController {
    UIViewController * rightVC = [[self viewControllers] lastObject];
    
    if ([rightVC isKindOfClass:[UINavigationController class]]) {
        rightVC = [(UINavigationController *)rightVC topViewController];
    }
    return rightVC;
}

@end
