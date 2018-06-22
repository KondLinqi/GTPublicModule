//
//  UIResponder+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/20.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UIResponder+GTKit.h"

static __weak id gt_currentFirstResponder;

@implementation UIResponder (GTKit)

/**
 *  @brief  响应者链
 *
 *  @return  响应者链
 */
- (NSString *)gt_responderChainDescription
{
    NSMutableArray *responderChainStrings = [NSMutableArray array];
    [responderChainStrings addObject:[self class]];
    UIResponder *nextResponder = self;
    while ((nextResponder = [nextResponder nextResponder])) {
        [responderChainStrings addObject:[nextResponder class]];
    }
    __block NSString *returnString = @"Responder Chain:\n";
    __block int tabCount = 0;
    [responderChainStrings enumerateObjectsWithOptions:NSEnumerationReverse
                                            usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                if (tabCount) {
                                                    returnString = [returnString stringByAppendingString:@"|"];
                                                    for (int i = 0; i < tabCount; i++) {
                                                        returnString = [returnString stringByAppendingString:@"----"];
                                                    }
                                                    returnString = [returnString stringByAppendingString:@" "];
                                                }
                                                else {
                                                    returnString = [returnString stringByAppendingString:@"| "];
                                                }
                                                returnString = [returnString stringByAppendingFormat:@"%@ (%@)\n", obj, @(idx)];
                                                tabCount++;
                                            }];
    return returnString;
}

/**
 *  @brief  当前第一响应者
 *
 *  @return 当前第一响应者
 */
+ (id)gt_currentFirstResponder {
    gt_currentFirstResponder = nil;
    
    [[UIApplication sharedApplication] sendAction:@selector(gt_findCurrentFirstResponder:) to:nil from:nil forEvent:nil];
    
    return gt_currentFirstResponder;
}

- (void)gt_findCurrentFirstResponder:(id)sender {
    gt_currentFirstResponder = self;
}


@end
