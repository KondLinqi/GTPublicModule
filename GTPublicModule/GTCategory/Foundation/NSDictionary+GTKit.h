//
//  NSDictionary+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/18.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provide some some common method for `NSDictionary`.
 */
@interface NSDictionary (GTKit)

#pragma mark - Dictionary Convertor
///=============================================================================
/// @name Dictionary Convertor
///=============================================================================

/**
 Creates and returns a dictionary from a specified property list data.
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the binary plist data, or nil if an error occurs.
 */
+ (nullable NSDictionary *)gt_dictionaryWithPlistData:(NSData *)plist;

/**
 Creates and returns a dictionary from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (nullable NSDictionary *)gt_dictionaryWithPlistString:(NSString *)plist;

/**
 Serialize the dictionary to a binary property list data.
 
 @return A binary plist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
- (nullable NSData *)gt_plistData;

/**
 Serialize the dictionary to a xml property list string.
 
 @return A plist xml string, or nil if an error occurs.
 */
- (nullable NSString *)gt_plistString;

/**
 Returns a new array containing the dictionary's keys sorted.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)gt_allKeysSorted;

/**
 Returns a new array containing the dictionary's values sorted by keys.
 
 The order of the values in the array is defined by keys.
 The keys should be NSString, and they will be sorted ascending.
 
 @return A new array containing the dictionary's values sorted by keys,
 or an empty array if the dictionary has no entries.
 */
- (NSArray *)gt_allValuesSortedByKeys;

/**
 Returns a BOOL value tells if the dictionary has an object for key.
 
 @param key The key.
 */
- (BOOL)gt_containsObjectForKey:(id)key;

/**
 Returns a new dictionary containing the entries for keys.
 If the keys is empty or nil, it just returns an empty dictionary.
 
 @param keys The keys.
 @return The entries for the keys.
 */
- (NSDictionary *)gt_entriesForKeys:(NSArray *)keys;

/**
 Convert dictionary to json string. return nil if an error occurs.
 */
- (nullable NSString *)gt_jsonStringEncoded;

/**
 Convert dictionary to json string formatted. return nil if an error occurs.
 */
- (nullable NSString *)gt_jsonPrettyStringEncoded;

/**
 *  @brief NSDictionary转换成JSON字符串
 *
 *  @return  JSON字符串
 */
-(NSString *)gt_jsonString;

/**
 Try to parse an XML and wrap it into a dictionary.
 If you just want to get some value from a small xml, try this.
 
 example XML: "<config><a href="test.com">link</a></config>"
 example Return: @{@"_name":@"config", @"a":{@"_text":@"link",@"href":@"test.com"}}
 
 @param xmlDataOrString XML in NSData or NSString format.
 @return Return a new dictionary, or nil if an error occurs.
 */
+ (nullable NSDictionary *)gt_dictionaryWithXML:(id)xmlDataOrString;

/**
 *  @brief  将url参数转换成NSDictionary
 *
 *  @param query url参数
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)gt_dictionaryWithURLQuery:(NSString *)query;
/**
 *  @brief  将NSDictionary转换成url 参数字符串
 *
 *  @return url 参数字符串
 */
- (NSString *)gt_URLQueryString;

#pragma mark - Dictionary Value Getter
///=============================================================================
/// @name Dictionary Value Getter
///=============================================================================

- (BOOL)gt_boolValueForKey:(NSString *)key default:(BOOL)def;

- (char)gt_charValueForKey:(NSString *)key default:(char)def;
- (unsigned char)gt_unsignedCharValueForKey:(NSString *)key default:(unsigned char)def;

- (short)gt_shortValueForKey:(NSString *)key default:(short)def;
- (unsigned short)gt_unsignedShortValueForKey:(NSString *)key default:(unsigned short)def;

- (int)gt_intValueForKey:(NSString *)key default:(int)def;
- (unsigned int)gt_unsignedIntValueForKey:(NSString *)key default:(unsigned int)def;

- (long)gt_longValueForKey:(NSString *)key default:(long)def;
- (unsigned long)gt_unsignedLongValueForKey:(NSString *)key default:(unsigned long)def;

- (long long)gt_longLongValueForKey:(NSString *)key default:(long long)def;
- (unsigned long long)gt_unsignedLongLongValueForKey:(NSString *)key default:(unsigned long long)def;

- (float)gt_floatValueForKey:(NSString *)key default:(float)def;
- (double)gt_doubleValueForKey:(NSString *)key default:(double)def;

- (NSInteger)gt_integerValueForKey:(NSString *)key default:(NSInteger)def;
- (NSUInteger)gt_unsignedIntegerValueForKey:(NSString *)key default:(NSUInteger)def;

- (nullable NSNumber *)gt_numberValueForKey:(NSString *)key default:(nullable NSNumber *)def;
- (nullable NSString *)gt_stringValueForKey:(NSString *)key default:(nullable NSString *)def;

@end



/**
 Provide some some common method for `NSMutableDictionary`.
 */
@interface NSMutableDictionary (GTKit)

/**
 Creates and returns a dictionary from a specified property list data.
 
 @param plist   A property list data whose root object is a dictionary.
 @return A new dictionary created from the binary plist data, or nil if an error occurs.
 
 @discussion Apple has implemented this method, but did not make it public.
 */
+ (nullable NSMutableDictionary *)gt_dictionaryWithPlistData:(NSData *)plist;

/**
 Creates and returns a dictionary from a specified property list xml string.
 
 @param plist   A property list xml string whose root object is a dictionary.
 @return A new dictionary created from the plist string, or nil if an error occurs.
 */
+ (nullable NSMutableDictionary *)gt_dictionaryWithPlistString:(NSString *)plist;


/**
 Removes and returns the value associated with a given key.
 
 @param aKey The key for which to return and remove the corresponding value.
 @return The value associated with aKey, or nil if no value is associated with aKey.
 */
- (nullable id)gt_popObjectForKey:(id)aKey;

/**
 Returns a new dictionary containing the entries for keys, and remove these
 entries from receiver. If the keys is empty or nil, it just returns an
 empty dictionary.
 
 @param keys The keys.
 @return The entries for the keys.
 */
- (NSDictionary *)gt_popEntriesForKeys:(NSArray *)keys;


@end

NS_ASSUME_NONNULL_END
