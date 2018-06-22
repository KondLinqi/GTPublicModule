//
//  UIView+GTConstraints.h
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GTConstraints)

- (NSLayoutConstraint *)gt_constraintForAttribute:(NSLayoutAttribute)attribute;

- (NSLayoutConstraint *)gt_leftConstraint;
- (NSLayoutConstraint *)gt_rightConstraint;
- (NSLayoutConstraint *)gt_topConstraint;
- (NSLayoutConstraint *)gt_bottomConstraint;
- (NSLayoutConstraint *)gt_leadingConstraint;
- (NSLayoutConstraint *)gt_trailingConstraint;
- (NSLayoutConstraint *)gt_widthConstraint;
- (NSLayoutConstraint *)gt_heightConstraint;
- (NSLayoutConstraint *)gt_centerXConstraint;
- (NSLayoutConstraint *)gt_centerYConstraint;
- (NSLayoutConstraint *)gt_baseLineConstraint;

@end

NS_ASSUME_NONNULL_END
