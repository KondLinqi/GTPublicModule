//
//  UISplitViewController+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISplitViewController (GTKit)

@property (weak, readonly, nonatomic) UIViewController *gt_leftController;
@property (weak, readonly, nonatomic) UIViewController *gt_rightController;

@end
