//
//  UIImageView+BetterFace.h
//  bf
//
//  Created by croath on 13-10-22.
//  Copyright (c) 2013年 Croath. All rights reserved.
//
// https://github.com/croath/UIImageView-BetterFace
//  a UIImageView category to let the picture-cutting with faces showing better

#import <UIKit/UIKit.h>

@interface UIImageView (GTBetterFace)

@property (nonatomic) BOOL gt_needsBetterFace;
@property (nonatomic) BOOL gt_fast;

void gt_hack_uiimageview_bf(void);
- (void)gt_setBetterFaceImage:(UIImage *)image;

@end
