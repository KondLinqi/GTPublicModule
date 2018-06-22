//
//  UITextField+History.h
//  Demo
//
//  Created by DamonDing on 15/5/26.
//  Copyright (c) 2015年 morenotepad. All rights reserved.
//
//  https://github.com/Jameson-zxm/UITextField-History
//   A category of UITextfiled that can record it's input as history

#import <UIKit/UIKit.h>

@interface UITextField (GTHistory)

/**
 *  identity of this textfield
 */
@property (retain, nonatomic) NSString *gt_identify;

/**
 *  load textfiled input history
 *
 *
 *  @return the history of it's input
 */
- (NSArray*)gt_loadHistroy;

/**
 *  save current input text
 */
- (void)gt_synchronize;

- (void)gt_showHistory;
- (void)gt_hideHistroy;

- (void)gt_clearHistory;

@end
