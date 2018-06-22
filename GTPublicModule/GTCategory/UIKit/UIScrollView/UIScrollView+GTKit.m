//
//  UIScrollView+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UIScrollView+GTKit.h"

@implementation UIScrollView (GTKit)

//frame
- (CGFloat)gt_contentWidth {
    return self.contentSize.width;
}
- (void)setGt_contentWidth:(CGFloat)width {
    self.contentSize = CGSizeMake(width, self.frame.size.height);
}
- (CGFloat)gt_contentHeight {
    return self.contentSize.height;
}
- (void)setGt_contentHeight:(CGFloat)height {
    self.contentSize = CGSizeMake(self.frame.size.width, height);
}
- (CGFloat)gt_contentOffsetX {
    return self.contentOffset.x;
}
- (void)setGt_contentOffsetX:(CGFloat)x {
    self.contentOffset = CGPointMake(x, self.contentOffset.y);
}
- (CGFloat)gt_contentOffsetY {
    return self.contentOffset.y;
}
- (void)setGt_contentOffsetY:(CGFloat)y {
    self.contentOffset = CGPointMake(self.contentOffset.x, y);
}
//


- (CGPoint)gt_topContentOffset
{
    return CGPointMake(0.0f, -self.contentInset.top);
}
- (CGPoint)gt_bottomContentOffset
{
    return CGPointMake(0.0f, self.contentSize.height + self.contentInset.bottom - self.bounds.size.height);
}
- (CGPoint)gt_leftContentOffset
{
    return CGPointMake(-self.contentInset.left, 0.0f);
}
- (CGPoint)gt_rightContentOffset
{
    return CGPointMake(self.contentSize.width + self.contentInset.right - self.bounds.size.width, 0.0f);
}
- (GTScrollDirection)gt_ScrollDirection
{
    GTScrollDirection direction;
    
    if ([self.panGestureRecognizer translationInView:self.superview].y > 0.0f)
    {
        direction = GTScrollDirectionUp;
    }
    else if ([self.panGestureRecognizer translationInView:self.superview].y < 0.0f)
    {
        direction = GTScrollDirectionDown;
    }
    else if ([self.panGestureRecognizer translationInView:self].x < 0.0f)
    {
        direction = GTScrollDirectionLeft;
    }
    else if ([self.panGestureRecognizer translationInView:self].x > 0.0f)
    {
        direction = GTScrollDirectionRight;
    }
    else
    {
        direction = GTScrollDirectionWTF;
    }
    
    return direction;
}
- (BOOL)gt_isScrolledToTop
{
    return self.contentOffset.y <= [self gt_topContentOffset].y;
}
- (BOOL)gt_isScrolledToBottom
{
    return self.contentOffset.y >= [self gt_bottomContentOffset].y;
}
- (BOOL)gt_isScrolledToLeft
{
    return self.contentOffset.x <= [self gt_leftContentOffset].x;
}
- (BOOL)gt_isScrolledToRight
{
    return self.contentOffset.x >= [self gt_rightContentOffset].x;
}
- (void)gt_scrollToTopAnimated:(BOOL)animated
{
    [self setContentOffset:[self gt_topContentOffset] animated:animated];
}
- (void)gt_scrollToBottomAnimated:(BOOL)animated
{
    [self setContentOffset:[self gt_bottomContentOffset] animated:animated];
}
- (void)gt_scrollToLeftAnimated:(BOOL)animated
{
    [self setContentOffset:[self gt_leftContentOffset] animated:animated];
}
- (void)gt_scrollToRightAnimated:(BOOL)animated
{
    [self setContentOffset:[self gt_rightContentOffset] animated:animated];
}
- (NSUInteger)gt_verticalPageIndex
{
    return (self.contentOffset.y + (self.frame.size.height * 0.5f)) / self.frame.size.height;
}
- (NSUInteger)gt_horizontalPageIndex
{
    return (self.contentOffset.x + (self.frame.size.width * 0.5f)) / self.frame.size.width;
}
- (void)gt_scrollToVerticalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated
{
    [self setContentOffset:CGPointMake(0.0f, self.frame.size.height * pageIndex) animated:animated];
}
- (void)gt_scrollToHorizontalPageIndex:(NSUInteger)pageIndex animated:(BOOL)animated
{
    [self setContentOffset:CGPointMake(self.frame.size.width * pageIndex, 0.0f) animated:animated];
}

- (BOOL)gt_canScroll {
    // 没有高度就不用算了，肯定不可滚动，这里只是做个保护
    if (self.bounds.size.width <= 0 || self.bounds.size.height <= 0) {
        return NO;
    }
    BOOL canVerticalScroll = self.contentSize.height + (self.gt_contentInset.top + self.gt_contentInset.bottom) > CGRectGetHeight(self.bounds);
    BOOL canHorizontalScoll = self.contentSize.width + (self.gt_contentInset.left + self.gt_contentInset.right) > CGRectGetWidth(self.bounds);
    return canVerticalScroll || canHorizontalScoll;
}

- (UIEdgeInsets)gt_contentInset {
    if (@available(iOS 11, *)) {
        return self.adjustedContentInset;
    } else {
        return self.contentInset;
    }
}

- (void)gt_stopDeceleratingIfNeeded {
    if (self.decelerating) {
        [self setContentOffset:self.contentOffset animated:NO];
    }
}

#pragma mark pages

- (NSInteger)gt_pages{
    NSInteger pages = self.contentSize.width/self.frame.size.width;
    return pages;
}
- (NSInteger)gt_currentPage{
    NSInteger pages = self.contentSize.width/self.frame.size.width;
    CGFloat scrollPercent = [self gt_scrollPercent];
    NSInteger currentPage = (NSInteger)roundf((pages-1)*scrollPercent);
    return currentPage;
}
- (CGFloat)gt_scrollPercent{
    CGFloat width = self.contentSize.width-self.frame.size.width;
    CGFloat scrollPercent = self.contentOffset.x/width;
    return scrollPercent;
}

- (CGFloat)gt_pagesY {
    CGFloat pageHeight = self.frame.size.height;
    CGFloat contentHeight = self.contentSize.height;
    return contentHeight/pageHeight;
}
- (CGFloat)gt_pagesX{
    CGFloat pageWidth = self.frame.size.width;
    CGFloat contentWidth = self.contentSize.width;
    return contentWidth/pageWidth;
}
- (CGFloat)gt_currentPageY{
    CGFloat pageHeight = self.frame.size.height;
    CGFloat offsetY = self.contentOffset.y;
    return offsetY / pageHeight;
}
- (CGFloat)gt_currentPageX{
    CGFloat pageWidth = self.frame.size.width;
    CGFloat offsetX = self.contentOffset.x;
    return offsetX / pageWidth;
}
- (void)gt_setPageY:(CGFloat)page{
    [self gt_setPageY:page animated:NO];
}
- (void) gt_setPageX:(CGFloat)page{
    [self gt_setPageX:page animated:NO];
}
- (void)gt_setPageY:(CGFloat)page animated:(BOOL)animated {
    CGFloat pageHeight = self.frame.size.height;
    CGFloat offsetY = page * pageHeight;
    CGFloat offsetX = self.contentOffset.x;
    CGPoint offset = CGPointMake(offsetX,offsetY);
    [self setContentOffset:offset];
}
- (void)gt_setPageX:(CGFloat)page animated:(BOOL)animated{
    CGFloat pageWidth = self.frame.size.width;
    CGFloat offsetY = self.contentOffset.y;
    CGFloat offsetX = page * pageWidth;
    CGPoint offset = CGPointMake(offsetX,offsetY);
    [self setContentOffset:offset animated:animated];
}


@end
