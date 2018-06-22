//
//  UITextField+Blocks.h
//  GTCategories (https://github.com/shaojiankui/GTCategories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UITextField (GTBlocks)
@property (copy, nonatomic) BOOL (^gt_shouldBegindEditingBlock)(UITextField *textField);
@property (copy, nonatomic) BOOL (^gt_shouldEndEditingBlock)(UITextField *textField);
@property (copy, nonatomic) void (^gt_didBeginEditingBlock)(UITextField *textField);
@property (copy, nonatomic) void (^gt_didEndEditingBlock)(UITextField *textField);
@property (copy, nonatomic) BOOL (^gt_shouldChangeCharactersInRangeBlock)(UITextField *textField, NSRange range, NSString *replacementString);
@property (copy, nonatomic) BOOL (^gt_shouldReturnBlock)(UITextField *textField);
@property (copy, nonatomic) BOOL (^gt_shouldClearBlock)(UITextField *textField);

- (void)setGt_shouldBegindEditingBlock:(BOOL (^)(UITextField *textField))shouldBegindEditingBlock;
- (void)setGt_shouldEndEditingBlock:(BOOL (^)(UITextField *textField))shouldEndEditingBlock;
- (void)setGt_didBeginEditingBlock:(void (^)(UITextField *textField))didBeginEditingBlock;
- (void)setGt_didEndEditingBlock:(void (^)(UITextField *textField))didEndEditingBlock;
- (void)setGt_shouldChangeCharactersInRangeBlock:(BOOL (^)(UITextField *textField, NSRange range, NSString *string))shouldChangeCharactersInRangeBlock;
- (void)setGt_shouldClearBlock:(BOOL (^)(UITextField *textField))shouldClearBlock;
- (void)setGt_shouldReturnBlock:(BOOL (^)(UITextField *textField))shouldReturnBlock;
@end
