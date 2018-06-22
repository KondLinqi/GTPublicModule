//
//  NSSet+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "NSSet+GTKit.h"

@implementation NSSet (GTKit)

- (void)gt_each:(void (^)(id))block {
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        block(obj);
    }];
}

- (void)gt_eachWithIndex:(void (^)(id, int))block {
    __block int counter = 0;
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        block(obj, counter);
        counter ++;
    }];
}

- (NSArray *)gt_map:(id (^)(id object))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    
    
    for (id object in self) {
        id mappedObject = block(object);
        if(mappedObject) {
            [array addObject:mappedObject];
        }
    }
    
    return array;
}

- (NSArray *)gt_select:(BOOL (^)(id object))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    
    for (id object in self) {
        if (block(object)) {
            [array addObject:object];
        }
    }
    
    return array;
}

- (NSArray *)gt_reject:(BOOL (^)(id object))block {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    
    for (id object in self) {
        if (block(object) == NO) {
            [array addObject:object];
        }
    }
    
    return array;
}

- (NSArray *)gt_sort {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    return [self sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (id)gt_reduce:(id(^)(id accumulator, id object))block {
    return [self gt_reduce:nil withBlock:block];
}

- (id)gt_reduce:(id)initial withBlock:(id(^)(id accumulator, id object))block {
    id accumulator = initial;
    
    for(id object in self)
        accumulator = accumulator ? block(accumulator, object) : object;
    
    return accumulator;
}


@end
