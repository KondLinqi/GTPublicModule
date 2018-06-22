//
//  UITextField+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/20.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UITextField+GTKit.h"
#import "GTMacros.h"

@implementation UITextField (GTKit)

#pragma mark - maxLength
///=============================================================================
/// @name maxLength
///=============================================================================

- (NSInteger)gt_maxLength {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setGt_maxLength:(NSInteger)maxLength {
    objc_setAssociatedObject(self, @selector(gt_maxLength), @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    [self addTarget:self action:@selector(gt_textFieldTextDidChange) forControlEvents:UIControlEventEditingChanged];
}

- (void)gt_textFieldTextDidChange {
    NSString *toBeString = self.text;
    //获取高亮部分
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制
    //在iOS7下,position对象总是不为nil
    if ( (!position ||!selectedRange) && (self.gt_maxLength > 0 && toBeString.length > self.gt_maxLength))
    {
        NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.gt_maxLength];
        if (rangeIndex.length == 1)
        {
            self.text = [toBeString substringToIndex:self.gt_maxLength];
        }
        else
        {
            NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.gt_maxLength)];
            NSInteger tmpLength;
            if (rangeRange.length > self.gt_maxLength) {
                tmpLength = rangeRange.length - rangeIndex.length;
            }else{
                tmpLength = rangeRange.length;
            }
            self.text = [toBeString substringWithRange:NSMakeRange(0, tmpLength)];
        }
    }
}

#pragma mark - Select
///=============================================================================
/// @name Select
///=============================================================================

/**
 *  @brief  当前选中的字符串范围
 *
 *  @return NSRange
 */
- (NSRange)gt_selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}
/**
 *  @brief  选中所有文字
 */
- (void)gt_selectAllText {
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}
/**
 *  @brief  选中指定范围的文字
 *
 *  @param range NSRange范围
 */
- (void)gt_setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

#pragma mark - Shake
///=============================================================================
/// @name Shake
///=============================================================================

- (void)gt_shake {
    [self gt_shake:10 withDelta:5 completion:nil];
}

- (void)gt_shake:(int)times withDelta:(CGFloat)delta {
    [self gt_shake:times withDelta:delta completion:nil];
}

- (void)gt_shake:(int)times withDelta:(CGFloat)delta completion:(void(^)(void))handler {
    [self _gt_shake:times direction:1 currentTimes:0 withDelta:delta speed:0.03 shakeDirection:GTShakedDirectionHorizontal completion:handler];
}

- (void)gt_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval {
    [self gt_shake:times withDelta:delta speed:interval completion:nil];
}

- (void)gt_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval completion:(void(^)(void))handler {
    [self _gt_shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:GTShakedDirectionHorizontal completion:handler];
}

- (void)gt_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(GTShakedDirection)shakeDirection {
    [self gt_shake:times withDelta:delta speed:interval shakeDirection:shakeDirection completion:nil];
}

- (void)gt_shake:(int)times withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(GTShakedDirection)shakeDirection completion:(void(^)(void))handler {
    [self _gt_shake:times direction:1 currentTimes:0 withDelta:delta speed:interval shakeDirection:shakeDirection completion:handler];
}

- (void)_gt_shake:(int)times direction:(int)direction currentTimes:(int)current withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(GTShakedDirection)shakeDirection completion:(void(^)(void))handler {
    [UIView animateWithDuration:interval animations:^{
        self.transform = (shakeDirection == GTShakedDirectionHorizontal) ? CGAffineTransformMakeTranslation(delta * direction, 0) : CGAffineTransformMakeTranslation(0, delta * direction);
    } completion:^(BOOL finished) {
        if(current >= times) {
            [UIView animateWithDuration:interval animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (handler) {
                    handler();
                }
            }];
            return;
        }
        [self _gt_shake:(times - 1)
              direction:direction * -1
           currentTimes:current + 1
              withDelta:delta
                  speed:interval
         shakeDirection:shakeDirection
             completion:handler];
    }];
}


@end
