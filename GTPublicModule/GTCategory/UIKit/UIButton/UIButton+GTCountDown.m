//
//  UIButton+countDown.m
//  NetworkEgOc
//
//  Created by iosdev on 15/3/17.
//  Copyright (c) 2015年 iosdev. All rights reserved.
//

#import "UIButton+GTCountDown.h"
#import <objc/runtime.h>

@interface UIButton()

@property (nonatomic, assign) NSTimeInterval leaveTime;
@property (nonatomic, copy) NSString *normalTitle;
@property (nonatomic, copy) NSString *countDownFormat;
@property (nonatomic, strong) dispatch_source_t timer;


@end

@implementation UIButton (GTCountDown)



- (void)setTimer:(dispatch_source_t)timer {
    objc_setAssociatedObject(self, @selector(timer), timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (dispatch_source_t)timer {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLeaveTime:(NSTimeInterval)leaveTime {
    objc_setAssociatedObject(self, @selector(leaveTime), @(leaveTime), OBJC_ASSOCIATION_COPY);
}

- (NSTimeInterval)leaveTime {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setNormalTitle:(NSString *)normalTitle {
    objc_setAssociatedObject(self, @selector(normalTitle), normalTitle, OBJC_ASSOCIATION_COPY);
}

- (NSString *)normalTitle {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCountDownFormat:(NSString *)countDownFormat {
    objc_setAssociatedObject(self, @selector(countDownFormat), countDownFormat, OBJC_ASSOCIATION_COPY);
}

- (NSString *)countDownFormat {
    return objc_getAssociatedObject(self, _cmd);;
}

- (void)setTimeStoppedCallback:(void (^)(void))timeStoppedCallback {
    objc_setAssociatedObject(self, @selector(timeStoppedCallback), timeStoppedCallback, OBJC_ASSOCIATION_COPY);
}

- (void (^)(void))timeStoppedCallback {
    return objc_getAssociatedObject(self, _cmd);;
}

#pragma mark - public
/**
 倒计时：带 title，返回时间，title

 @param timeout 倒计时时间
 @param tittle 默认显示的title
 @param waitTittle 倒计时的title 可选，传nil默认为 @"%zd"
 */
-(void)gt_startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle{
    __block NSInteger timeOut=timeout; //倒计时时间
    self.normalTitle = self.titleLabel.text;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    __weak __typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        if(timeOut<=0){ //倒计时结束，关闭
            dispatch_source_cancel(weakSelf.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:tittle forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeOut % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [self setTitle:[NSString stringWithFormat:@"%@%@",strTime,waitTittle] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
                
            });
            timeOut--;
            
        }
    });
    dispatch_resume(self.timer);
    
}


/**
 倒计时：带 title，返回时间，title，具体使用看 demo

 @param duration 倒计时时间
 @param format 可选，传nil默认为 @"%zd秒"
 */
- (void)gt_countDownWithTimeInterval:(NSTimeInterval)duration
                     countDownFormat:(NSString *)format
{
    if (!format)
    {
        self.countDownFormat = @"%zd秒";
    }
    else
    {
        self.countDownFormat = format;
    }
    self.normalTitle = self.titleLabel.text;
    __block NSInteger timeOut = duration; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    __weak __typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        __strong __typeof(self) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (timeOut <= 0) { // 倒计时结束，关闭
                [strongSelf gt_cancelTimer];
            } else {
                NSString *title = [NSString stringWithFormat:self.countDownFormat, timeOut];
                [self setTitle:title forState:UIControlStateNormal];
                timeOut--;
            }
        });
    });
    dispatch_resume(self.timer);
}

/**
 倒计时：返回当前时间，可以自定义 title 和 image，具体使用看 demo

 @param duration 倒计时时间
 @param block 返回当前时间
 */
- (void)gt_countDownCustomWithTimeInterval:(NSTimeInterval)duration block:(GTButtonCountDownBlock)block {
    __block NSInteger timeOut = duration; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    __weak __typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.timer, ^{
        __strong __typeof(self) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block)
            {
                block(timeOut);
            }
            if (timeOut <= 0)
            {
                // 倒计时结束，关闭
                [strongSelf gt_cancelTimer];
            }
            else
            {
                timeOut--;
            }
        });

    });
    dispatch_resume(self.timer);
}

- (void)gt_cancelTimer {
    if (!self.timer) {
        return;
    }
    __weak __typeof(self) weakSelf  = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong __typeof(self) strongSelf = weakSelf;
        dispatch_source_cancel(strongSelf.timer);
        self.timer = nil;
        // 设置界面的按钮显示 根据自己需求设置
        [self setTitle:self.normalTitle forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;
        if (self.timeStoppedCallback) { self.timeStoppedCallback(); }
    });
}

@end
