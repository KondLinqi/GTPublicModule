//
//  UIScrollView+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GTScrollDirection) {
    GTScrollDirectionUp,
    GTScrollDirectionDown,
    GTScrollDirectionLeft,
    GTScrollDirectionRight,
    GTScrollDirectionWTF
};

/**
 Provides extensions for `UIScrollView`.
 */

@interface UIScrollView (GTKit)

@property(nonatomic) CGFloat gt_contentWidth;
@property(nonatomic) CGFloat gt_contentHeight;
@property(nonatomic) CGFloat gt_contentOffsetX;
@property(nonatomic) CGFloat gt_contentOffsetY;

- (CGPoint)gt_topContentOffset;
- (CGPoint)gt_bottomContentOffset;
- (CGPoint)gt_leftContentOffset;
- (CGPoint)gt_rightContentOffset;

- (GTScrollDirection)gt_ScrollDirection;

- (BOOL)gt_isScrolledToTop;
- (BOOL)gt_isScrolledToBottom;
- (BOOL)gt_isScrolledToLeft;
- (BOOL)gt_isScrolledToRight;
- (void)gt_scrollToTopAnimated:(BOOL)animated;
- (void)gt_scrollToBottomAnimated:(BOOL)animated;
- (void)gt_scrollToLeftAnimated:(BOOL)animated;
- (void)gt_scrollToRightAnimated:(BOOL)animated;

- (NSUInteger)gt_verticalPageIndex;
- (NSUInteger)gt_horizontalPageIndex;

- (void)gt_scrollToVerticalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated;
- (void)gt_scrollToHorizontalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated;


/// UIScrollView 的真正 inset，在 iOS11 以后需要用到 adjustedContentInset 而在 iOS11 以前只需要用 contentInset
@property(nonatomic, assign, readonly) UIEdgeInsets gt_contentInset;

/**
 * 判断当前的scrollView内容是否足够滚动
 * @warning 避免与<i>scrollEnabled</i>混淆
 */
- (BOOL)gt_canScroll;

// 立即停止滚动，用于那种手指已经离开屏幕但列表还在滚动的情况。
- (void)gt_stopDeceleratingIfNeeded;

#pragma mark pages

- (NSInteger)gt_pages;
- (NSInteger)gt_currentPage;
- (CGFloat)gt_scrollPercent;

- (CGFloat)gt_pagesY;
- (CGFloat)gt_pagesX;
- (CGFloat)gt_currentPageY;
- (CGFloat)gt_currentPageX;
- (void)gt_setPageY:(CGFloat)page;
- (void)gt_setPageX:(CGFloat)page;
- (void)gt_setPageY:(CGFloat)page animated:(BOOL)animated;
- (void)gt_setPageX:(CGFloat)page animated:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END
