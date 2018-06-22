//
//  UIBezierPath+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UITextField`.
 */
@interface UIBezierPath (GTKit)

#pragma mark text

/**
 Creates and returns a new UIBezierPath object initialized with the text glyphs
 generated from the specified font.
 
 @discussion It doesnot support apple emoji. If you want get emoji image, try
 [UIImage imageWithEmoji:size:] in `UIImage(YYAdd)`.
 
 @param text The text to generate glyph path.
 @param font The font to generate glyph path.
 
 @return A new path object with the text and font, or nil if an error occurs.
 */
+ (nullable UIBezierPath *)gt_bezierPathWithText:(NSString *)text font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
