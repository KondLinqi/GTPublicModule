//
// UITextField+Blocks.m
// UITextFieldBlocks
//
// Created by Håkon Bogen on 19.10.13.
// Copyright (c) 2013 Håkon Bogen. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
#import "UITextField+GTBlocks.h"
#import <objc/runtime.h>
typedef BOOL (^GTUITextFieldReturnBlock) (UITextField *textField);
typedef void (^GTUITextFieldVoidBlock) (UITextField *textField);
typedef BOOL (^GTUITextFieldCharacterChangeBlock) (UITextField *textField, NSRange range, NSString *replacementString);
@implementation UITextField (GTBlocks)
static const void *GTUITextFieldDelegateKey = &GTUITextFieldDelegateKey;
static const void *GTUITextFieldShouldBeginEditingKey = &GTUITextFieldShouldBeginEditingKey;
static const void *GTUITextFieldShouldEndEditingKey = &GTUITextFieldShouldEndEditingKey;
static const void *GTUITextFieldDidBeginEditingKey = &GTUITextFieldDidBeginEditingKey;
static const void *GTUITextFieldDidEndEditingKey = &GTUITextFieldDidEndEditingKey;
static const void *GTUITextFieldShouldChangeCharactersInRangeKey = &GTUITextFieldShouldChangeCharactersInRangeKey;
static const void *GTUITextFieldShouldClearKey = &GTUITextFieldShouldClearKey;
static const void *GTUITextFieldShouldReturnKey = &GTUITextFieldShouldReturnKey;
#pragma mark UITextField Delegate methods
+ (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    GTUITextFieldReturnBlock block = textField.gt_shouldBegindEditingBlock;
    if (block) {
        return block(textField);
    }
    id delegate = objc_getAssociatedObject(self, GTUITextFieldDelegateKey);
    if ([delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [delegate textFieldShouldBeginEditing:textField];
    }
    // return default value just in case
    return YES;
}
+ (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    GTUITextFieldReturnBlock block = textField.gt_shouldEndEditingBlock;
    if (block) {
        return block(textField);
    }
    id delegate = objc_getAssociatedObject(self, GTUITextFieldDelegateKey);
    if ([delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [delegate textFieldShouldEndEditing:textField];
    }
    // return default value just in case
    return YES;
}
+ (void)textFieldDidBeginEditing:(UITextField *)textField
{
   GTUITextFieldVoidBlock block = textField.gt_didBeginEditingBlock;
    if (block) {
        block(textField);
    }
    id delegate = objc_getAssociatedObject(self, GTUITextFieldDelegateKey);
    if ([delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [delegate textFieldDidBeginEditing:textField];
    }
}
+ (void)textFieldDidEndEditing:(UITextField *)textField
{
    GTUITextFieldVoidBlock block = textField.gt_didEndEditingBlock;
    if (block) {
        block(textField);
    }
    id delegate = objc_getAssociatedObject(self, GTUITextFieldDelegateKey);
    if ([delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [delegate textFieldDidBeginEditing:textField];
    }
}
+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    GTUITextFieldCharacterChangeBlock block = textField.gt_shouldChangeCharactersInRangeBlock;
    if (block) {
        return block(textField,range,string);
    }
    id delegate = objc_getAssociatedObject(self, GTUITextFieldDelegateKey);
    if ([delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}
+ (BOOL)textFieldShouldClear:(UITextField *)textField
{
    GTUITextFieldReturnBlock block = textField.gt_shouldClearBlock;
    if (block) {
        return block(textField);
    }
    id delegate = objc_getAssociatedObject(self, GTUITextFieldDelegateKey);
    if ([delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [delegate textFieldShouldClear:textField];
    }
    return YES;
}
+ (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    GTUITextFieldReturnBlock block = textField.gt_shouldReturnBlock;
    if (block) {
        return block(textField);
    }
    id delegate = objc_getAssociatedObject(self, GTUITextFieldDelegateKey);
    if ([delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [delegate textFieldShouldReturn:textField];
    }
    return YES;
}
#pragma mark Block setting/getting methods
- (BOOL (^)(UITextField *))gt_shouldBegindEditingBlock
{
    return objc_getAssociatedObject(self, GTUITextFieldShouldBeginEditingKey);
}
- (void)setGt_shouldBegindEditingBlock:(BOOL (^)(UITextField *))shouldBegindEditingBlock
{
    [self gt_setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, GTUITextFieldShouldBeginEditingKey, shouldBegindEditingBlock, OBJC_ASSOCIATION_COPY);
}
- (BOOL (^)(UITextField *))gt_shouldEndEditingBlock
{
    return objc_getAssociatedObject(self, GTUITextFieldShouldEndEditingKey);
}
- (void)setGt_shouldEndEditingBlock:(BOOL (^)(UITextField *))shouldEndEditingBlock
{
    [self gt_setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, GTUITextFieldShouldEndEditingKey, shouldEndEditingBlock, OBJC_ASSOCIATION_COPY);
}
- (void (^)(UITextField *))gt_didBeginEditingBlock
{
    return objc_getAssociatedObject(self, GTUITextFieldDidBeginEditingKey);
}
- (void)setGt_didBeginEditingBlock:(void (^)(UITextField *))didBeginEditingBlock
{
    [self gt_setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, GTUITextFieldDidBeginEditingKey, didBeginEditingBlock, OBJC_ASSOCIATION_COPY);
}
- (void (^)(UITextField *))gt_didEndEditingBlock
{
    return objc_getAssociatedObject(self, GTUITextFieldDidEndEditingKey);
}
- (void)setGt_didEndEditingBlock:(void (^)(UITextField *))didEndEditingBlock
{
    [self gt_setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, GTUITextFieldDidEndEditingKey, didEndEditingBlock, OBJC_ASSOCIATION_COPY);
}
- (BOOL (^)(UITextField *, NSRange, NSString *))gt_shouldChangeCharactersInRangeBlock
{
    return objc_getAssociatedObject(self, GTUITextFieldShouldChangeCharactersInRangeKey);
}
- (void)setGt_shouldChangeCharactersInRangeBlock:(BOOL (^)(UITextField *, NSRange, NSString *))shouldChangeCharactersInRangeBlock
{
    [self gt_setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, GTUITextFieldShouldChangeCharactersInRangeKey, shouldChangeCharactersInRangeBlock, OBJC_ASSOCIATION_COPY);
}
- (BOOL (^)(UITextField *))gt_shouldReturnBlock
{
    return objc_getAssociatedObject(self, GTUITextFieldShouldReturnKey);
}
- (void)setGt_shouldReturnBlock:(BOOL (^)(UITextField *))shouldReturnBlock
{
    [self gt_setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, GTUITextFieldShouldReturnKey, shouldReturnBlock, OBJC_ASSOCIATION_COPY);
}
- (BOOL (^)(UITextField *))gt_shouldClearBlock
{
    return objc_getAssociatedObject(self, GTUITextFieldShouldClearKey);
}
- (void)setGt_shouldClearBlock:(BOOL (^)(UITextField *textField))shouldClearBlock
{
    [self gt_setDelegateIfNoDelegateSet];
    objc_setAssociatedObject(self, GTUITextFieldShouldClearKey, shouldClearBlock, OBJC_ASSOCIATION_COPY);
}
#pragma mark control method
/*
 Setting itself as delegate if no other delegate has been set. This ensures the UITextField will use blocks if no delegate is set.
 */
- (void)gt_setDelegateIfNoDelegateSet
{
    if (self.delegate != (id<UITextFieldDelegate>)[self class]) {
        objc_setAssociatedObject(self, GTUITextFieldDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = (id<UITextFieldDelegate>)[self class];
    }
}
@end
