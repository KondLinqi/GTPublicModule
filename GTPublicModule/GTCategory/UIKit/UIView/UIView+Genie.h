//
//  UIView+Genie.h
//  GTGenieEffect
//
//  Created by Bartosz Ciechanowski on 23.12.2012.
//  Copyright (c) 2012 Bartosz Ciechanowski. All rights reserved.
//
// An OSX style genie effect inside your iOS app. 
//https://github.com/Ciechan/BCGenieEffect

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GTRectEdge) {
    GTRectEdgeTop    = 0,
    GTRectEdgeLeft   = 1,
    GTRectEdgeBottom = 2,
    GTRectEdgeRight  = 3
};

@interface UIView (Genie)

/*
 * After the animation has completed the view's transform will be changed to match the destination's rect, i.e.
 * view's transform (and thus the frame) will change, however the bounds and center will *not* change.
 */

- (void)genieInTransitionWithDuration:(NSTimeInterval)duration
                      destinationRect:(CGRect)destRect
                      destinationEdge:(GTRectEdge)destEdge
                           completion:(void (^)(void))completion;



/*
 * After the animation has completed the view's transform will be changed to CGAffineTransformIdentity.
 */

- (void)genieOutTransitionWithDuration:(NSTimeInterval)duration
                             startRect:(CGRect)startRect
                             startEdge:(GTRectEdge)startEdge
                            completion:(void (^)(void))completion;

@end
