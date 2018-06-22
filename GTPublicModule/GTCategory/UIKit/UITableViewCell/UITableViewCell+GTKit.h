//
//  UITableViewCell+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/21.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GT_UITableViewCell_AccessoryTypeActionBlock)(UISwitch *switcher);


@interface UITableViewCell (GTKit)


#pragma mark - Reuse
///=============================================================================
/// @name Reuse
///=============================================================================


/**
 UITableViewCell：xib cell 复用，从 xib 里获取 cell，注意：获取不到则创建新的(默认重用的 identify 为类名，xib 上的 identify 必须写上)

 @param index index description
 @param identify identify description
 @param tableView tableView description
 @return UITableViewCell
 */
+ (__kindof UITableViewCell *)gt_cellDequeueFromNibIndex:(NSInteger)index
                                                identify:(NSString *)identify
                                               tableView:(UITableView *)tableView;

/**
 UITableViewCell：纯代码 cell 复用

 @param identify identify description
 @param cellStyle cellStyle description
 @param tableView tableView description
 @return UITableViewCell
 */
+ (__kindof UITableViewCell *)gt_cellDequeueFromIdentify:(NSString *)identify
                                               cellStyle:(UITableViewCellStyle)cellStyle
                                               tableView:(UITableView *)tableView;

/**
 UITableViewCell：通过 xib 创建一个新的 cell

 @param nibName xib 名字
 @return UITableViewCell
 */
+ (__kindof UITableViewCell *)gt_cellCreateCellFromNibName:(NSString *)nibName
                                                     index:(NSInteger)index;


#pragma mark - NIB
///=============================================================================
/// @name NIB
///=============================================================================

/**
 *  @brief  加载同类名的nib
 *
 *  @return nib
 */
+(UINib*)gt_nib;


#pragma mark - AccessoryType
///=============================================================================
/// @name AccessoryType
///=============================================================================

/**
 UITableViewCell：设置 accessoryView 为 自定义图片

 @param image image description
 @param frame frame description
 */
- (void)gt_cellSetAccessoryImage:(UIImage *)image frame:(CGRect)frame;


/**
 UITableViewCell：设置 accessoryView 为 自定义 UISwitch

 @param indexPath indexPath description
 @param frame frame description
 @param actionBlock actionBlock description
 */
- (void)gt_cellSetAccessorySwitchWithIndexPath:(NSIndexPath *)indexPath
                                         frame:(CGRect)frame
                                   actionBlock:(GT_UITableViewCell_AccessoryTypeActionBlock)actionBlock;


#pragma mark - DelaysContentTouches
///=============================================================================
/// @name DelaysContentTouches
///=============================================================================

@property (nonatomic, assign) BOOL gt_delaysContentTouches;





@end
