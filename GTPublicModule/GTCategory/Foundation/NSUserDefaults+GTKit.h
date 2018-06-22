//
//  NSUserDefaults+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (GTKit)

#pragma mark - iCloudSync

-(void)gt_setValue:(id)value  forKey:(NSString *)key iCloudSync:(BOOL)sync;
-(void)gt_setObject:(id)value forKey:(NSString *)key iCloudSync:(BOOL)sync;

-(id)gt_valueForKey:(NSString *)key  iCloudSync:(BOOL)sync;
-(id)gt_objectForKey:(NSString *)key iCloudSync:(BOOL)sync;

-(BOOL)gt_synchronizeAlsoiCloudSync:(BOOL)sync;

#pragma mark - SafeAccess

+ (NSString *)gt_stringForKey:(NSString *)defaultName;

+ (NSArray *)gt_arrayForKey:(NSString *)defaultName;

+ (NSDictionary *)gt_dictionaryForKey:(NSString *)defaultName;

+ (NSData *)gt_dataForKey:(NSString *)defaultName;

+ (NSArray *)gt_stringArrayForKey:(NSString *)defaultName;

+ (NSInteger)gt_integerForKey:(NSString *)defaultName;

+ (float)gt_floatForKey:(NSString *)defaultName;

+ (double)gt_doubleForKey:(NSString *)defaultName;

+ (BOOL)gt_boolForKey:(NSString *)defaultName;

+ (NSURL *)gt_URLForKey:(NSString *)defaultName;

#pragma mark - WRITE FOR STANDARD

+ (void)gt_setObject:(id)value forKey:(NSString *)defaultName;

#pragma mark - READ ARCHIVE FOR STANDARD

+ (id)gt_arcObjectForKey:(NSString *)defaultName;

#pragma mark - WRITE ARCHIVE FOR STANDARD

+ (void)gt_setArcObject:(id)value forKey:(NSString *)defaultName;

@end

NS_ASSUME_NONNULL_END
