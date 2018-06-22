//
//  NSIndexPath+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSIndexPath (GTKit)

#pragma mark - Offset
/**
 *
 *  Compute previous row indexpath
 *
 */
- (NSIndexPath *)gt_previousRow;
/**
 *
 *  Compute next row indexpath
 *
 */
- (NSIndexPath *)gt_nextRow;
/**
 *
 *  Compute previous item indexpath
 *
 */
- (NSIndexPath *)gt_previousItem;
/**
 *
 *  Compute next item indexpath
 *
 */
- (NSIndexPath *)gt_nextItem;
/**
 *
 *  Compute next section indexpath
 *
 */
- (NSIndexPath *)gt_nextSection;
/**
 *
 *  Compute previous section indexpath
 *
 */
- (NSIndexPath *)gt_previousSection;


@end

NS_ASSUME_NONNULL_END
