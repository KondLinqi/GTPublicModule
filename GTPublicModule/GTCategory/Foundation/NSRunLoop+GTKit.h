//
//  NSRunLoop+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const NSRunloopTimeoutException;

@interface NSRunLoop (GTKit)

/* 使用
 - (void)testPerformBlockAndWait
 {
 // 1
 __block BOOL flag = NO;
 
 [[NSRunLoop currentRunLoop] performBlockAndWait:^(BOOL *finish) {
 double delayInSeconds = 2.0;
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
 dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 dispatch_after(popTime, queue, ^(void){
 // 2
 flag = YES;
 *finish = YES;
 });
 }];
 
 // 3
 XCTAssertTrue(flag);
 }
 */

/**
 *
 *  @brief   extension of NSRunLoop for waiting.
 *
 *  param block
 */
- (void)gt_performBlockAndWait:(void (^)(BOOL *finish))block;
/**
 *
 *  @brief   extension of NSRunLoop for waiting.
 *
 *  param block
 */
- (void)gt_performBlockAndWait:(void (^)(BOOL *finish))block timeoutInterval:(NSTimeInterval)timeoutInterval;

@end

NS_ASSUME_NONNULL_END
