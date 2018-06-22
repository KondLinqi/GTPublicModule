//
//  UIViewController+StoreKit.h
//  Picks
//
//  Created by Joe Fabisevich on 8/12/14.
//  Copyright (c) 2014 Snarkbots. All rights reserved.
//  https://github.com/mergesort/UIViewController-StoreKit

#import <UIKit/UIKit.h>

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants

#define affiliateToken @"10laQX"

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface UIViewController (GTStoreKit)

@property NSString *gt_campaignToken;
@property (nonatomic, copy) void (^gt_loadingStoreKitItemBlock)(void);
@property (nonatomic, copy) void (^gt_loadedStoreKitItemBlock)(void);

- (void)gt_presentStoreKitItemWithIdentifier:(NSInteger)itemIdentifier;

+ (NSURL*)gt_appURLForIdentifier:(NSInteger)identifier;

+ (void)gt_openAppURLForIdentifier:(NSInteger)identifier;
+ (void)gt_openAppReviewURLForIdentifier:(NSInteger)identifier;

+ (BOOL)gt_containsITunesURLString:(NSString*)URLString;
+ (NSInteger)gt_IDFromITunesURL:(NSString*)URLString;

@end
