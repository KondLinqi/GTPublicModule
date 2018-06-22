//
//  NSString+GTEmoji.h
//  GTKit
//
//  Created by liuxc on 2018/5/18.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GTEmoji)

/**
 Returns a NSString in which any occurrences that match the cheat codes
 from Emoji Cheat Sheet <http://www.emoji-cheat-sheet.com> are replaced by the
 corresponding unicode characters.

 Example:
 "This is a smiley face :smiley:"

 Will be replaced with:
 "This is a smiley face \U0001F604"
 */
- (NSString *)gt_stringByReplacingEmojiCheatCodesWithUnicode;

/**
 Returns a NSString in which any occurrences that match the unicode characters
 of the emoji emoticons are replaced by the corresponding cheat codes from
 Emoji Cheat Sheet <http://www.emoji-cheat-sheet.com>.

 Example:
 "This is a smiley face \U0001F604"

 Will be replaced with:
 "This is a smiley face :smiley:"
 */
- (NSString *)gt_stringByReplacingEmojiUnicodeWithCheatCodes;


///移除所有emoji，以“”替换
- (NSString *)gt_removingEmoji;
///移除所有emoji，以“”替换
- (NSString *)gt_stringByRemovingEmoji;
///移除所有emoji，以string替换
- (NSString *)gt_stringByReplaceingEmojiWithString:(NSString*)string;

///字符串是否包含emoji
- (BOOL)gt_containsEmoji;
///字符串中包含的所有emoji unicode格式
- (NSArray<NSString *>*)gt_allEmoji;
///字符串中包含的所有emoji
- (NSString *)gt_allEmojiString;
///字符串中包含的所有emoji rang
- (NSArray<NSString *>*)gt_allEmojiRanges;

///所有emoji表情
+ (NSString*)gt_allSystemEmoji;

@end

@interface NSCharacterSet (GTEmojiCharacterSet)
+ (NSCharacterSet *)gt_emojiCharacterSet;
@end
