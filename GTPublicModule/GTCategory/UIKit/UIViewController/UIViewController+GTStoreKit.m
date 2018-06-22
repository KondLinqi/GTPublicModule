//
//  UIViewController+StoreKit.m
//  Picks
//
//  Created by Joe Fabisevich on 8/12/14.
//  Copyright (c) 2014 Snarkbots. All rights reserved.
//

#import "UIViewController+GTStoreKit.h"

#import <objc/runtime.h>

#import <StoreKit/StoreKit.h>

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Constants

NSString* const gt_affiliateTokenKey = @"at";
NSString* const gt_campaignTokenKey = @"ct";
NSString* const gt_iTunesAppleString = @"itunes.apple.com";

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interface

@interface UIViewController (SKStoreProductViewControllerDelegate) <SKStoreProductViewControllerDelegate>

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Implementation

@implementation UIViewController (GTStoreKit)

- (void)gt_presentStoreKitItemWithIdentifier:(NSInteger)itemIdentifier
{
    SKStoreProductViewController* storeViewController = [[SKStoreProductViewController alloc] init];
    storeViewController.delegate = self;

    NSString* campaignToken = self.gt_campaignToken ?: @"";

    NSDictionary* parameters = @{
        SKStoreProductParameterITunesItemIdentifier : @(itemIdentifier),
        gt_affiliateTokenKey : gt_affiliateTokenKey,
        gt_campaignTokenKey : campaignToken,
    };

    if (self.gt_loadingStoreKitItemBlock) {
        self.gt_loadingStoreKitItemBlock();
    }
    [storeViewController loadProductWithParameters:parameters completionBlock:^(BOOL result, NSError* error) {
        if (self.gt_loadedStoreKitItemBlock) {
            self.gt_loadedStoreKitItemBlock();
        }

        if (result && !error)
        {
            [self presentViewController:storeViewController animated:YES completion:nil];
        }
    }];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Delegation - SKStoreProductViewControllerDelegate

- (void)gt_productViewControllerDidFinish:(SKStoreProductViewController*)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public methods

+ (NSURL*)gt_appURLForIdentifier:(NSInteger)identifier
{
    NSString* appURLString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%li", (long)identifier];
    return [NSURL URLWithString:appURLString];
}

+ (void)gt_openAppReviewURLForIdentifier:(NSInteger)identifier
{
    NSString* reviewURLString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%li", (long)identifier];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURLString]];
}

+ (void)gt_openAppURLForIdentifier:(NSInteger)identifier
{
    NSString* appURLString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%li", (long)identifier];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURLString]];
}

+ (BOOL)gt_containsITunesURLString:(NSString*)URLString
{
    return ([URLString rangeOfString:gt_iTunesAppleString].location != NSNotFound);
}

+ (NSInteger)gt_IDFromITunesURL:(NSString*)URLString
{
    NSError* error;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"id\\d+" options:0 error:&error];
    NSTextCheckingResult* match = [regex firstMatchInString:URLString options:0 range:NSMakeRange(0, URLString.length)];

    NSString* idString = [URLString substringWithRange:match.range];
    if (idString.length > 0) {
        idString = [idString stringByReplacingOccurrencesOfString:@"id" withString:@""];
    }

    return [idString integerValue];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Associated objects

- (void)setGt_campaignToken:(NSString*)campaignToken
{
    objc_setAssociatedObject(self, @selector(setGt_campaignToken:), campaignToken, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString*)gt_campaignToken
{
    return objc_getAssociatedObject(self, @selector(setGt_campaignToken:));
}

- (void)setGt_loadingStoreKitItemBlock:(void (^)(void))loadingStoreKitItemBlock
{
    objc_setAssociatedObject(self, @selector(setGt_loadingStoreKitItemBlock:), loadingStoreKitItemBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))gt_loadingStoreKitItemBlock
{
    return objc_getAssociatedObject(self, @selector(setGt_loadingStoreKitItemBlock:));
}

- (void)setGt_loadedStoreKitItemBlock:(void (^)(void))loadedStoreKitItemBlock
{
    objc_setAssociatedObject(self, @selector(setGt_loadedStoreKitItemBlock:), loadedStoreKitItemBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))gt_loadedStoreKitItemBlock
{
    return objc_getAssociatedObject(self, @selector(setGt_loadedStoreKitItemBlock:));
}

@end
