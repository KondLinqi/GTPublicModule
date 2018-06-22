//
//  UIResponder+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/20.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (GTKit)

/**
 *  @brief  响应者链
 *
 *  @return  响应者链
 */
- (NSString *)gt_responderChainDescription;

/**
 *  @brief  当前第一响应者
 *
 *  @return 当前第一响应者
 */
+ (id)gt_currentFirstResponder;

@end
