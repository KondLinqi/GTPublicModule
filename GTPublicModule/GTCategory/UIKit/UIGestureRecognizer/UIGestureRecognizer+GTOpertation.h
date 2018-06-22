//
//  UIGestureRecognizer+GTOpertation.h
//  GTKit
//
//  Created by liuxc on 2018/5/18.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GestureOpertation)(UIGestureRecognizer *gesture);

@interface UIGestureRecognizer (GTOpertation)

@property (nonatomic, copy, readonly) GestureOpertation opertation;
@property (nonatomic, copy, readonly) GestureOpertation beganOpertation;
@property (nonatomic, copy, readonly) GestureOpertation changedOpertation;
@property (nonatomic, copy, readonly) GestureOpertation cancelledOpertation;
@property (nonatomic, copy, readonly) GestureOpertation endOpertation;
@property (nonatomic, copy, readonly) GestureOpertation failedOpertation;
@property (nonatomic, copy, readonly) GestureOpertation swipeRightOpertation;
@property (nonatomic, copy, readonly) GestureOpertation swipeLeftOpertation;
@property (nonatomic, copy, readonly) GestureOpertation swipeUpOpertation;
@property (nonatomic, copy, readonly) GestureOpertation swipeDownOpertation;

/**
 *  添加操作,此方法用于点按手势
 *
 *  @param opertation 操作
 *
 *  @return self 可以继续掉后续方法
 */
- (instancetype)addOpertation:(GestureOpertation)opertation;
/**
 *  添加开始操作
 *
 *  @param beganOpertation 操作
 *
 *  @return self 可以继续掉后续方法
 */
- (instancetype)addBeganOpertation:(GestureOpertation)beganOpertation;
/**
 *  添加改变时的操作
 *
 *  @param changedOpertation 操作
 *
 *  @return self 可以继续掉后续方法
 */
- (instancetype)addChangedOpertation:(GestureOpertation)changedOpertation;
/**
 *  添加取消时的操作
 *
 *  @param cancelledOpertation 操作
 *
 *  @return self 可以继续掉后续方法
 */
- (instancetype)addCancelledOpertation:(GestureOpertation)cancelledOpertation;
/**
 *  添加结束时操作
 *
 *  @param endOpertation 操作
 *
 *  @return self 可以继续掉后续方法
 */
- (instancetype)addEndOpertation:(GestureOpertation)endOpertation;
/**
 *  添加失败时的操作
 *
 *  @param failedOpertation 操作
 *
 *  @return self 可以继续掉后续方法
 */
- (instancetype)addFailedOpertation:(GestureOpertation)failedOpertation;

/**
 *  添加向右轻扫时操作
 *
 *  @param swipeRightOpertation 操作
 *
 *  @return self 可以继续掉后续方法
 */
- (instancetype)addSwipeRightOpertation:(GestureOpertation)swipeRightOpertation;
/**
 *  添加向左轻扫时操作
 *
 *  @param swipeLeftOpertation 操作
 *
 *  @return self 可以继续掉后续方法
 */
- (instancetype)addSwipeLeftOpertation:(GestureOpertation)swipeLeftOpertation;
/**
 *  添加向上轻扫时操作
 *
 *  @param swipeUpOpertation 操作
 *
 *  @return self 可以继续掉后续方法
 */
- (instancetype)addSwipeUpOpertation:(GestureOpertation)swipeUpOpertation;
/**
 *  添加向下轻扫时操作
 *
 *  @param swipeDownOpertation 操作
 *
 *  @return self 可以继续掉后续方法
 */
- (instancetype)addSwipeDownOpertation:(GestureOpertation)swipeDownOpertation;


@end
