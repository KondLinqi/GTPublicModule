//
//  UIImageView+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/20.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UIImageView+GTKit.h"

// This multiplier sets the font size based on the view bounds
static const CGFloat gt_FontResizingProportion = 0.42f;

@implementation UIImageView (GTKit)

+ (id)gt_imageViewWithImageNamed:(NSString*)imageName
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
}

+ (id)gt_imageViewWithFrame:(CGRect)frame
{
    return [[UIImageView alloc] initWithFrame:frame];
}

+ (id)gt_imageViewWithStretchableImage:(NSString*)imageName Frame:(CGRect)frame
{
    UIImage *image =[UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    return imageView;
}

- (void)gt_setImageWithStretchableImage:(NSString*)imageName
{
    UIImage *image =[UIImage imageNamed:imageName];
    self.image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
}

+ (id)gt_imageViewWithImageArray:(NSArray *)imageArray duration:(NSTimeInterval)duration;
{
    if (imageArray && [imageArray count]<=0)
    {
        return nil;
    }
    UIImageView *imageView = [UIImageView gt_imageViewWithImageNamed:[imageArray objectAtIndex:0]];
    NSMutableArray *images = [NSMutableArray array];
    for (NSInteger i = 0; i < imageArray.count; i++)
    {
        UIImage *image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
        [images addObject:image];
    }
    [imageView setImage:[images objectAtIndex:0]];
    [imageView setAnimationImages:images];
    [imageView setAnimationDuration:duration];
    [imageView setAnimationRepeatCount:0];
    return imageView;
}

#pragma mark - 画水印
///=============================================================================
/// @name 画水印
///=============================================================================

// 画水印
- (void)gt_setImage:(UIImage *)image withWaterMark:(UIImage *)mark inRect:(CGRect)rect
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    }
    // CGContextRef thisctx = UIGraphicsGetCurrentContext();
    // CGAffineTransform myTr = CGAffineTransformMake(1, 0, 0, -1, 0, self.height);
    // CGContextConcatCTM(thisctx, myTr);
    //CGContextDrawImage(thisctx,CGRectMake(0,0,self.width,self.height),[image CGImage]); //原图
    //CGContextDrawImage(thisctx,rect,[mask CGImage]); //水印图
    //原图
    [image drawInRect:self.bounds];
    //水印图
    [mark drawInRect:rect];
    // NSString *s = @"dfd";
    // [[UIColor redColor] set];
    // [s drawInRect:self.bounds withFont:[UIFont systemFontOfSize:15.0]];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = newPic;
}
- (void)gt_setImage:(UIImage *)image withStringWaterMark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    }
    //原图
    [image drawInRect:self.bounds];
    //文字颜色
    [color set];
    // const CGFloat *colorComponents = CGColorGetComponents([color CGColor]);
    // CGContextSetRGBFillColor(context, colorComponents[0], colorComponents[1], colorComponents [2], colorComponents[3]);
    //水印文字
    if ([markString respondsToSelector:@selector(drawInRect:withAttributes:)])
    {
        [markString drawInRect:rect withAttributes:@{NSFontAttributeName:font}];
    }
    else
    {
        // pre-iOS7.0
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [markString drawInRect:rect withFont:font];
#pragma clang diagnostic pop
    }
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = newPic;
}
- (void)gt_setImage:(UIImage *)image withStringWaterMark:(NSString *)markString atPoint:(CGPoint)point color:(UIColor *)color font:(UIFont *)font
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    }
    //原图
    [image drawInRect:self.bounds];
    //文字颜色
    [color set];
    //水印文字
    
    if ([markString respondsToSelector:@selector(drawAtPoint:withAttributes:)])
    {
        [markString drawAtPoint:point withAttributes:@{NSFontAttributeName:font}];
    }
    else
    {
        // pre-iOS7.0
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [markString drawAtPoint:point withFont:font];
#pragma clang diagnostic pop
    }
    
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.image = newPic;
}



#pragma mark - GeometryConversion 几何转换
///=============================================================================
/// @name GeometryConversion 几何转换
///=============================================================================

- (CGPoint)gt_convertPointFromImage:(CGPoint)imagePoint {
    CGPoint viewPoint = imagePoint;
    
    CGSize imageSize = self.image.size;
    CGSize viewSize  = self.bounds.size;
    
    CGFloat ratioX = viewSize.width / imageSize.width;
    CGFloat ratioY = viewSize.height / imageSize.height;
    
    UIViewContentMode contentMode = self.contentMode;
    
    switch (contentMode) {
        case UIViewContentModeScaleToFill:
        case UIViewContentModeRedraw:
        {
            viewPoint.x *= ratioX;
            viewPoint.y *= ratioY;
            break;
        }
            
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleAspectFill:
        {
            CGFloat scale;
            
            if (contentMode == UIViewContentModeScaleAspectFit) {
                scale = MIN(ratioX, ratioY);
            }
            else /*if (contentMode == UIViewContentModeScaleAspectFill)*/ {
                scale = MAX(ratioX, ratioY);
            }
            
            viewPoint.x *= scale;
            viewPoint.y *= scale;
            
            viewPoint.x += (viewSize.width  - imageSize.width  * scale) / 2.0f;
            viewPoint.y += (viewSize.height - imageSize.height * scale) / 2.0f;
            
            break;
        }
            
        case UIViewContentModeCenter:
        {
            viewPoint.x += viewSize.width / 2.0  - imageSize.width  / 2.0f;
            viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0f;
            
            break;
        }
            
        case UIViewContentModeTop:
        {
            viewPoint.x += viewSize.width / 2.0 - imageSize.width / 2.0f;
            
            break;
        }
            
        case UIViewContentModeBottom:
        {
            viewPoint.x += viewSize.width / 2.0 - imageSize.width / 2.0f;
            viewPoint.y += viewSize.height - imageSize.height;
            
            break;
        }
            
        case UIViewContentModeLeft:
        {
            viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0f;
            
            break;
        }
            
        case UIViewContentModeRight:
        {
            viewPoint.x += viewSize.width - imageSize.width;
            viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0f;
            
            break;
        }
            
        case UIViewContentModeTopRight:
        {
            viewPoint.x += viewSize.width - imageSize.width;
            
            break;
        }
            
            
        case UIViewContentModeBottomLeft:
        {
            viewPoint.y += viewSize.height - imageSize.height;
            
            break;
        }
            
            
        case UIViewContentModeBottomRight:
        {
            viewPoint.x += viewSize.width  - imageSize.width;
            viewPoint.y += viewSize.height - imageSize.height;
            
            break;
        }
            
        case UIViewContentModeTopLeft:
        default:
        {
            break;
        }
    }
    
    return viewPoint;
}

- (CGRect)gt_convertRectFromImage:(CGRect)imageRect {
    CGPoint imageTopLeft     = imageRect.origin;
    CGPoint imageBottomRight = CGPointMake(CGRectGetMaxX(imageRect),
                                           CGRectGetMaxY(imageRect));
    
    CGPoint viewTopLeft     = [self gt_convertPointFromImage:imageTopLeft];
    CGPoint viewBottomRight = [self gt_convertPointFromImage:imageBottomRight];
    
    CGRect viewRect;
    viewRect.origin = viewTopLeft;
    viewRect.size   = CGSizeMake(ABS(viewBottomRight.x - viewTopLeft.x),
                                 ABS(viewBottomRight.y - viewTopLeft.y));
    
    return viewRect;
}

- (CGPoint)gt_convertPointFromView:(CGPoint)viewPoint {
    CGPoint imagePoint = viewPoint;
    
    CGSize imageSize = self.image.size;
    CGSize viewSize  = self.bounds.size;
    
    CGFloat ratioX = viewSize.width / imageSize.width;
    CGFloat ratioY = viewSize.height / imageSize.height;
    
    UIViewContentMode contentMode = self.contentMode;
    
    switch (contentMode) {
        case UIViewContentModeScaleToFill:
        case UIViewContentModeRedraw:
        {
            imagePoint.x /= ratioX;
            imagePoint.y /= ratioY;
            break;
        }
            
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleAspectFill:
        {
            CGFloat scale;
            
            if (contentMode == UIViewContentModeScaleAspectFit) {
                scale = MIN(ratioX, ratioY);
            }
            else /*if (contentMode == UIViewContentModeScaleAspectFill)*/ {
                scale = MAX(ratioX, ratioY);
            }
            
            // Remove the x or y margin added in FitMode
            imagePoint.x -= (viewSize.width  - imageSize.width  * scale) / 2.0f;
            imagePoint.y -= (viewSize.height - imageSize.height * scale) / 2.0f;
            
            imagePoint.x /= scale;
            imagePoint.y /= scale;
            
            break;
        }
            
        case UIViewContentModeCenter:
        {
            imagePoint.x -= (viewSize.width - imageSize.width)  / 2.0f;
            imagePoint.y -= (viewSize.height - imageSize.height) / 2.0f;
            
            break;
        }
            
        case UIViewContentModeTop:
        {
            imagePoint.x -= (viewSize.width - imageSize.width)  / 2.0f;
            
            break;
        }
            
        case UIViewContentModeBottom:
        {
            imagePoint.x -= (viewSize.width - imageSize.width)  / 2.0f;
            imagePoint.y -= (viewSize.height - imageSize.height);
            
            break;
        }
            
        case UIViewContentModeLeft:
        {
            imagePoint.y -= (viewSize.height - imageSize.height) / 2.0f;
            
            break;
        }
            
        case UIViewContentModeRight:
        {
            imagePoint.x -= (viewSize.width - imageSize.width);
            imagePoint.y -= (viewSize.height - imageSize.height) / 2.0f;
            
            break;
        }
            
        case UIViewContentModeTopRight:
        {
            imagePoint.x -= (viewSize.width - imageSize.width);
            
            break;
        }
            
            
        case UIViewContentModeBottomLeft:
        {
            imagePoint.y -= (viewSize.height - imageSize.height);
            
            break;
        }
            
            
        case UIViewContentModeBottomRight:
        {
            imagePoint.x -= (viewSize.width - imageSize.width);
            imagePoint.y -= (viewSize.height - imageSize.height);
            
            break;
        }
            
        case UIViewContentModeTopLeft:
        default:
        {
            break;
        }
    }
    
    return imagePoint;
}

- (CGRect)gt_convertRectFromView:(CGRect)viewRect {
    CGPoint viewTopLeft = viewRect.origin;
    CGPoint viewBottomRight = CGPointMake(CGRectGetMaxX(viewRect),
                                          CGRectGetMaxY(viewRect));
    
    CGPoint imageTopLeft = [self gt_convertPointFromView:viewTopLeft];
    CGPoint imageBottomRight = [self gt_convertPointFromView:viewBottomRight];
    
    CGRect imageRect;
    imageRect.origin = imageTopLeft;
    imageRect.size = CGSizeMake(ABS(imageBottomRight.x - imageTopLeft.x),
                                ABS(imageBottomRight.y - imageTopLeft.y));
    
    return imageRect;
}

#pragma mark - Letter 文字图片
///=============================================================================
/// @name Letter 文字图片
///=============================================================================

- (void)gt_setImageWithString:(NSString *)string {
    [self gt_setImageWithString:string color:nil circular:NO textAttributes:nil];
}

- (void)gt_setImageWithString:(NSString *)string color:(UIColor *)color {
    [self gt_setImageWithString:string color:color circular:NO textAttributes:nil];
}

- (void)gt_setImageWithString:(NSString *)string color:(UIColor *)color circular:(BOOL)isCircular {
    [self gt_setImageWithString:string color:color circular:isCircular textAttributes:nil];
}

- (void)gt_setImageWithString:(NSString *)string color:(UIColor *)color circular:(BOOL)isCircular fontName:(NSString *)fontName {
    [self gt_setImageWithString:string color:color circular:isCircular textAttributes:@{
                                                                                        NSFontAttributeName:[self gt_fontForFontName:fontName],
                                                                                        NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                        }];
}

- (void)gt_setImageWithString:(NSString *)string color:(UIColor *)color circular:(BOOL)isCircular textAttributes:(NSDictionary *)textAttributes {
    if (!textAttributes) {
        textAttributes = @{
                           NSFontAttributeName: [self gt_fontForFontName:nil],
                           NSForegroundColorAttributeName: [UIColor whiteColor]
                           };
    }
    
    NSMutableString *displayString = [NSMutableString stringWithString:@""];
    
    NSMutableArray *words = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] mutableCopy];
    
    //
    // Get first letter of the first and last word
    //
    if ([words count]) {
        NSString *firstWord = [words firstObject];
        if ([firstWord length]) {
            // Get character range to handle emoji (emojis consist of 2 characters in sequence)
            NSRange firstLetterRange = [firstWord rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 1)];
            [displayString appendString:[firstWord substringWithRange:firstLetterRange]];
        }
        
        if ([words count] >= 2) {
            NSString *lastWord = [words lastObject];
            
            while ([lastWord length] == 0 && [words count] >= 2) {
                [words removeLastObject];
                lastWord = [words lastObject];
            }
            
            if ([words count] > 1) {
                // Get character range to handle emoji (emojis consist of 2 characters in sequence)
                NSRange lastLetterRange = [lastWord rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 1)];
                [displayString appendString:[lastWord substringWithRange:lastLetterRange]];
            }
        }
    }
    
    UIColor *backgroundColor = color ? color : [self gt_letter_randomColor];
    
    self.image = [self gt_imageSnapshotFromText:[displayString uppercaseString] backgroundColor:backgroundColor circular:isCircular textAttributes:textAttributes];
}

#pragma mark - Helpers

- (UIFont *)gt_fontForFontName:(NSString *)fontName {
    
    CGFloat fontSize = CGRectGetWidth(self.bounds) * gt_FontResizingProportion;
    if (fontName) {
        return [UIFont fontWithName:fontName size:fontSize];
    }
    else {
        return [UIFont systemFontOfSize:fontSize];
    }
    
}

- (UIColor *)gt_letter_randomColor {
    
    float red = 0.0;
    while (red < 0.1 || red > 0.84) {
        red = drand48();
    }
    
    float green = 0.0;
    while (green < 0.1 || green > 0.84) {
        green = drand48();
    }
    
    float blue = 0.0;
    while (blue < 0.1 || blue > 0.84) {
        blue = drand48();
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

- (UIImage *)gt_imageSnapshotFromText:(NSString *)text backgroundColor:(UIColor *)color circular:(BOOL)isCircular textAttributes:(NSDictionary *)textAttributes {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize size = self.bounds.size;
    if (self.contentMode == UIViewContentModeScaleToFill ||
        self.contentMode == UIViewContentModeScaleAspectFill ||
        self.contentMode == UIViewContentModeScaleAspectFit ||
        self.contentMode == UIViewContentModeRedraw)
    {
        size.width = floorf(size.width * scale) / scale;
        size.height = floorf(size.height * scale) / scale;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (isCircular) {
        //
        // Clip context to a circle
        //
        CGPathRef path = CGPathCreateWithEllipseInRect(self.bounds, NULL);
        CGContextAddPath(context, path);
        CGContextClip(context);
        CGPathRelease(path);
    }
    
    //
    // Fill background of context
    //
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    //
    // Draw text in the context
    //
    CGSize textSize = [text sizeWithAttributes:textAttributes];
    CGRect bounds = self.bounds;
    
    [text drawInRect:CGRectMake(bounds.size.width/2 - textSize.width/2,
                                bounds.size.height/2 - textSize.height/2,
                                textSize.width,
                                textSize.height)
      withAttributes:textAttributes];
    
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshot;
}


#pragma mark - 倒影
///=============================================================================
/// @name 倒影
///=============================================================================

/**
 *  @brief  倒影
 */
- (void)gt_reflect {
    CGRect frame = self.frame;
    frame.origin.y += (frame.size.height + 1);
    
    UIImageView *reflectionImageView = [[UIImageView alloc] initWithFrame:frame];
    self.clipsToBounds = TRUE;
    reflectionImageView.contentMode = self.contentMode;
    [reflectionImageView setImage:self.image];
    reflectionImageView.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    CALayer *reflectionLayer = [reflectionImageView layer];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.bounds = reflectionLayer.bounds;
    gradientLayer.position = CGPointMake(reflectionLayer.bounds.size.width / 2, reflectionLayer.bounds.size.height * 0.5);
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[[UIColor clearColor] CGColor],
                            (id)[[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3] CGColor], nil];
    
    gradientLayer.startPoint = CGPointMake(0.5,0.5);
    gradientLayer.endPoint = CGPointMake(0.5,1.0);
    reflectionLayer.mask = gradientLayer;
    
    [self.superview addSubview:reflectionImageView];
    
}
@end
