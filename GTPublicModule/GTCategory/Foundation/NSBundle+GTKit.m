//
//  NSBundle+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "NSBundle+GTKit.h"
#import "NSString+GTKit.h"

@implementation NSBundle (GTKit)

+ (NSArray *)gt_preferredScales {
    static NSArray *scales;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenScale = [UIScreen mainScreen].scale;
        if (screenScale <= 1) {
            scales = @[@1,@2,@3];
        } else if (screenScale <= 2) {
            scales = @[@2,@3,@1];
        } else {
            scales = @[@3,@2,@1];
        }
    });
    return scales;
}

+ (NSString *)gt_pathForScaledResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)bundlePath {
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return [self pathForResource:name ofType:ext inDirectory:bundlePath];
    
    NSString *path = nil;
    NSArray *scales = [self gt_preferredScales];
    for (int s = 0; s < scales.count; s++) {
        CGFloat scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = ext.length ? [name gt_stringByAppendingNameScale:scale]
        : [name gt_stringByAppendingPathScale:scale];
        path = [self pathForResource:scaledName ofType:ext inDirectory:bundlePath];
        if (path) break;
    }
    
    return path;
}

- (NSString *)gt_pathForScaledResource:(NSString *)name ofType:(NSString *)ext {
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return [self pathForResource:name ofType:ext];
    
    NSString *path = nil;
    NSArray *scales = [NSBundle gt_preferredScales];
    for (int s = 0; s < scales.count; s++) {
        CGFloat scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = ext.length ? [name gt_stringByAppendingNameScale:scale]
        : [name gt_stringByAppendingPathScale:scale];
        path = [self pathForResource:scaledName ofType:ext];
        if (path) break;
    }
    
    return path;
}

- (NSString *)gt_pathForScaledResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)subpath {
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return [self pathForResource:name ofType:ext];
    
    NSString *path = nil;
    NSArray *scales = [NSBundle gt_preferredScales];
    for (int s = 0; s < scales.count; s++) {
        CGFloat scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = ext.length ? [name gt_stringByAppendingNameScale:scale]
        : [name gt_stringByAppendingPathScale:scale];
        path = [self pathForResource:scaledName ofType:ext inDirectory:subpath];
        if (path) break;
    }
    
    return path;
}

- (NSString*)gt_appIconPath {
    NSString* iconFilename = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIconFile"] ;
    NSString* iconBasename = [iconFilename stringByDeletingPathExtension] ;
    NSString* iconExtension = [iconFilename pathExtension] ;
    return [[NSBundle mainBundle] pathForResource:iconBasename
                                           ofType:iconExtension] ;
}

- (UIImage*)gt_appIcon {
    UIImage*appIcon = [[UIImage alloc] initWithContentsOfFile:[self gt_appIconPath]] ;
    return appIcon;
}

@end
