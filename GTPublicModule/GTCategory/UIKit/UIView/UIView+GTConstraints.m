//
//  UIView+GTConstraints.m
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UIView+GTConstraints.h"

@implementation UIView (GTConstraints)

-(NSLayoutConstraint *)gt_constraintForAttribute:(NSLayoutAttribute)attribute {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d && (firstItem = %@ || secondItem = %@)", attribute, self, self];
    NSArray *constraintArray = [self.superview constraints];
    
    if (attribute == NSLayoutAttributeWidth || attribute == NSLayoutAttributeHeight) {
        constraintArray = [self constraints];
    }
    
    NSArray *fillteredArray = [constraintArray filteredArrayUsingPredicate:predicate];
    if(fillteredArray.count == 0) {
        return nil;
    } else {
        return fillteredArray.firstObject;
    }
}

- (NSLayoutConstraint *)gt_leftConstraint {
    return [self gt_constraintForAttribute:NSLayoutAttributeLeft];
}

- (NSLayoutConstraint *)gt_rightConstraint {
    return [self gt_constraintForAttribute:NSLayoutAttributeRight];
}

- (NSLayoutConstraint *)gt_topConstraint {
    return [self gt_constraintForAttribute:NSLayoutAttributeTop];
}

- (NSLayoutConstraint *)gt_bottomConstraint {
    return [self gt_constraintForAttribute:NSLayoutAttributeBottom];
}

- (NSLayoutConstraint *)gt_leadingConstraint {
    return [self gt_constraintForAttribute:NSLayoutAttributeLeading];
}

- (NSLayoutConstraint *)gt_trailingConstraint {
    return [self gt_constraintForAttribute:NSLayoutAttributeTrailing];
}

- (NSLayoutConstraint *)gt_widthConstraint {
    return [self gt_constraintForAttribute:NSLayoutAttributeWidth];
}

- (NSLayoutConstraint *)gt_heightConstraint {
    return [self gt_constraintForAttribute:NSLayoutAttributeHeight];
}

- (NSLayoutConstraint *)gt_centerXConstraint {
    return [self gt_constraintForAttribute:NSLayoutAttributeCenterX];
}

- (NSLayoutConstraint *)gt_centerYConstraint {
    return [self gt_constraintForAttribute:NSLayoutAttributeCenterY];
}

- (NSLayoutConstraint *)gt_baseLineConstraint {
    return [self gt_constraintForAttribute:NSLayoutAttributeBaseline];
}

@end
