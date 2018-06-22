//
//  UIViewController+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/21.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UIViewController+GTKit.h"
#import <objc/runtime.h>


@implementation UIViewController (GTKit)

#pragma mark - BlockSegue
///=============================================================================
/// @name BlockSegue
///=============================================================================

__attribute__((constructor))
void GTBlockSegue(void) {
    Class currentClass = [UIViewController class];

    SEL originalSel = @selector(prepareForSegue:sender:);
    SEL swizzledSel = @selector(gt_prepareForSegue:sender:);

    Method originalMethod = class_getInstanceMethod(currentClass, originalSel);
    IMP swizzledImplementation = class_getMethodImplementation(currentClass, swizzledSel);

    method_setImplementation(originalMethod, swizzledImplementation);
}

-(void)gt_prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (segue.identifier == nil) {
        return;
    }

    if (!self.jmg_dictionaryBlock || !self.jmg_dictionaryBlock[segue.identifier]) {
        NSLog(@"Segue identifier '%@' doesn't exist", segue.identifier);
        return;
    }

    UIViewControllerGTSegueBlock segueBlock = self.jmg_dictionaryBlock[segue.identifier];
    segueBlock(sender, segue.destinationViewController, segue);
}

-(NSMutableDictionary *)jmg_dictionaryBlock {
    return objc_getAssociatedObject(self, _cmd);
}

-(NSMutableDictionary *)jmg_createDictionaryBlock {
    if (!self.jmg_dictionaryBlock) {
        objc_setAssociatedObject(self, @selector(jmg_dictionaryBlock), [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN);
    }

    return self.jmg_dictionaryBlock;
}

#pragma mark - Public interface
-(void)gt_configureSegue:(NSString *)identifier withBlock:(UIViewControllerGTSegueBlock)block {
    if (!identifier) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Segue identifier can not be nil" userInfo:nil];
    }

    if (!block) {
        return ;
    }

    NSMutableDictionary *dBlocks = self.jmg_dictionaryBlock ?: [self jmg_createDictionaryBlock];
    [dBlocks setObject:block forKey:identifier];
}

-(void)gt_performSegueWithIdentifier:(NSString *)identifier sender:(id)sender withBlock:(UIViewControllerGTSegueBlock)block {
    if (!identifier) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Segue identifier can not be nil" userInfo:nil];
    }

    if (!block) {
        return ;
    }

    [self gt_configureSegue:identifier withBlock:block];
    [self performSegueWithIdentifier:identifier sender:sender];
}



#pragma mark - Visible
///=============================================================================
/// @name Visible
///=============================================================================

- (BOOL)gt_isVisible {
    return [self isViewLoaded] && self.view.window;
}


#pragma mark - 视图层级
///=============================================================================
/// @name 视图层级
///=============================================================================

/**
 *  @brief  视图层级
 *
 *  @return 视图层级字符串
 */
-(NSString*)gt_recursiveDescription
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"\n"];
    [self gt_addDescriptionToString:description indentLevel:0];
    return description;
}

-(void)gt_addDescriptionToString:(NSMutableString*)string indentLevel:(NSInteger)indentLevel
{
    NSString *padding = [@"" stringByPaddingToLength:indentLevel withString:@" " startingAtIndex:0];
    [string appendString:padding];
    [string appendFormat:@"%@, %@",[self debugDescription],NSStringFromCGRect(self.view.frame)];

    for (UIViewController *childController in self.childViewControllers)
    {
        [string appendFormat:@"\n%@>",padding];
        [childController gt_addDescriptionToString:string indentLevel:indentLevel + 1];
    }
}

#pragma mark -  隐藏键盘
///=============================================================================
/// @name  隐藏键盘
///=============================================================================
- (void)gt_hideKeyBoard {
    // 遍历所有子视图
    [self _traverseAllSubviewsToResignFirstResponder:self.view];
}

//遍历父视图的所有子视图，包括嵌套的子视图
- (void)_traverseAllSubviewsToResignFirstResponder:(UIView *)view {
    for (UIView *subView in view.subviews) {
        if (subView.subviews.count) {
            [self _traverseAllSubviewsToResignFirstResponder:subView];
        }
        [subView resignFirstResponder];
    }
}

@end
