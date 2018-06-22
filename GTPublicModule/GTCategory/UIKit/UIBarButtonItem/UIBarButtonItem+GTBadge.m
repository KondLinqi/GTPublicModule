//
//  UIBarButtonItem+Badge.m
//  therichest
//
//  Created by Mike on 2014-05-05.
//  Copyright (c) 2014 Valnet Inc. All rights reserved.
//
#import <objc/runtime.h>
#import "UIBarButtonItem+GTBadge.h"

NSString const *gt_UIBarButtonItem_badgeKey = @"gt_UIBarButtonItem_badgeKey";

NSString const *gt_UIBarButtonItem_badgeBGColorKey = @"gt_UIBarButtonItem_badgeBGColorKey";
NSString const *gt_UIBarButtonItem_badgeTextColorKey = @"gt_UIBarButtonItem_badgeTextColorKey";
NSString const *gt_UIBarButtonItem_badgeFontKey = @"gt_UIBarButtonItem_badgeFontKey";
NSString const *gt_UIBarButtonItem_badgePaddingKey = @"gt_UIBarButtonItem_badgePaddingKey";
NSString const *gt_UIBarButtonItem_badgeMinSizeKey = @"gt_UIBarButtonItem_badgeMinSizeKey";
NSString const *gt_UIBarButtonItem_badgeOriginXKey = @"gt_UIBarButtonItem_badgeOriginXKey";
NSString const *gt_UIBarButtonItem_badgeOriginYKey = @"gt_UIBarButtonItem_badgeOriginYKey";
NSString const *gt_UIBarButtonItem_shouldHideBadgeAtZeroKey = @"gt_UIBarButtonItem_shouldHideBadgeAtZeroKey";
NSString const *gt_UIBarButtonItem_shouldAnimateBadgeKey = @"gt_UIBarButtonItem_shouldAnimateBadgeKey";
NSString const *gt_UIBarButtonItem_badgeValueKey = @"gt_UIBarButtonItem_badgeValueKey";

@implementation UIBarButtonItem (GTBadge)

@dynamic gt_badgeValue, gt_badgeBGColor, gt_badgeTextColor, gt_badgeFont;
@dynamic gt_badgePadding, gt_badgeMinSize, gt_badgeOriginX, gt_badgeOriginY;
@dynamic gt_shouldHideBadgeAtZero, gt_shouldAnimateBadge;

- (void)gt_badgeInit
{
    UIView *superview = nil;
    CGFloat defaultOriginX = 0;
    if (self.customView) {
        superview = self.customView;
        defaultOriginX = superview.frame.size.width - self.gt_badge.frame.size.width/2;
        // Avoids badge to be clipped when animating its scale
        superview.clipsToBounds = NO;
    } else if ([self respondsToSelector:@selector(view)] && [(id)self view]) {
        superview = [(id)self view];
        defaultOriginX = superview.frame.size.width - self.gt_badge.frame.size.width;
    }
    [superview addSubview:self.gt_badge];
    
    // Default design initialization
    self.gt_badgeBGColor   = [UIColor redColor];
    self.gt_badgeTextColor = [UIColor whiteColor];
    self.gt_badgeFont      = [UIFont systemFontOfSize:12.0];
    self.gt_badgePadding   = 6;
    self.gt_badgeMinSize   = 8;
    self.gt_badgeOriginX   = defaultOriginX;
    self.gt_badgeOriginY   = -4;
    self.gt_shouldHideBadgeAtZero = YES;
    self.gt_shouldAnimateBadge = YES;
}

#pragma mark - Utility methods

// Handle badge display when its properties have been changed (color, font, ...)
- (void)gt_refreshBadge
{
    // Change new attributes
    self.gt_badge.textColor        = self.gt_badgeTextColor;
    self.gt_badge.backgroundColor  = self.gt_badgeBGColor;
    self.gt_badge.font             = self.gt_badgeFont;
    
    if (!self.gt_badgeValue || [self.gt_badgeValue isEqualToString:@""] || ([self.gt_badgeValue isEqualToString:@"0"] && self.gt_shouldHideBadgeAtZero)) {
        self.gt_badge.hidden = YES;
    } else {
        self.gt_badge.hidden = NO;
        [self gt_updateBadgeValueAnimated:YES];
    }

}

- (CGSize)gt_badgeExpectedSize
{
    // When the value changes the badge could need to get bigger
    // Calculate expected size to fit new value
    // Use an intermediate label to get expected size thanks to sizeToFit
    // We don't call sizeToFit on the true label to avoid bad display
    UILabel *frameLabel = [self gt_duplicateLabel:self.gt_badge];
    [frameLabel sizeToFit];
    
    CGSize expectedLabelSize = frameLabel.frame.size;
    return expectedLabelSize;
}

- (void)gt_updateBadgeFrame
{

    CGSize expectedLabelSize = [self gt_badgeExpectedSize];
    
    // Make sure that for small value, the badge will be big enough
    CGFloat minHeight = expectedLabelSize.height;
    
    // Using a const we make sure the badge respect the minimum size
    minHeight = (minHeight < self.gt_badgeMinSize) ? self.gt_badgeMinSize : expectedLabelSize.height;
    CGFloat minWidth = expectedLabelSize.width;
    CGFloat padding = self.gt_badgePadding;
    
    // Using const we make sure the badge doesn't get too smal
    minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width;
    self.gt_badge.layer.masksToBounds = YES;
    self.gt_badge.frame = CGRectMake(self.gt_badgeOriginX, self.gt_badgeOriginY, minWidth + padding, minHeight + padding);
    self.gt_badge.layer.cornerRadius = (minHeight + padding) / 2;
}

// Handle the badge changing value
- (void)gt_updateBadgeValueAnimated:(BOOL)animated
{
    // Bounce animation on badge if value changed and if animation authorized
    if (animated && self.gt_shouldAnimateBadge && ![self.gt_badge.text isEqualToString:self.gt_badgeValue]) {
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:[NSNumber numberWithFloat:1.5]];
        [animation setToValue:[NSNumber numberWithFloat:1]];
        [animation setDuration:0.2];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.4f :1.3f :1.f :1.f]];
        [self.gt_badge.layer addAnimation:animation forKey:@"bounceAnimation"];
    }
    
    // Set the new value
    self.gt_badge.text = self.gt_badgeValue;
    
    // Animate the size modification if needed
    if (animated && self.gt_shouldAnimateBadge) {
        [UIView animateWithDuration:0.2 animations:^{
            [self gt_updateBadgeFrame];
        }];
    } else {
        [self gt_updateBadgeFrame];
    }
}

- (UILabel *)gt_duplicateLabel:(UILabel *)labelToCopy
{
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:labelToCopy.frame];
    duplicateLabel.text = labelToCopy.text;
    duplicateLabel.font = labelToCopy.font;
    
    return duplicateLabel;
}

- (void)gt_removeBadge
{
    // Animate badge removal
    [UIView animateWithDuration:0.2 animations:^{
        self.gt_badge.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [self.gt_badge removeFromSuperview];
        self.gt_badge = nil;
    }];
}

#pragma mark - getters/setters
-(UILabel*)gt_badge {
    UILabel* lbl = objc_getAssociatedObject(self, &gt_UIBarButtonItem_badgeKey);
    if(lbl==nil) {
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.gt_badgeOriginX, self.gt_badgeOriginY, 20, 20)];
        [self setGt_badge:lbl];
        [self gt_badgeInit];
        [self.customView addSubview:lbl];
        lbl.textAlignment = NSTextAlignmentCenter;
    }
    return lbl;
}
-(void)setGt_badge:(UILabel *)badgeLabel
{
    objc_setAssociatedObject(self, &gt_UIBarButtonItem_badgeKey, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// Badge value to be display
-(NSString *)gt_badgeValue {
    return objc_getAssociatedObject(self, &gt_UIBarButtonItem_badgeValueKey);
}
-(void)setGt_vadgeValue:(NSString *)badgeValue
{
    objc_setAssociatedObject(self, &gt_UIBarButtonItem_badgeValueKey, badgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // When changing the badge value check if we need to remove the badge
    [self gt_updateBadgeValueAnimated:YES];
    [self gt_refreshBadge];
}

// Badge background color
-(UIColor *)badgeBGColor {
    return objc_getAssociatedObject(self, &gt_UIBarButtonItem_badgeBGColorKey);
}
-(void)setBadgeBGColor:(UIColor *)badgeBGColor
{
    objc_setAssociatedObject(self, &gt_UIBarButtonItem_badgeBGColorKey, badgeBGColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.gt_badge) {
        [self gt_refreshBadge];
    }
}

// Badge text color
-(UIColor *)badgeTextColor {
    return objc_getAssociatedObject(self, &gt_UIBarButtonItem_badgeTextColorKey);
}
-(void)setBadgeTextColor:(UIColor *)badgeTextColor
{
    objc_setAssociatedObject(self, &gt_UIBarButtonItem_badgeTextColorKey, badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.gt_badge) {
        [self gt_refreshBadge];
    }
}

// Badge font
-(UIFont *)badgeFont {
    return objc_getAssociatedObject(self, &gt_UIBarButtonItem_badgeFontKey);
}
-(void)setBadgeFont:(UIFont *)badgeFont
{
    objc_setAssociatedObject(self, &gt_UIBarButtonItem_badgeFontKey, badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.gt_badge) {
        [self gt_refreshBadge];
    }
}

// Padding value for the badge
-(CGFloat) badgePadding {
    NSNumber *number = objc_getAssociatedObject(self, &gt_UIBarButtonItem_badgePaddingKey);
    return number.floatValue;
}
-(void) setBadgePadding:(CGFloat)badgePadding
{
    NSNumber *number = [NSNumber numberWithDouble:badgePadding];
    objc_setAssociatedObject(self, &gt_UIBarButtonItem_badgePaddingKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.gt_badge) {
        [self gt_updateBadgeFrame];
    }
}

// Minimum size badge to small
-(CGFloat)gt_badgeMinSize {
    NSNumber *number = objc_getAssociatedObject(self, &gt_UIBarButtonItem_badgeMinSizeKey);
    return number.floatValue;
}
-(void) setGt_badgeMinSize:(CGFloat)badgeMinSize
{
    NSNumber *number = [NSNumber numberWithDouble:badgeMinSize];
    objc_setAssociatedObject(self, &gt_UIBarButtonItem_badgeMinSizeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.gt_badge) {
        [self gt_updateBadgeFrame];
    }
}

// Values for offseting the badge over the BarButtonItem you picked
-(CGFloat)gt_badgeOriginX {
    NSNumber *number = objc_getAssociatedObject(self, &gt_UIBarButtonItem_badgeOriginXKey);
    return number.floatValue;
}
-(void) setGt_badgeOriginX:(CGFloat)badgeOriginX
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginX];
    objc_setAssociatedObject(self, &gt_UIBarButtonItem_badgeOriginXKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.gt_badge) {
        [self gt_updateBadgeFrame];
    }
}

-(CGFloat)gt_badgeOriginY {
    NSNumber *number = objc_getAssociatedObject(self, &gt_UIBarButtonItem_badgeOriginYKey);
    return number.floatValue;
}
-(void) setGt_badgeOriginY:(CGFloat)badgeOriginY
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginY];
    objc_setAssociatedObject(self, &gt_UIBarButtonItem_badgeOriginYKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.gt_badge) {
        [self gt_updateBadgeFrame];
    }
}

// In case of numbers, remove the badge when reaching zero
-(BOOL) shouldHideBadgeAtZero {
    NSNumber *number = objc_getAssociatedObject(self, &gt_UIBarButtonItem_shouldHideBadgeAtZeroKey);
    return number.boolValue;
}
- (void)setShouldHideBadgeAtZero:(BOOL)shouldHideBadgeAtZero
{
    NSNumber *number = [NSNumber numberWithBool:shouldHideBadgeAtZero];
    objc_setAssociatedObject(self, &gt_UIBarButtonItem_shouldHideBadgeAtZeroKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(self.gt_badge) {
        [self gt_refreshBadge];
    }
}

// Badge has a bounce animation when value changes
-(BOOL) gt_shouldAnimateBadge {
    NSNumber *number = objc_getAssociatedObject(self, &gt_UIBarButtonItem_shouldAnimateBadgeKey);
    return number.boolValue;
}
- (void)setGt_shouldAnimateBadge:(BOOL)shouldAnimateBadge
{
    NSNumber *number = [NSNumber numberWithBool:shouldAnimateBadge];
    objc_setAssociatedObject(self, &gt_UIBarButtonItem_shouldAnimateBadgeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(self.gt_badge) {
        [self gt_refreshBadge];
    }
}


@end
