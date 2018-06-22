//
//  UIView+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UIView+GTKit.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (GTKit)

#pragma mark - init methods
- (instancetype)gt_initWithSize:(CGSize)size {
    return [self initWithFrame:CGRectMake(0, 0, size.width, size.height)];
}

- (UIEdgeInsets)gt_safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return self.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

#pragma mark - frame

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}




#pragma mark - snapshot

- (UIImage *)gt_snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)gt_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
    if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        return [self gt_snapshotImage];
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (NSData *)gt_snapshotPDF {
    CGRect bounds = self.bounds;
    NSMutableData *data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self.layer renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

- (CGFloat)gt_visibleAlpha {
    if ([self isKindOfClass:[UIWindow class]]) {
        if (self.hidden) return 0;
        return self.alpha;
    }
    if (!self.window) return 0;
    CGFloat alpha = 1;
    UIView *v = self;
    while (v) {
        if (v.hidden) {
            alpha = 0;
            break;
        }
        alpha *= v.alpha;
        v = v.superview;
    }
    return alpha;
}


#pragma mark - find
/**
 *  @brief  找到指定类名的view对象
 *
 *  @param clazz view类名
 *
 *  @return view对象
 */
- (id)gt_findSubViewWithSubViewClass:(Class)clazz
{
    for (id subView in self.subviews) {
        if ([subView isKindOfClass:clazz]) {
            return subView;
        }
    }
    
    return nil;
}
/**
 *  @brief  找到指定类名的SuperView对象
 *
 *  @param clazz SuperView类名
 *
 *  @return view对象
 */
- (id)gt_findSuperViewWithSuperViewClass:(Class)clazz
{
    if (self == nil) {
        return nil;
    } else if (self.superview == nil) {
        return nil;
    } else if ([self.superview isKindOfClass:clazz]) {
        return self.superview;
    } else {
        return [self.superview gt_findSuperViewWithSuperViewClass:clazz];
    }
}
/**
 *  @brief  找到并且resign第一响应者
 *
 *  @return 结果
 */
- (BOOL)gt_findAndResignFirstResponder {
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    
    for (UIView *v in self.subviews) {
        if ([v gt_findAndResignFirstResponder]) {
            return YES;
        }
    }
    
    return NO;
}
/**
 *  @brief  找到第一响应者
 *
 *  @return 第一响应者
 */
- (UIView *)gt_findFirstResponder {
    
    if (([self isKindOfClass:[UITextField class]] || [self isKindOfClass:[UITextView class]])
        && (self.isFirstResponder)) {
        return self;
    }
    
    for (UIView *v in self.subviews) {
        UIView *fv = [v gt_findFirstResponder];
        if (fv) {
            return fv;
        }
    }
    
    return nil;
}
/**
 *  @brief  找到当前view所在的viewcontroler
 */
- (UIViewController *)gt_viewController
{
    UIResponder *responder = self.nextResponder;
    do {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    } while (responder);
    return nil;
}

#pragma mark - Nib

+ (UINib *)gt_loadNib
{
    return [self gt_loadNibNamed:NSStringFromClass([self class])];
}
+ (UINib *)gt_loadNibNamed:(NSString*)nibName
{
    return [self gt_loadNibNamed:nibName bundle:[NSBundle mainBundle]];
}
+ (UINib *)gt_loadNibNamed:(NSString*)nibName bundle:(NSBundle *)bundle
{
    return [UINib nibWithNibName:nibName bundle:bundle];
}
+ (instancetype)gt_loadInstanceFromNib
{
    return [self gt_loadInstanceFromNibWithName:NSStringFromClass([self class])];
}
+ (instancetype)gt_loadInstanceFromNibWithName:(NSString *)nibName
{
    return [self gt_loadInstanceFromNibWithName:nibName owner:nil];
}
+ (instancetype)gt_loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner
{
    return [self gt_loadInstanceFromNibWithName:nibName owner:owner bundle:[NSBundle mainBundle]];
}
+ (instancetype)gt_loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle
{
    UIView *result = nil;
    NSArray* elements = [bundle loadNibNamed:nibName owner:owner options:nil];
    for (id object in elements)
    {
        if ([object isKindOfClass:[self class]])
        {
            result = object;
            break;
        }
    }
    return result;
}

#pragma mark - Recursive 递归

/**
 *  @brief  寻找子视图
 *
 *  @param recurse 回调
 *
 *  @return  Return YES from the block to recurse into the subview.
 Set stop to YES to return the subview.
 */
- (UIView*)gt_findViewRecursively:(BOOL(^)(UIView* subview, BOOL* stop))recurse
{
    for( UIView* subview in self.subviews ) {
        BOOL stop = NO;
        if( recurse( subview, &stop ) ) {
            return [subview gt_findViewRecursively:recurse];
        } else if( stop ) {
            return subview;
        }
    }
    
    return nil;
}


-(void)gt_runBlockOnAllSubviews:(GTSubviewBlock)block
{
    block(self);
    for (UIView* view in [self subviews])
    {
        [view gt_runBlockOnAllSubviews:block];
    }
}

-(void)gt_runBlockOnAllSuperviews:(GTSuperviewBlock)block
{
    block(self);
    if (self.superview)
    {
        [self.superview gt_runBlockOnAllSuperviews:block];
    }
}

-(void)gt_enableAllControlsInViewHierarchy
{
    [self gt_runBlockOnAllSubviews:^(UIView *view) {
        
        if ([view isKindOfClass:[UIControl class]])
        {
            [(UIControl *)view setEnabled:YES];
        }
        else if ([view isKindOfClass:[UITextView class]])
        {
            [(UITextView *)view setEditable:YES];
        }
    }];
}

-(void)gt_disableAllControlsInViewHierarchy
{
    [self gt_runBlockOnAllSubviews:^(UIView *view) {
        
        if ([view isKindOfClass:[UIControl class]])
        {
            [(UIControl *)view setEnabled:NO];
        }
        else if ([view isKindOfClass:[UITextView class]])
        {
            [(UITextView *)view setEditable:NO];
        }
    }];
}

#pragma mark - 操作 view

- (void)gt_removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

-(void)gt_removeFromSuperviewWithFadeDuration: (NSTimeInterval)duration
{
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: duration];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDidStopSelector: @selector(removeFromSuperview)];
    self.alpha = 0.0;
    [UIView commitAnimations];
}

-(void)gt_addSubview: (UIView *)subview withTransition: (UIViewAnimationTransition)transition duration: (NSTimeInterval)duration
{
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: duration];
    [UIView setAnimationTransition: transition forView: self cache: YES];
    [self addSubview: subview];
    [UIView commitAnimations];
    
}


-(void)gt_removeFromSuperviewWithTransition: (UIViewAnimationTransition)transition duration: (NSTimeInterval)duration
{
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: duration];
    [UIView setAnimationTransition: transition forView: self.superview cache: YES];
    [self removeFromSuperview];
    [UIView commitAnimations];
}

#pragma mark convert

- (CGPoint)gt_convertPoint:(CGPoint)point toViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point toWindow:nil];
        } else {
            return [self convertPoint:point toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point toView:view];
    point = [self convertPoint:point toView:from];
    point = [to convertPoint:point fromWindow:from];
    point = [view convertPoint:point fromView:to];
    return point;
}

- (CGPoint)gt_convertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertPoint:point fromWindow:nil];
        } else {
            return [self convertPoint:point fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertPoint:point fromView:view];
    point = [from convertPoint:point fromView:view];
    point = [to convertPoint:point fromWindow:from];
    point = [self convertPoint:point fromView:to];
    return point;
}

- (CGRect)gt_convertRect:(CGRect)rect toViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect toWindow:nil];
        } else {
            return [self convertRect:rect toView:nil];
        }
    }
    
    UIWindow *from = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    UIWindow *to = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    if (!from || !to) return [self convertRect:rect toView:view];
    if (from == to) return [self convertRect:rect toView:view];
    rect = [self convertRect:rect toView:from];
    rect = [to convertRect:rect fromWindow:from];
    rect = [view convertRect:rect fromView:to];
    return rect;
}

- (CGRect)gt_convertRect:(CGRect)rect fromViewOrWindow:(UIView *)view {
    if (!view) {
        if ([self isKindOfClass:[UIWindow class]]) {
            return [((UIWindow *)self) convertRect:rect fromWindow:nil];
        } else {
            return [self convertRect:rect fromView:nil];
        }
    }
    
    UIWindow *from = [view isKindOfClass:[UIWindow class]] ? (id)view : view.window;
    UIWindow *to = [self isKindOfClass:[UIWindow class]] ? (id)self : self.window;
    if ((!from || !to) || (from == to)) return [self convertRect:rect fromView:view];
    rect = [from convertRect:rect fromView:view];
    rect = [to convertRect:rect fromWindow:from];
    rect = [self convertRect:rect fromView:to];
    return rect;
}



@end
