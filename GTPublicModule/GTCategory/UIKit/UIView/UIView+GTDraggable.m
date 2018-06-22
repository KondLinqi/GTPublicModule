//
//  UIView+draggable.m
//  UIView+draggable
//
//  Created by Andrea on 13/03/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#import "UIView+GTDraggable.h"
#import <objc/runtime.h>

@implementation UIView (GTDraggable)

- (void)setGt_panGesture:(UIPanGestureRecognizer*)panGesture
{
    objc_setAssociatedObject(self, @selector(gt_panGesture), panGesture, OBJC_ASSOCIATION_RETAIN);
}

- (UIPanGestureRecognizer*)gt_panGesture
{
    return objc_getAssociatedObject(self, @selector(gt_panGesture));
}

- (void)setGt_cagingArea:(CGRect)cagingArea
{
    if (CGRectEqualToRect(cagingArea, CGRectZero) ||
        CGRectContainsRect(cagingArea, self.frame)) {
        NSValue *cagingAreaValue = [NSValue valueWithCGRect:cagingArea];
        objc_setAssociatedObject(self, @selector(gt_cagingArea), cagingAreaValue, OBJC_ASSOCIATION_RETAIN);
    }
}

- (CGRect)gt_cagingArea
{
    NSValue *cagingAreaValue = objc_getAssociatedObject(self, @selector(gt_cagingArea));
    return [cagingAreaValue CGRectValue];
}

- (void)setGt_handle:(CGRect)handle
{
    CGRect relativeFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if (CGRectContainsRect(relativeFrame, handle)) {
        NSValue *handleValue = [NSValue valueWithCGRect:handle];
        objc_setAssociatedObject(self, @selector(gt_handle), handleValue, OBJC_ASSOCIATION_RETAIN);
    }
}

- (CGRect)gt_handle
{
    NSValue *handleValue = objc_getAssociatedObject(self, @selector(gt_handle));
    return [handleValue CGRectValue];
}

- (void)setGt_shouldMoveAlongY:(BOOL)newShould
{
    NSNumber *shouldMoveAlongYBool = [NSNumber numberWithBool:newShould];
    objc_setAssociatedObject(self, @selector(gt_shouldMoveAlongY), shouldMoveAlongYBool, OBJC_ASSOCIATION_RETAIN );
}

- (BOOL)gt_shouldMoveAlongY
{
    NSNumber *moveAlongY = objc_getAssociatedObject(self, @selector(gt_shouldMoveAlongY));
    return (moveAlongY) ? [moveAlongY boolValue] : YES;
}

- (void)setGt_shouldMoveAlongX:(BOOL)newShould
{
    NSNumber *shouldMoveAlongXBool = [NSNumber numberWithBool:newShould];
    objc_setAssociatedObject(self, @selector(gt_shouldMoveAlongX), shouldMoveAlongXBool, OBJC_ASSOCIATION_RETAIN );
}

- (BOOL)gt_shouldMoveAlongX
{
    NSNumber *moveAlongX = objc_getAssociatedObject(self, @selector(gt_shouldMoveAlongX));
    return (moveAlongX) ? [moveAlongX boolValue] : YES;
}

- (void)setGt_draggingStartedBlock:(void (^)(void))draggingStartedBlock
{
    objc_setAssociatedObject(self, @selector(gt_draggingStartedBlock), draggingStartedBlock, OBJC_ASSOCIATION_RETAIN);
}

- (void (^)(void))gt_draggingStartedBlock
{
    return objc_getAssociatedObject(self, @selector(gt_draggingStartedBlock));
}

- (void)setGt_draggingEndedBlock:(void (^)(void))draggingEndedBlock
{
    objc_setAssociatedObject(self, @selector(gt_draggingEndedBlock), draggingEndedBlock, OBJC_ASSOCIATION_RETAIN);
}

- (void (^)(void))gt_draggingEndedBlock
{
    return objc_getAssociatedObject(self, @selector(gt_draggingEndedBlock));
}

- (void)gt_handlePan:(UIPanGestureRecognizer*)sender
{
    // Check to make you drag from dragging area
    CGPoint locationInView = [sender locationInView:self];
    if (!CGRectContainsPoint(self.gt_handle, locationInView)) {
        return;
    }
    
    [self gt_adjustAnchorPointForGestureRecognizer:sender];
    
    if (sender.state == UIGestureRecognizerStateBegan && self.gt_draggingStartedBlock) {
        self.gt_draggingStartedBlock();
    }
    
    if (sender.state == UIGestureRecognizerStateEnded && self.gt_draggingEndedBlock) {
        self.gt_draggingEndedBlock();
    }
    
    CGPoint translation = [sender translationInView:[self superview]];
    
    CGFloat newXOrigin = CGRectGetMinX(self.frame) + (([self gt_shouldMoveAlongX]) ? translation.x : 0);
    CGFloat newYOrigin = CGRectGetMinY(self.frame) + (([self gt_shouldMoveAlongY]) ? translation.y : 0);
    
    CGRect cagingArea = self.gt_cagingArea;
    
    CGFloat cagingAreaOriginX = CGRectGetMinX(cagingArea);
    CGFloat cagingAreaOriginY = CGRectGetMinY(cagingArea);
    
    CGFloat cagingAreaRightSide = cagingAreaOriginX + CGRectGetWidth(cagingArea);
    CGFloat cagingAreaBottomSide = cagingAreaOriginY + CGRectGetHeight(cagingArea);
    
    if (!CGRectEqualToRect(cagingArea, CGRectZero)) {
        
        // Check to make sure the view is still within the caging area
        if (newXOrigin <= cagingAreaOriginX ||
            newYOrigin <= cagingAreaOriginY ||
            newXOrigin + CGRectGetWidth(self.frame) >= cagingAreaRightSide ||
            newYOrigin + CGRectGetHeight(self.frame) >= cagingAreaBottomSide) {
            
            // Don't move
            newXOrigin = CGRectGetMinX(self.frame);
            newYOrigin = CGRectGetMinY(self.frame);
        }
    }
    
    [self setFrame:CGRectMake(newXOrigin,
                              newYOrigin,
                              CGRectGetWidth(self.frame),
                              CGRectGetHeight(self.frame))];
    
    [sender setTranslation:(CGPoint){0, 0} inView:[self superview]];
}

- (void)gt_adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = self;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (void)gt_setDraggable:(BOOL)draggable
{
    [self.gt_panGesture setEnabled:draggable];
}

- (void)gt_enableDragging
{
    self.gt_panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gt_handlePan:)];
    [self.gt_panGesture setMaximumNumberOfTouches:1];
    [self.gt_panGesture setMinimumNumberOfTouches:1];
    [self.gt_panGesture setCancelsTouchesInView:NO];
    [self setGt_handle:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addGestureRecognizer:self.gt_panGesture];
}

@end
