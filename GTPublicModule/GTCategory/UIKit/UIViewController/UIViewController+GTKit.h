//
//  UIViewController+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/21.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIViewControllerGTSegueBlock) (id sender, id destinationVC, UIStoryboardSegue *segue);

@interface UIViewController (GTKit)


#pragma mark - BlockSegue
///=============================================================================
/// @name BlockSegue
///=============================================================================

-(void)gt_configureSegue:(NSString *)identifier withBlock:(UIViewControllerGTSegueBlock)block;
-(void)gt_performSegueWithIdentifier:(NSString *)identifier sender:(id)sender withBlock:(UIViewControllerGTSegueBlock)block;

#pragma mark - Visible
///=============================================================================
/// @name Visible
///=============================================================================

- (BOOL)gt_isVisible;


#pragma mark - 视图层级
///=============================================================================
/// @name 视图层级
///=============================================================================

/**
 *  @brief  视图层级
 *
 *  @return 视图层级字符串
 */
-(NSString*)gt_recursiveDescription;

#pragma mark -  隐藏键盘
///=============================================================================
/// @name  隐藏键盘
///=============================================================================
- (void)gt_hideKeyBoard;



@end
