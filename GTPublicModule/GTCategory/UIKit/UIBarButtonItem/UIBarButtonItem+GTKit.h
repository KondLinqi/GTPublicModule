//
//  UIBarButtonItem+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (GTKit)

/**
 创建 自定义 UIBarButtonItem
 
 @param image image
 @param highImage highImage
 @param target target
 @param action action
 @param controlEvents controlEvents
 @return UIBarButtonItem
 */
+ (UIBarButtonItem *_Nullable)barButtonItemWithImage:(UIImage *_Nullable)image
                                           highImage:(UIImage *_Nullable)highImage
                                              target:(id _Nullable)target
                                              action:(SEL _Nullable)action
                           forControlEvents:(UIControlEvents)controlEvents;

/**
 The block that invoked when the item is selected. The objects captured by block
 will retained by the ButtonItem.
 
 @discussion This param is conflict with `target` and `action` property.
 Set this will set `target` and `action` property to some internal objects.
 */
@property (nullable, nonatomic, copy) void (^gt_actionBlock)(id _Nullable);

@end
