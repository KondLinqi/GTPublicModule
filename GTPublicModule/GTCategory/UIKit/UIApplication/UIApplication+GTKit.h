//
//  UIApplication+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UIApplication`.
 */
@interface UIApplication (GTKit)

/// "Documents" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL *gt_documentsURL;
@property (nonatomic, readonly) NSString *gt_documentsPath;

/// "Caches" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL *gt_cachesURL;
@property (nonatomic, readonly) NSString *gt_cachesPath;

/// "Library" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL *gt_libraryURL;
@property (nonatomic, readonly) NSString *gt_libraryPath;

/// Application's Bundle Name (show in SpringBoard).
@property (nullable, nonatomic, readonly) NSString *gt_appBundleName;

/// Application's Bundle ID.  e.g. "com.ibireme.MyApp"
@property (nullable, nonatomic, readonly) NSString *gt_appBundleID;

/// Application's Version.  e.g. "1.2.0"
@property (nullable, nonatomic, readonly) NSString *gt_appVersion;

/// Application's Build number. e.g. "123"
@property (nullable, nonatomic, readonly) NSString *gt_appBuildVersion;

/// Application size
@property (nullable, nonatomic, readonly) NSString *gt_applicationSize;

/// Whether this app is pirated (not install from appstore).
@property (nonatomic, readonly) BOOL gt_isPirated;

/// Whether this app is being debugged (debugger attached).
@property (nonatomic, readonly) BOOL gt_isBeingDebugged;

/// Current thread real memory used in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t gt_memoryUsage;

/// Current thread CPU usage, 1.0 means 100%. (-1 when error occurs)
@property (nonatomic, readonly) float gt_cpuUsage;


/**
 Increments the number of active network requests.
 If this number was zero before incrementing, this will start animating the
 status bar network activity indicator.
 
 This method is thread safe.
 
 This method has no effect in App Extension.
 */
- (void)gt_incrementNetworkActivityCount;

/**
 Decrements the number of active network requests.
 If this number becomes zero after decrementing, this will stop animating the
 status bar network activity indicator.
 
 This method is thread safe.
 
 This method has no effect in App Extension.
 */
- (void)gt_decrementNetworkActivityCount;


/// Returns YES in App Extension.
+ (BOOL)gt_isAppExtension;

/// Same as sharedApplication, but returns nil in App Extension.
+ (nullable UIApplication *)gt_sharedExtensionApplication;


- (void)gt_beganNetworkActivity;

- (void)gt_endedNetworkActivity;

@end

NS_ASSUME_NONNULL_END
