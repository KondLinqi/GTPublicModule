//
//  UIView+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+GTTransition.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^GTSubviewBlock) (UIView* view);
typedef void (^GTSuperviewBlock) (UIView* superview);

/**
 Provides extensions for `UIView`.
 */
@interface UIView (GTKit)

#pragma mark - init methods

/**
 *  相当于 initWithFrame:CGRectMake(0, 0, size.width, size.height)
 */
- (instancetype)gt_initWithSize:(CGSize)size;

/// 在 iOS 11 及之后的版本，此属性将返回系统已有的 self.safeAreaInsets。在之前的版本此属性返回 UIEdgeInsetsZero
@property(nonatomic, assign, readonly) UIEdgeInsets gt_safeAreaInsets;


#pragma mark - frame

@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  size;        ///< Shortcut for frame.size.

#pragma mark - snapshot

/**
 Create a snapshot image of the complete view hierarchy.
 */
- (nullable UIImage *)gt_snapshotImage;

/**
 Create a snapshot image of the complete view hierarchy.
 @discussion It's faster than "snapshotImage", but may cause screen updates.
 See -[UIView drawViewHierarchyInRect:afterScreenUpdates:] for more information.
 */
- (nullable UIImage *)gt_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

/**
 Create a snapshot PDF of the complete view hierarchy.
 */
- (nullable NSData *)gt_snapshotPDF;


/**
 Returns the visible alpha on screen, taking into account superview and window.
 */
@property (nonatomic, readonly) CGFloat gt_visibleAlpha;


#pragma mark - find

/**
 *  @brief  找到指定类名的SubVie对象
 *
 *  @param clazz SubVie类名
 *
 *  @return view对象
 */
- (id)gt_findSubViewWithSubViewClass:(Class)clazz;
/**
 *  @brief  找到指定类名的SuperView对象
 *
 *  @param clazz SuperView类名
 *
 *  @return view对象
 */
- (id)gt_findSuperViewWithSuperViewClass:(Class)clazz;

/**
 *  @brief  找到并且resign第一响应者
 *
 *  @return 结果
 */
- (BOOL)gt_findAndResignFirstResponder;
/**
 *  @brief  找到第一响应者
 *
 *  @return 第一响应者
 */
- (UIView *)gt_findFirstResponder;

/**
 *  @brief  找到当前view所在的viewcontroler
 */
@property (readonly) UIViewController *gt_viewController;

#pragma mark - Nib

+ (UINib *)gt_loadNib;
+ (UINib *)gt_loadNibNamed:(NSString*)nibName;
+ (UINib *)gt_loadNibNamed:(NSString*)nibName bundle:(NSBundle *)bundle;

+ (instancetype)gt_loadInstanceFromNib;
+ (instancetype)gt_loadInstanceFromNibWithName:(NSString *)nibName;
+ (instancetype)gt_loadInstanceFromNibWithName:(NSString *)nibName owner:(id _Nullable)owner;
+ (instancetype)gt_loadInstanceFromNibWithName:(NSString *)nibName owner:(id _Nullable)owner bundle:(NSBundle *)bundle;

#pragma mark - Recursive 递归
/**
 *  @brief  寻找子视图
 *
 *  @param recurse 回调
 *
 *  @return  Return YES from the block to recurse into the subview.
 Set stop to YES to return the subview.
 */
- (UIView*)gt_findViewRecursively:(BOOL(^)(UIView* subview, BOOL* stop))recurse;

-(void)gt_runBlockOnAllSubviews:(GTSubviewBlock)block;
-(void)gt_runBlockOnAllSuperviews:(GTSuperviewBlock)block;
-(void)gt_enableAllControlsInViewHierarchy;
-(void)gt_disableAllControlsInViewHierarchy;

#pragma mark - operation subview

/**
 Remove all subviews.
 
 @warning Never call this method inside your view's drawRect: method.
 */
- (void)gt_removeAllSubviews;

/*
 *  Removes from superview with fade
 */
-(void)gt_removeFromSuperviewWithFadeDuration: (NSTimeInterval)duration;

/*
 *  Adds a subview with given transition & duration
 */
-(void)gt_addSubview: (UIView *)view withTransition: (UIViewAnimationTransition)transition duration: (NSTimeInterval)duration;

/*
 *  Removes view from superview with given transition & duration
 */
-(void)gt_removeFromSuperviewWithTransition: (UIViewAnimationTransition)transition duration: (NSTimeInterval)duration;



#pragma mark convert

/**
 Converts a point from the receiver's coordinate system to that of the specified view or window.
 
 @param point A point specified in the local coordinate system (bounds) of the receiver.
 @param view  The view or window into whose coordinate system point is to be converted.
 If view is nil, this method instead converts to window base coordinates.
 @return The point converted to the coordinate system of view.
 */
- (CGPoint)gt_convertPoint:(CGPoint)point toViewOrWindow:(nullable UIView *)view;

/**
 Converts a point from the coordinate system of a given view or window to that of the receiver.
 
 @param point A point specified in the local coordinate system (bounds) of view.
 @param view  The view or window with point in its coordinate system.
 If view is nil, this method instead converts from window base coordinates.
 @return The point converted to the local coordinate system (bounds) of the receiver.
 */
- (CGPoint)gt_convertPoint:(CGPoint)point fromViewOrWindow:(nullable UIView *)view;

/**
 Converts a rectangle from the receiver's coordinate system to that of another view or window.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of the receiver.
 @param view The view or window that is the target of the conversion operation. If view is nil, this method instead converts to window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)gt_convertRect:(CGRect)rect toViewOrWindow:(nullable UIView *)view;

/**
 Converts a rectangle from the coordinate system of another view or window to that of the receiver.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of view.
 @param view The view or window with rect in its coordinate system.
 If view is nil, this method instead converts from window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)gt_convertRect:(CGRect)rect fromViewOrWindow:(nullable UIView *)view;


@end

NS_ASSUME_NONNULL_END
