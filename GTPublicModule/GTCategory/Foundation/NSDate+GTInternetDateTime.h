//
//  NSDate+GTInternetDateTime.h
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <Foundation/Foundation.h>

// Formatting hints
typedef enum {
    DateFormatHintNone,
    DateFormatHintRFC822,
    DateFormatHintRFC3339
} DateFormatHint;

@interface NSDate (GTInternetDateTime)

// Get date from RFC3339 or RFC822 string
// - A format/specification hint can be used to speed up,
//   otherwise both will be attempted in order to get a date
+ (NSDate *)gt_dateFromInternetDateTimeString:(NSString *)dateString
                                   formatHint:(DateFormatHint)hint;

// Get date from a string using a specific date specification
+ (NSDate *)gt_dateFromRFC3339String:(NSString *)dateString;
+ (NSDate *)gt_dateFromRFC822String:(NSString *)dateString;

@end
