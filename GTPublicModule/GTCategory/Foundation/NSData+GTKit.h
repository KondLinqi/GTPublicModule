//
//  NSData+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/18.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provide hash, encrypt, encode and some common method for `NSData`.
 */

@interface NSData (GTKit)

#pragma mark - Hash
///=============================================================================
/// @name Hash
///=============================================================================

/**
 Returns a lowercase NSString for md2 hash.
 */
- (NSString *)gt_md2String;

/**
 Returns an NSData for md2 hash.
 */
- (NSData *)gt_md2Data;

/**
 Returns a lowercase NSString for md4 hash.
 */
- (NSString *)gt_md4String;

/**
 Returns an NSData for md4 hash.
 */
- (NSData *)gt_md4Data;

/**
 Returns a lowercase NSString for md5 hash.
 */
- (NSString *)gt_md5String;

/**
 Returns an NSData for md5 hash.
 */
- (NSData *)gt_md5Data;

/**
 Returns a lowercase NSString for sha1 hash.
 */
- (NSString *)gt_sha1String;

/**
 Returns an NSData for sha1 hash.
 */
- (NSData *)gt_sha1Data;

/**
 Returns a lowercase NSString for sha224 hash.
 */
- (NSString *)gt_sha224String;

/**
 Returns an NSData for sha224 hash.
 */
- (NSData *)gt_sha224Data;

/**
 Returns a lowercase NSString for sha256 hash.
 */
- (NSString *)gt_sha256String;

/**
 Returns an NSData for sha256 hash.
 */
- (NSData *)gt_sha256Data;

/**
 Returns a lowercase NSString for sha384 hash.
 */
- (NSString *)gt_sha384String;

/**
 Returns an NSData for sha384 hash.
 */
- (NSData *)gt_sha384Data;

/**
 Returns a lowercase NSString for sha512 hash.
 */
- (NSString *)gt_sha512String;

/**
 Returns an NSData for sha512 hash.
 */
- (NSData *)gt_sha512Data;

/**
 Returns a lowercase NSString for hmac using algorithm md5 with key.
 @param key  The hmac key.
 */
- (NSString *)gt_hmacMD5StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm md5 with key.
 @param key  The hmac key.
 */
- (NSData *)gt_hmacMD5DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha1 with key.
 @param key  The hmac key.
 */
- (NSString *)gt_hmacSHA1StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha1 with key.
 @param key  The hmac key.
 */
- (NSData *)gt_hmacSHA1DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha224 with key.
 @param key  The hmac key.
 */
- (NSString *)gt_hmacSHA224StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha224 with key.
 @param key  The hmac key.
 */
- (NSData *)gt_hmacSHA224DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha256 with key.
 @param key  The hmac key.
 */
- (NSString *)gt_hmacSHA256StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha256 with key.
 @param key  The hmac key.
 */
- (NSData *)gt_hmacSHA256DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha384 with key.
 @param key  The hmac key.
 */
- (NSString *)gt_hmacSHA384StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha384 with key.
 @param key  The hmac key.
 */
- (NSData *)gt_hmacSHA384DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for hmac using algorithm sha512 with key.
 @param key  The hmac key.
 */
- (NSString *)gt_hmacSHA512StringWithKey:(NSString *)key;

/**
 Returns an NSData for hmac using algorithm sha512 with key.
 @param key  The hmac key.
 */
- (NSData *)gt_hmacSHA512DataWithKey:(NSData *)key;

/**
 Returns a lowercase NSString for crc32 hash.
 */
- (NSString *)gt_crc32String;

/**
 Returns crc32 hash.
 */
- (uint32_t)gt_crc32;


#pragma mark - Encrypt and Decrypt
///=============================================================================
/// @name Encrypt and Decrypt
///=============================================================================

/**
 Returns an encrypted NSData using AES.

 @param key   A key length of 16, 24 or 32 (128, 192 or 256bits).

 @param iv    An initialization vector length of 16(128bits).
 Pass nil when you don't want to use iv.

 @return      An NSData encrypted, or nil if an error occurs.
 */
- (nullable NSData *)gt_aes256EncryptWithKey:(NSData *)key iv:(nullable NSData *)iv;

/**
 Returns an decrypted NSData using AES.

 @param key   A key length of 16, 24 or 32 (128, 192 or 256bits).

 @param iv    An initialization vector length of 16(128bits).
 Pass nil when you don't want to use iv.

 @return      An NSData decrypted, or nil if an error occurs.
 */
- (nullable NSData *)gt_aes256DecryptWithkey:(NSData *)key iv:(nullable NSData *)iv;


#pragma mark - Encode and decode
///=============================================================================
/// @name Encode and decode
///=============================================================================

/**
 Returns string decoded in UTF8.
 */
- (nullable NSString *)gt_utf8String;

/**
 Returns a uppercase NSString in HEX.
 */
- (nullable NSString *)gt_hexString;

/**
 Returns an NSData from hex string.

 @param hexString   The hex string which is case insensitive.

 @return a new NSData, or nil if an error occurs.
 */
+ (nullable NSData *)gt_dataWithHexString:(NSString *)hexString;

/**
 Returns an NSString for base64 encoded.
 */
- (nullable NSString *)gt_base64EncodedString;


/**
 Returns an NSData from base64 encoded string.

 @warning This method has been implemented in iOS7.

 @param base64EncodedString  The encoded string.
 */
+ (nullable NSData *)gt_dataWithBase64EncodedString:(NSString *)base64EncodedString;

/**
 Returns an NSDictionary or NSArray for decoded self.
 Returns nil if an error occurs.
 */
- (nullable id)gt_jsonValueDecoded;


#pragma mark - Inflate and deflate
///=============================================================================
/// @name Inflate and deflate
///=============================================================================

/**
 Decompress data from gzip data.
 @return Inflated data.
 */
- (nullable NSData *)gt_gzipInflate;

/**
 Comperss data to gzip in default compresssion level.
 @return Deflated data.
 */
- (nullable NSData *)gt_gzipDeflate;

/**
 Decompress data from zlib-compressed data.
 @return Inflated data.
 */
- (nullable NSData *)gt_zlibInflate;

/**
 Comperss data to zlib-compressed in default compresssion level.
 @return Deflated data.
 */
- (nullable NSData *)gt_zlibDeflate;


#pragma mark - Others
///=============================================================================
/// @name Others
///=============================================================================

/**
 Create data from the file in main bundle (similar to [UIImage imageNamed:]).

 @param name The file name (in main bundle).

 @return A new data create from the file.
 */
+ (nullable NSData *)gt_dataNamed:(NSString *)name;


/**
 将APNS NSData类型token 格式化成字符串

 @return 整理过后的字符串token
 */
- (NSString *)gt_APNSToken;

@end

NS_ASSUME_NONNULL_END
