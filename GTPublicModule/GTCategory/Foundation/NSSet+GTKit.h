//
//  NSSet+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSSet (GTKit)

- (void)gt_each:(void (^)(id))block;
- (void)gt_eachWithIndex:(void (^)(id, int))block;
- (NSArray *)gt_map:(id (^)(id object))block;
- (NSArray *)gt_select:(BOOL (^)(id object))block;
- (NSArray *)gt_reject:(BOOL (^)(id object))block;
- (NSArray *)gt_sort;
- (id)gt_reduce:(id(^)(id accumulator, id object))block;
- (id)gt_reduce:(id __nullable)initial withBlock:(id(^)(id accumulator, id object))block;

@end

NS_ASSUME_NONNULL_END
