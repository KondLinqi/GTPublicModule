//
//  UITextView+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/20.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UITextView+GTKit.h"
#import <objc/runtime.h>
#import "GTMacros.h"
@implementation UITextView (GTKit)

#pragma mark - placeHolder
///=============================================================================
/// @name placeHolder
///=============================================================================
- (UITextView *)gt_placeHolderTextView {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setGt_placeHolderTextView:(UITextView *)placeHolderTextView {
    objc_setAssociatedObject(self, @selector(gt_placeHolderTextView), placeHolderTextView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)gt_addPlaceHolder:(NSString *)placeHolder {
    if (![self gt_placeHolderTextView]) {
        UITextView *textView = [[UITextView alloc] initWithFrame:self.bounds];
        textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        textView.font = self.font;
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [UIColor grayColor];
        textView.userInteractionEnabled = NO;
        textView.text = placeHolder;
        [self addSubview:textView];
        [self setGt_placeHolderTextView:textView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];
        
    }
    self.gt_placeHolderTextView.text = placeHolder;
}

#pragma mark - maxLength
///=============================================================================
/// @name maxLength
///=============================================================================

- (NSInteger)gt_maxLength {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (void)setGt_maxLength:(NSInteger)maxLength {
    objc_setAssociatedObject(self, @selector(gt_maxLength), @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewTextDidChange:)
                                                name:@"UITextViewTextDidChangeNotification" object:self];
    
}



#pragma mark - SelectedRange
///=============================================================================
/// @name maxLength
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

#pragma mark - PinchZoom
///=============================================================================
/// @name PinchZoom
///=============================================================================


- (void)setGt_maxFontSize:(CGFloat)maxFontSize
{
    objc_setAssociatedObject(self, @selector(gt_maxFontSize), [NSNumber numberWithFloat:maxFontSize],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)gt_maxFontSize
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setGt_minFontSize:(CGFloat)maxFontSize
{
    objc_setAssociatedObject(self, @selector(gt_minFontSize), [NSNumber numberWithFloat:maxFontSize],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)gt_minFontSize
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)pinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer
{
    if (!self.gt_zoomEnabled) return;
    
    CGFloat pointSize = (gestureRecognizer.velocity > 0.0f ? 1.0f : -1.0f) + self.font.pointSize;
    
    pointSize = MAX(MIN(pointSize, self.gt_maxFontSize), self.gt_minFontSize);
    
    self.font = [UIFont fontWithName:self.font.fontName size:pointSize];
}


- (void)setGt_zoomEnabled:(BOOL)zoomEnabled
{
    objc_setAssociatedObject(self, @selector(gt_zoomEnabled), [NSNumber numberWithBool:zoomEnabled],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (zoomEnabled) {
        for (UIGestureRecognizer *recognizer in self.gestureRecognizers) // initialized already
            if ([recognizer isKindOfClass:[UIPinchGestureRecognizer class]]) return;
        
        self.gt_minFontSize = self.gt_minFontSize ?: 8.0f;
        self.gt_maxFontSize = self.gt_maxFontSize ?: 42.0f;
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]
                                                     initWithTarget:self action:@selector(pinchGesture:)];
        [self addGestureRecognizer:pinchRecognizer];
#if !__has_feature(objc_arc)
        [pinchRecognizer release];
#endif
    }
}

- (BOOL)gt_zoomEnabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}



#pragma mark - UITextViewDelegate
///=============================================================================
/// @name UITextViewDelegate
///=============================================================================
- (void)textViewDidBeginEditing:(NSNotification *)noti {
    self.gt_placeHolderTextView.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)noti {
    if (self.text && [self.text isEqualToString:@""]) {
        self.gt_placeHolderTextView.hidden = NO;
    }
}

- (void)textViewTextDidChange:(NSNotification *)notification {
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
