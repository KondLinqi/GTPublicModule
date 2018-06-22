//
//  NSString+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/18.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "NSString+GTKit.h"
#import "NSData+GTKit.h"
#import "NSNumber+GTKit.h"

@implementation NSString (GTKit)

#pragma mark - Hash

- (NSString *)gt_md2String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] gt_md2String];
}

- (NSString *)gt_md4String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] gt_md4String];
}

- (NSString *)gt_md5String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] gt_md5String];
}

- (NSString *)gt_sha1String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] gt_sha1String];
}

- (NSString *)gt_sha224String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] gt_sha224String];
}

- (NSString *)gt_sha256String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] gt_sha256String];
}

- (NSString *)gt_sha384String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] gt_sha384String];
}

- (NSString *)gt_sha512String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] gt_sha512String];
}

- (NSString *)gt_crc32String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] gt_crc32String];
}

- (NSString *)gt_hmacMD5StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            gt_hmacMD5StringWithKey:key];
}

- (NSString *)gt_hmacSHA1StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            gt_hmacSHA1StringWithKey:key];
}

- (NSString *)gt_hmacSHA224StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            gt_hmacSHA224StringWithKey:key];
}

- (NSString *)gt_hmacSHA256StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            gt_hmacSHA256StringWithKey:key];
}

- (NSString *)gt_hmacSHA384StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            gt_hmacSHA384StringWithKey:key];
}

- (NSString *)gt_hmacSHA512StringWithKey:(NSString *)key {
    return [[self dataUsingEncoding:NSUTF8StringEncoding]
            gt_hmacSHA512StringWithKey:key];
}

#pragma mark - Encode and decode

- (NSString *)gt_base64EncodedString {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] gt_base64EncodedString];
}


+ (NSString *)gt_stringWithBase64EncodedString:(NSString *)base64EncodedString {
    NSData *data = [NSData gt_dataWithBase64EncodedString:base64EncodedString];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/**
 Returns an NSString for base64 decoded.
 */
- (nullable NSString *)gt_base64DecodedString {
    return [NSString gt_stringWithBase64EncodedString:self];
}

- (nullable NSData *)gt_base64DecodedData {
    return [NSData gt_dataWithBase64EncodedString:self];
}

- (NSString *)gt_stringByURLEncode {
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        /**
         AFNetworking/AFURLRequestSerialization.m

         Returns a percent-escaped string following RFC 3986 for a query string key or value.
         RFC 3986 states that the following characters are "reserved" characters.
         - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
         - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
         In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
         query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
         should be percent-escaped in the query string.
         - parameter string: The string to be percent-escaped.
         - returns: The percent-escaped string.
         */
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";

        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;

        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;

        while (index < self.length) {
            NSUInteger length = MIN(self.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            // To avoid breaking up character sequences such as 👴🏻👮🏽
            range = [self rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [self substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];

            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)self,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)gt_stringByURLDecode {
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                NULL,
                                                                (__bridge CFStringRef)decoded,
                                                                CFSTR(""),
                                                                en);
        return decoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)gt_stringByEscapingHTML {
    NSUInteger len = self.length;
    if (!len) return self;

    unichar *buf = malloc(sizeof(unichar) * len);
    if (!buf) return self;
    [self getCharacters:buf range:NSMakeRange(0, len)];

    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < len; i++) {
        unichar c = buf[i];
        NSString *esc = nil;
        switch (c) {
            case 34: esc = @"&quot;"; break;
            case 38: esc = @"&amp;"; break;
            case 39: esc = @"&apos;"; break;
            case 60: esc = @"&lt;"; break;
            case 62: esc = @"&gt;"; break;
            default: break;
        }
        if (esc) {
            [result appendString:esc];
        } else {
            CFStringAppendCharacters((CFMutableStringRef)result, &c, 1);
        }
    }
    free(buf);
    return result;
}


- (NSDictionary *)gt_dictionaryValue {
    NSError *errorJson;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&errorJson];
    if (errorJson != nil) {
#ifdef DEBUG
        NSLog(@"fail to get dictioanry from JSON: %@, error: %@", self, errorJson);
#endif
    }
    return jsonDict;
}

#pragma mark - Drawing

- (CGSize)gt_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (CGFloat)gt_widthForFont:(UIFont *)font {
    CGSize size = [self gt_sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)gt_heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self gt_sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

#pragma mark - Regular Expression

- (BOOL)gt_matchesRegex:(NSString *)regex options:(NSRegularExpressionOptions)options {
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:NULL];
    if (!pattern) return NO;
    return ([pattern numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)] > 0);
}

- (void)gt_enumerateRegexMatches:(NSString *)regex
                      options:(NSRegularExpressionOptions)options
                   usingBlock:(void (^)(NSString *match, NSRange matchRange, BOOL *stop))block {
    if (regex.length == 0 || !block) return;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!regex) return;
    [pattern enumerateMatchesInString:self options:kNilOptions range:NSMakeRange(0, self.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        block([self substringWithRange:result.range], result.range, stop);
    }];
}

- (NSString *)gt_stringByReplacingRegex:(NSString *)regex
                             options:(NSRegularExpressionOptions)options
                          withString:(NSString *)replacement; {
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!pattern) return self;
    return [pattern stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:replacement];
}


- (char) gt_charValue {
    return self.gt_numberValue.charValue;
}

- (unsigned char) gt_unsignedCharValue {
    return self.gt_numberValue.unsignedCharValue;
}

- (short) gt_shortValue {
    return self.gt_numberValue.shortValue;
}

- (unsigned short) gt_unsignedShortValue {
    return self.gt_numberValue.unsignedShortValue;
}

- (unsigned int) gt_unsignedIntValue {
    return self.gt_numberValue.unsignedIntValue;
}

- (long) gt_longValue {
    return self.gt_numberValue.longValue;
}

- (unsigned long) gt_unsignedLongValue {
    return self.gt_numberValue.unsignedLongValue;
}

- (unsigned long long) gt_unsignedLongLongValue {
    return self.gt_numberValue.unsignedLongLongValue;
}

- (NSUInteger) gt_unsignedIntegerValue {
    return self.gt_numberValue.unsignedIntegerValue;
}

#pragma mark - Pinyin
- (NSString*)gt_pinyinWithPhoneticSymbol{
    NSMutableString *pinyin = [NSMutableString stringWithString:self];
    CFStringTransform((__bridge CFMutableStringRef)(pinyin), NULL, kCFStringTransformMandarinLatin, NO);
    return pinyin;
}

- (NSString*)gt_pinyin{
    NSMutableString *pinyin = [NSMutableString stringWithString:[self gt_pinyinWithPhoneticSymbol]];
    CFStringTransform((__bridge CFMutableStringRef)(pinyin), NULL, kCFStringTransformStripCombiningMarks, NO);
    return pinyin;
}

- (NSArray*)gt_pinyinArray{
    NSArray *array = [[self gt_pinyin] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return array;
}

- (NSString*)gt_pinyinWithoutBlank{
    NSMutableString *string = [NSMutableString stringWithString:@""];
    for (NSString *str in [self gt_pinyinArray]) {
        [string appendString:str];
    }
    return string;
}

- (NSArray*)gt_pinyinInitialsArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in [self gt_pinyinArray]) {
        if ([str length] > 0) {
            [array addObject:[str substringToIndex:1]];
        }
    }
    return array;
}

- (NSString*)gt_pinyinInitialsString{
    NSMutableString *pinyin = [NSMutableString stringWithString:@""];
    for (NSString *str in [self gt_pinyinArray]) {
        if ([str length] > 0) {
            [pinyin appendString:[str substringToIndex:1]];
        }
    }
    return pinyin;
}

#pragma mark - URLEncode
///=============================================================================
/// @name URLEncode
///=============================================================================
/**
 *  @brief  urlEncode
 *
 *  @return urlEncode 后的字符串
 */
- (NSString *)gt_urlEncode {
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}

/**
 *  @brief  urlDecode
 *
 *  @return urlDecode 后的字符串
 */
- (NSString *)gt_urlDecode {
    return [self stringByRemovingPercentEncoding];
}

/**
 *  @brief  url query转成NSDictionary
 *
 *  @return NSDictionary
 */
- (NSDictionary *)gt_dictionaryFromURLParameters
{
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
//        NSString *val = [[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[kv objectAtIndex:1] stringByRemovingPercentEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}




#pragma mark - Utilities
///=============================================================================
/// @name Utilities
///=============================================================================
+ (NSString *)gt_stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

+ (NSString *)gt_UUIDTimestamp
{
    return  [[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]*1000] stringValue];
}

+ (NSString *)gt_stringWithUTF32Char:(UTF32Char)char32 {
    char32 = NSSwapHostIntToLittle(char32);
    return [[NSString alloc] initWithBytes:&char32 length:4 encoding:NSUTF32LittleEndianStringEncoding];
}

+ (NSString *)gt_stringWithUTF32Chars:(const UTF32Char *)char32 length:(NSUInteger)length {
    return [[NSString alloc] initWithBytes:(const void *)char32
                                    length:length * 4
                                  encoding:NSUTF32LittleEndianStringEncoding];
}

- (void)gt_enumerateUTF32CharInRange:(NSRange)range usingBlock:(void (^)(UTF32Char char32, NSRange range, BOOL *stop))block {
    NSString *str = self;
    if (range.location != 0 || range.length != self.length) {
        str = [self substringWithRange:range];
    }
    NSUInteger len = [str lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4;
    UTF32Char *char32 = (UTF32Char *)[str cStringUsingEncoding:NSUTF32LittleEndianStringEncoding];
    if (len == 0 || char32 == NULL) return;

    NSUInteger location = 0;
    BOOL stop = NO;
    NSRange subRange;
    UTF32Char oneChar;

    for (NSUInteger i = 0; i < len; i++) {
        oneChar = char32[i];
        subRange = NSMakeRange(location, oneChar > 0xFFFF ? 2 : 1);
        block(oneChar, subRange, &stop);
        if (stop) return;
        location += subRange.length;
    }
}

- (NSString *)gt_stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (NSString *)gt_stringByAppendingNameScale:(CGFloat)scale {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) return self.copy;
    return [self stringByAppendingFormat:@"@%@x", @(scale)];
}

- (NSString *)gt_stringByAppendingPathScale:(CGFloat)scale {
    if (fabs(scale - 1) <= __FLT_EPSILON__ || self.length == 0 || [self hasSuffix:@"/"]) return self.copy;
    NSString *ext = self.pathExtension;
    NSRange extRange = NSMakeRange(self.length - ext.length, 0);
    if (ext.length > 0) extRange.location -= 1;
    NSString *scaleStr = [NSString stringWithFormat:@"@%@x", @(scale)];
    return [self stringByReplacingCharactersInRange:extRange withString:scaleStr];
}

- (CGFloat)gt_pathScale {
    if (self.length == 0 || [self hasSuffix:@"/"]) return 1;
    NSString *name = self.stringByDeletingPathExtension;
    __block CGFloat scale = 1;
    [name gt_enumerateRegexMatches:@"@[0-9]+\\.?[0-9]*x$" options:NSRegularExpressionAnchorsMatchLines usingBlock: ^(NSString *match, NSRange matchRange, BOOL *stop) {
        scale = [match substringWithRange:NSMakeRange(1, match.length - 2)].doubleValue;
    }];
    return scale;
}

- (BOOL)gt_isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)gt_isContainChinese
{
    NSUInteger length = [self length];
    for (NSUInteger i = 0; i < length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)gt_containsString:(NSString *)string {
    if (string == nil) return NO;
    return [self rangeOfString:string].location != NSNotFound;
}

- (BOOL)gt_containsCharacterSet:(NSCharacterSet *)set {
    if (set == nil) return NO;
    return [self rangeOfCharacterFromSet:set].location != NSNotFound;
}

//Unicode编码的字符串转成NSString
- (NSString *)gt_UnicodeToString
{
    NSString *tempStr1 = [self stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    //NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];

    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];

    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (NSNumber *)gt_numberValue {
    return [NSNumber gt_numberWithString:self];
}

- (NSData *)gt_dataValue {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSRange)gt_rangeOfAll {
    return NSMakeRange(0, self.length);
}

- (id)gt_jsonValueDecoded {
    return [[self gt_dataValue] gt_jsonValueDecoded];
}

+ (NSString *)gt_stringNamed:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    if (!str) {
        path = [[NSBundle mainBundle] pathForResource:name ofType:@"txt"];
        str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    }
    return str;
}

+ (NSString *)gt_reverseString:(NSString *)strSrc
{
    NSMutableString* reverseString = [[NSMutableString alloc] init];
    NSInteger charIndex = [strSrc length];
    while (charIndex > 0) {
        charIndex --;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reverseString appendString:[strSrc substringWithRange:subStrRange]];
    }
    return reverseString;
}

@end


