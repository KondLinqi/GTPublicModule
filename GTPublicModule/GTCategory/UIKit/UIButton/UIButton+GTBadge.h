//
//  UIBarButtonItem+Badge.h
//  therichest
//
//  Created by Mike on 2014-05-05.
//  Copyright (c) 2014 Valnet Inc. All rights reserved.
//  https://github.com/mikeMTOL/UIBarButtonItem-Badge

#import <UIKit/UIKit.h>

@interface UIButton (GTBadge)

@property (strong, nonatomic) UILabel *gt_badge;

// Badge value to be display
@property (nonatomic) NSString *gt_badgeValue;
// Badge background color
@property (nonatomic) UIColor *gt_badgeBGColor;
// Badge text color
@property (nonatomic) UIColor *gt_badgeTextColor;
// Badge font
@property (nonatomic) UIFont *gt_badgeFont;
// Padding value for the badge
@property (nonatomic) CGFloat gt_badgePadding;
// Minimum size badge to small
@property (nonatomic) CGFloat gt_badgeMinSize;
// Values for offseting the badge over the BarButtonItem you picked
@property (nonatomic) CGFloat gt_badgeOriginX;
@property (nonatomic) CGFloat gt_badgeOriginY;
// In case of numbers, remove the badge when reaching zero
@property BOOL gt_shouldHideBadgeAtZero;
// Badge has a bounce animation when value changes
@property BOOL gt_shouldAnimateBadge;

@end
