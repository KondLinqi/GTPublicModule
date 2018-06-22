//
//  UIBarButtonItem+Badge.m
//  therichest
//
//  Created by Mike on 2014-05-05.
//  Copyright (c) 2014 Valnet Inc. All rights reserved.
//
#import <objc/runtime.h>
#import "UIButton+GTBadge.h"

NSString const *gt_UIButton_badgeKey = @"gt_UIButton_badgeKey";

NSString const *gt_UIButton_badgeBGColorKey = @"gt_UIButton_badgeBGColorKey";
NSString const *gt_UIButton_badgeTextColorKey = @"gt_UIButton_badgeTextColorKey";
NSString const *gt_UIButton_badgeFontKey = @"gt_UIButton_badgeFontKey";
NSString const *gt_UIButton_badgePaddingKey = @"gt_UIButton_badgePaddingKey";
NSString const *gt_UIButton_badgeMinSizeKey = @"gt_UIButton_badgeMinSizeKey";
NSString const *gt_UIButton_badgeOriginXKey = @"gt_UIButton_badgeOriginXKey";
NSString const *gt_UIButton_badgeOriginYKey = @"gt_UIButton_badgeOriginYKey";
NSString const *gt_UIButton_shouldHideBadgeAtZeroKey = @"gt_UIButton_shouldHideBadgeAtZeroKey";
NSString const *gt_UIButton_shouldAnimateBadgeKey = @"gt_UIButton_shouldAnimateBadgeKey";
NSString const *gt_UIButton_badgeValueKey = @"gt_UIButton_badgeValueKey";

@implementation UIButton (GTBadge)

@dynamic gt_badgeValue, gt_badgeBGColor, gt_badgeTextColor, gt_badgeFont;
@dynamic gt_badgePadding, gt_badgeMinSize, gt_badgeOriginX, gt_badgeOriginY;
@dynamic gt_shouldHideBadgeAtZero, gt_shouldAnimateBadge;

- (void)gt_badgeInit
{
    // Default design initialization
    self.gt_badgeBGColor   = [UIColor redColor];
    self.gt_badgeTextColor = [UIColor whiteColor];
    self.gt_badgeFont      = [UIFont systemFontOfSize:12.0];
    self.gt_badgePadding   = 6;
    self.gt_badgeMinSize   = 8;
    self.gt_badgeOriginX   = self.frame.size.width - self.gt_badge.frame.size.width/2;
    self.gt_badgeOriginY   = -4;
    self.gt_shouldHideBadgeAtZero = YES;
    self.gt_shouldAnimateBadge = YES;
    // Avoids badge to be clipped when animating its scale
    self.clipsToBounds = NO;
}

#pragma mark - Utility methods

// Handle badge display when its properties have been changed (color, font, ...)
- (void)gt_refreshBadge
{
    // Change new attributes
    self.gt_badge.textColor        = self.gt_badgeTextColor;
    self.gt_badge.backgroundColor  = self.gt_badgeBGColor;
    self.gt_badge.font             = self.gt_badgeFont;
}

- (CGSize) gt_badgeExpectedSize
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
    self.gt_badge.frame = CGRectMake(self.gt_badgeOriginX, self.gt_badgeOriginY, minWidth + padding, minHeight + padding);
    self.gt_badge.layer.cornerRadius = (minHeight + padding) / 2;
    self.gt_badge.layer.masksToBounds = YES;
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
    NSTimeInterval duration = animated ? 0.2 : 0;
    [UIView animateWithDuration:duration animations:^{
        [self gt_updateBadgeFrame];
    }];
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
    return objc_getAssociatedObject(self, &gt_UIButton_badgeKey);
}
-(void)setGt_badge:(UILabel *)badgeLabel
{
    objc_setAssociatedObject(self, &gt_UIButton_badgeKey, badgeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// Badge value to be display
-(NSString *)gt_badgeValue {
    return objc_getAssociatedObject(self, &gt_UIButton_badgeValueKey);
}
-(void)setGt_badgeValue:(NSString *)badgeValue
{
    objc_setAssociatedObject(self, &gt_UIButton_badgeValueKey, badgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // When changing the badge value check if we need to remove the badge
    if (!badgeValue || [badgeValue isEqualToString:@""] || ([badgeValue isEqualToString:@"0"] && self.gt_shouldHideBadgeAtZero)) {
        [self gt_removeBadge];
    } else if (!self.gt_badge) {
        // Create a new badge because not existing
        self.gt_badge                      = [[UILabel alloc] initWithFrame:CGRectMake(self.gt_badgeOriginX, self.gt_badgeOriginY, 20, 20)];
        self.gt_badge.textColor            = self.gt_badgeTextColor;
        self.gt_badge.backgroundColor      = self.gt_badgeBGColor;
        self.gt_badge.font                 = self.gt_badgeFont;
        self.gt_badge.textAlignment        = NSTextAlignmentCenter;
        [self gt_badgeInit];
        [self addSubview:self.gt_badge];
        [self gt_updateBadgeValueAnimated:NO];
    } else {
        [self gt_updateBadgeValueAnimated:YES];
    }
}

// Badge background color
-(UIColor *)gt_badgeBGColor {
    return objc_getAssociatedObject(self, &gt_UIButton_badgeBGColorKey);
}
-(void)setGt_badgeBGColor:(UIColor *)badgeBGColor
{
    objc_setAssociatedObject(self, &gt_UIButton_badgeBGColorKey, badgeBGColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.gt_badge) {
        [self gt_refreshBadge];
    }
}

// Badge text color
-(UIColor *)gt_badgeTextColor {
    return objc_getAssociatedObject(self, &gt_UIButton_badgeTextColorKey);
}
-(void)setGt_badgeTextColor:(UIColor *)badgeTextColor
{
    objc_setAssociatedObject(self, &gt_UIButton_badgeTextColorKey, badgeTextColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.gt_badge) {
        [self gt_refreshBadge];
    }
}

// Badge font
-(UIFont *)gt_badgeFont {
    return objc_getAssociatedObject(self, &gt_UIButton_badgeFontKey);
}
-(void)setGt_badgeFont:(UIFont *)badgeFont
{
    objc_setAssociatedObject(self, &gt_UIButton_badgeFontKey, badgeFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.gt_badge) {
        [self gt_refreshBadge];
    }
}

// Padding value for the badge
-(CGFloat) gt_badgePadding {
    NSNumber *number = objc_getAssociatedObject(self, &gt_UIButton_badgePaddingKey);
    return number.floatValue;
}
-(void) setGt_badgePadding:(CGFloat)badgePadding
{
    NSNumber *number = [NSNumber numberWithDouble:badgePadding];
    objc_setAssociatedObject(self, &gt_UIButton_badgePaddingKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.gt_badge) {
        [self gt_updateBadgeFrame];
    }
}

// Minimum size badge to small
-(CGFloat) gt_badgeMinSize {
    NSNumber *number = objc_getAssociatedObject(self, &gt_UIButton_badgeMinSizeKey);
    return number.floatValue;
}
-(void) setGt_badgeMinSize:(CGFloat)badgeMinSize
{
    NSNumber *number = [NSNumber numberWithDouble:badgeMinSize];
    objc_setAssociatedObject(self, &gt_UIButton_badgeMinSizeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.gt_badge) {
        [self gt_updateBadgeFrame];
    }
}

// Values for offseting the badge over the BarButtonItem you picked
-(CGFloat) gt_badgeOriginX {
    NSNumber *number = objc_getAssociatedObject(self, &gt_UIButton_badgeOriginXKey);
    return number.floatValue;
}
-(void) setGt_badgeOriginX:(CGFloat)badgeOriginX
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginX];
    objc_setAssociatedObject(self, &gt_UIButton_badgeOriginXKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.gt_badge) {
        [self gt_updateBadgeFrame];
    }
}

-(CGFloat) gt_badgeOriginY {
    NSNumber *number = objc_getAssociatedObject(self, &gt_UIButton_badgeOriginYKey);
    return number.floatValue;
}
-(void) setGt_badgeOriginY:(CGFloat)badgeOriginY
{
    NSNumber *number = [NSNumber numberWithDouble:badgeOriginY];
    objc_setAssociatedObject(self, &gt_UIButton_badgeOriginYKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.gt_badge) {
        [self gt_updateBadgeFrame];
    }
}

// In case of numbers, remove the badge when reaching zero
-(BOOL) gt_shouldHideBadgeAtZero {
    NSNumber *number = objc_getAssociatedObject(self, &gt_UIButton_shouldHideBadgeAtZeroKey);
    return number.boolValue;
}
- (void)setGt_shouldHideBadgeAtZero:(BOOL)shouldHideBadgeAtZero
{
    NSNumber *number = [NSNumber numberWithBool:shouldHideBadgeAtZero];
    objc_setAssociatedObject(self, &gt_UIButton_shouldHideBadgeAtZeroKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// Badge has a bounce animation when value changes
-(BOOL) gt_shouldAnimateBadge {
    NSNumber *number = objc_getAssociatedObject(self, &gt_UIButton_shouldAnimateBadgeKey);
    return number.boolValue;
}
- (void)setGt_shouldAnimateBadge:(BOOL)shouldAnimateBadge
{
    NSNumber *number = [NSNumber numberWithBool:shouldAnimateBadge];
    objc_setAssociatedObject(self, &gt_UIButton_shouldAnimateBadgeKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
