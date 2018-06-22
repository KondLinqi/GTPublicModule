//
//  UIButton+countDown.h
//  NetworkEgOc
//
//  Created by iosdev on 15/3/17.
//  Copyright (c) 2015年 iosdev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GTButtonCountDownBlock)(NSInteger currentTime);

@interface UIButton (GTCountDown)

@property (nonatomic, copy) void(^timeStoppedCallback)(void);


/**
 倒计时：带 title，返回时间，title

 @param timeout 倒计时时间
 @param tittle 默认显示的title
 @param waitTittle 倒计时的title 可选，传nil默认为 @"%zd"
 */
- (void)gt_startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle;


/**
 倒计时：带 title，返回时间，title

 @param duration 倒计时时间
 @param format 可选，传nil默认为 @"%zd秒"
 */
- (void)gt_countDownWithTimeInterval:(NSTimeInterval)duration
                     countDownFormat:(NSString *)format;

/**
 倒计时：返回当前时间，可以自定义 title 和 image

 @param duration 倒计时时间
 @param block 返回当前时间
 */
- (void)gt_countDownCustomWithTimeInterval:(NSTimeInterval)duration
                                     block:(GTButtonCountDownBlock)block;

/**
 * 倒计时：结束，取消倒计时
 */
- (void)gt_cancelTimer;

@end
