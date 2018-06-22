//
//  NSUserDefaults+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "NSUserDefaults+GTKit.h"

@implementation NSUserDefaults (GTKit)

#pragma mark - iCloudSync

-(void)gt_setValue:(id)value forKey:(NSString *)key iCloudSync:(BOOL)sync
{
    if (sync)
        [[NSUbiquitousKeyValueStore defaultStore] setValue:value forKey:key];
    
    [self setValue:value forKey:key];
}

-(id)gt_valueForKey:(NSString *)key iCloudSync:(BOOL)sync
{
    if (sync)
    {
        //Get value from iCloud
        id value = [[NSUbiquitousKeyValueStore defaultStore] valueForKey:key];
        
        //Store locally and synchronize
        [self setValue:value forKey:key];
        [self synchronize];
        
        return value;
    }
    
    return [self valueForKey:key];
}

- (void)gt_removeValueForKey:(NSString *)key iCloudSync:(BOOL)sync
{
    [self gt_removeObjectForKey:key iCloudSync:sync];
}



-(void)gt_setObject:(id)value forKey:(NSString *)defaultName iCloudSync:(BOOL)sync
{
    if (sync)
        [[NSUbiquitousKeyValueStore defaultStore] setObject:value forKey:defaultName];
    
    [self setObject:value forKey:defaultName];
}

-(id)gt_objectForKey:(NSString *)key iCloudSync:(BOOL)sync
{
    if (sync)
    {
        //Get value from iCloud
        id value = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:key];
        
        //Store to NSUserDefault and synchronize
        [self setObject:value forKey:key];
        [self synchronize];
        
        return value;
    }
    
    return [self objectForKey:key];
}

- (void)gt_removeObjectForKey:(NSString *)key iCloudSync:(BOOL)sync
{
    if (sync)
        [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:key];
    
    //Remove from NSUserDefault
    return [self removeObjectForKey:key];
}



- (BOOL)gt_synchronizeAlsoiCloudSync:(BOOL)sync
{
    BOOL res = true;
    
    if (sync)
        res &= [self synchronize];
    
    res &= [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    
    return res;
}

#pragma mark - SafeAccess

+ (NSString *)gt_stringForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] stringForKey:defaultName];
}

+ (NSArray *)gt_arrayForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] arrayForKey:defaultName];
}

+ (NSDictionary *)gt_dictionaryForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:defaultName];
}

+ (NSData *)gt_dataForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] dataForKey:defaultName];
}

+ (NSArray *)gt_stringArrayForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] stringArrayForKey:defaultName];
}

+ (NSInteger)gt_integerForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] integerForKey:defaultName];
}

+ (float)gt_floatForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] floatForKey:defaultName];
}

+ (double)gt_doubleForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:defaultName];
}

+ (BOOL)gt_boolForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
}

+ (NSURL *)gt_URLForKey:(NSString *)defaultName {
    return [[NSUserDefaults standardUserDefaults] URLForKey:defaultName];
}

#pragma mark - WRITE FOR STANDARD

+ (void)gt_setObject:(id)value forKey:(NSString *)defaultName {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - READ ARCHIVE FOR STANDARD

+ (id)gt_arcObjectForKey:(NSString *)defaultName {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:defaultName]];
}

#pragma mark - WRITE ARCHIVE FOR STANDARD

+ (void)gt_setArcObject:(id)value forKey:(NSString *)defaultName {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:value] forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
