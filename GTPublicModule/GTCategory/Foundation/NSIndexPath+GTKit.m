//
//  NSIndexPath+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "NSIndexPath+GTKit.h"

@implementation NSIndexPath (GTKit)


#pragma mark - Offset
- (NSIndexPath *)gt_previousRow
{
    return [NSIndexPath indexPathForRow:self.row - 1
                              inSection:self.section];
}

- (NSIndexPath *)gt_nextRow
{
    return [NSIndexPath indexPathForRow:self.row + 1
                              inSection:self.section];
}

- (NSIndexPath *)gt_previousItem
{
    return [NSIndexPath indexPathForItem:self.item - 1
                               inSection:self.section];
}


- (NSIndexPath *)gt_nextItem
{
    return [NSIndexPath indexPathForItem:self.item + 1
                               inSection:self.section];
}


- (NSIndexPath *)gt_nextSection
{
    return [NSIndexPath indexPathForRow:self.row
                              inSection:self.section + 1];
}

- (NSIndexPath *)gt_previousSection
{
    return [NSIndexPath indexPathForRow:self.row
                              inSection:self.section - 1];
}


@end


