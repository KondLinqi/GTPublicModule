//
//  NSFileManager+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "NSFileManager+GTKit.h"
#include <sys/xattr.h>

@implementation NSFileManager (GTKit)

+ (NSURL *)gt_URLForDirectory:(NSSearchPathDirectory)directory
{
    return [self.defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}

+ (NSString *)gt_pathForDirectory:(NSSearchPathDirectory)directory
{
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES)[0];
}

+ (NSURL *)gt_documentsURL
{
    return [self gt_URLForDirectory:NSDocumentDirectory];
}

+ (NSString *)gt_documentsPath
{
    return [self gt_pathForDirectory:NSDocumentDirectory];
}

+ (NSURL *)gt_libraryURL
{
    return [self gt_URLForDirectory:NSLibraryDirectory];
}

+ (NSString *)gt_libraryPath
{
    return [self gt_pathForDirectory:NSLibraryDirectory];
}

+ (NSURL *)gt_cachesURL
{
    return [self gt_URLForDirectory:NSCachesDirectory];
}

+ (NSString *)gt_cachesPath
{
    return [self gt_pathForDirectory:NSCachesDirectory];
}

+ (BOOL)gt_addSkipBackupAttributeToFile:(NSString *)path
{
    return [[NSURL.alloc initFileURLWithPath:path] setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
}

+ (double)gt_availableDiskSpace
{
    NSDictionary *attributes = [self.defaultManager attributesOfFileSystemForPath:self.gt_documentsPath error:nil];
    
    return [attributes[NSFileSystemFreeSize] unsignedLongLongValue] / (double)0x100000;
}

@end
