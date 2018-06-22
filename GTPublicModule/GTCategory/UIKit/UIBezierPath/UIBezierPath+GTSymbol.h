//
//  UIBezierPath+Symbol.h
//  YeNom
//
//  Created by Kaijie Yu on 6/29/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//https://github.com/Kjuly/UIBezierPath-Symbol


#import <UIKit/UIKit.h>
// Direction
typedef enum {
  kUIBezierPathArrowDirectionNone  = 0,
  kUIBezierPathArrowDirectionRight = 1 << 0,
  kUIBezierPathArrowDirectionLeft  = 1 << 1,
  kUIBezierPathArrowDirectionUp    = 1 << 2,
  kUIBezierPathArrowDirectionDown  = 1 << 3
}JKUIBezierPathArrowDirection;

@interface UIBezierPath (GTSymbol)

+ (UIBezierPath *)gt_customBezierPathOfPlusSymbolWithRect:(CGRect)rect   // plus
                                                 scale:(CGFloat)scale;
+ (UIBezierPath *)gt_customBezierPathOfMinusSymbolWithRect:(CGRect)rect  // minus
                                                  scale:(CGFloat)scale;
+ (UIBezierPath *)gt_customBezierPathOfCheckSymbolWithRect:(CGRect)rect  // check
                                                  scale:(CGFloat)scale
                                                  thick:(CGFloat)thick;
+ (UIBezierPath *)gt_customBezierPathOfCrossSymbolWithRect:(CGRect)rect  // cross
                                                  scale:(CGFloat)scale
                                                  thick:(CGFloat)thick;
+ (UIBezierPath *)gt_customBezierPathOfArrowSymbolWithRect:(CGRect)rect  // arrow
                                                  scale:(CGFloat)scale
                                                  thick:(CGFloat)thick
                                              direction:(JKUIBezierPathArrowDirection)direction;
+ (UIBezierPath *)gt_customBezierPathOfPencilSymbolWithRect:(CGRect)rect // pencil
                                                   scale:(CGFloat)scale
                                                   thick:(CGFloat)thick;

@end
