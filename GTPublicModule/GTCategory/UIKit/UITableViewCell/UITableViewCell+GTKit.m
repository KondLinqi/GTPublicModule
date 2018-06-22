//
//  UITableViewCell+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/21.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UITableViewCell+GTKit.h"
#import "UIView+GTKit.h"

@implementation UITableViewCell (GTKit)


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
                                               tableView:(UITableView *)tableView
{
    UITableViewCell *cell = nil;
    if (identify == nil)
    {
        identify = NSStringFromClass([self class]);
    }
    cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][index];
    }

    return cell;
}

/**
 UITableViewCell：纯代码 cell 复用

 @param identify identify description
 @param cellStyle cellStyle description
 @param tableView tableView description
 @return UITableViewCell
 */
+ (__kindof UITableViewCell *)gt_cellDequeueFromIdentify:(NSString *)identify
                                               cellStyle:(UITableViewCellStyle)cellStyle
                                               tableView:(UITableView *)tableView
{
    UITableViewCell *cell = nil;
    if (identify == nil)
    {
        identify = @"_detail_cell_identify_";
    }
    cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:identify];
    }

    return cell;
}

/**
 UITableViewCell：通过 xib 创建一个新的 cell

 @param nibName xib 名字
 @return UITableViewCell
 */
+ (__kindof UITableViewCell *)gt_cellCreateCellFromNibName:(NSString *)nibName
                                                     index:(NSInteger)index
{
    return [[NSBundle mainBundle] loadNibNamed:nibName?:NSStringFromClass([self class]) owner:nil options:nil][index];
}


#pragma mark - NIB
///=============================================================================
/// @name NIB
///=============================================================================

/**
 *  @brief  加载同类名的nib
 *
 *  @return nib
 */
+(UINib*)gt_nib{
    return  [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}


#pragma mark - AccessoryType
///=============================================================================
/// @name AccessoryType
///=============================================================================

- (void)gt_cellSetAccessoryImage:(UIImage *)image frame:(CGRect)frame
{
    if (image)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = frame;

        //            imageView.frame = CGRectMake(BAKit_SCREEN_WIDTH - 40, 0, 20, 20);
        imageView.centerY = self.centerY;
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.accessoryView = imageView;
    }
}

- (void)gt_cellSetAccessorySwitchWithIndexPath:(NSIndexPath *)indexPath
                                         frame:(CGRect)frame
                                   actionBlock:(GT_UITableViewCell_AccessoryTypeActionBlock)actionBlock
{
    [self.accessoryView removeFromSuperview];
    UISwitch *switcher;
    BOOL switcherOn = NO;
    if ([self.accessoryView isKindOfClass:[UISwitch class]])
    {
        switcher = (UISwitch *)self.accessoryView;
    }
    else
    {
        switcher = [[UISwitch alloc] init];
        switcher.frame = frame;
        switcher.tag = indexPath.row;
    }
    switcher.on = switcherOn;
    [switcher removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    self.accessoryView = switcher;
    if (actionBlock)
    {
        actionBlock(switcher);
    }
}


#pragma mark - DelaysContentTouches
///=============================================================================
/// @name DelaysContentTouches
///=============================================================================

- (UIScrollView*) gt_scrollView
{
    id sv = self.contentView.superview;
    while ( ![sv isKindOfClass: [UIScrollView class]] && sv != self )
    {
        sv = [sv superview];
    }

    return sv == self ? nil : sv;
}

- (void) setGt_delaysContentTouches:(BOOL)delaysContentTouches
{
    [self willChangeValueForKey: @"gt_delaysContentTouches"];

    [[self gt_scrollView] setDelaysContentTouches: delaysContentTouches];

    [self didChangeValueForKey: @"gt_delaysContentTouches"];
}

- (BOOL) gt_delaysContentTouches
{
    return [[self gt_scrollView] delaysContentTouches];
}

@end
