//
//  UIView+Toast.m
//  Toast
//
//  Copyright 2014 Charles Scalesse.
//


#import "UIView+GTToast.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

/*
 *  CONFIGURE THESE VALUES TO ADJUST LOOK & FEEL,
 *  DISPLAY DURATION, ETC.
 */

// general appearance
static const CGFloat GTToastMaxWidth            = 0.8;      // 80% of parent view width
static const CGFloat GTToastMaxHeight           = 0.8;      // 80% of parent view height
static const CGFloat GTToastHorizontalPadding   = 10.0;
static const CGFloat GTToastVerticalPadding     = 10.0;
static const CGFloat GTToastCornerRadius        = 10.0;
static const CGFloat GTToastOpacity             = 0.8;
static const CGFloat GTToastFontSize            = 16.0;
static const CGFloat GTToastMaxTitleLines       = 0;
static const CGFloat GTToastMaxMessageLines     = 0;
static const NSTimeInterval GTToastFadeDuration = 0.2;

// shadow appearance
static const CGFloat GTToastShadowOpacity       = 0.8;
static const CGFloat GTToastShadowRadius        = 6.0;
static const CGSize  GTToastShadowOffset        = { 4.0, 4.0 };
static const BOOL    GTToastDisplayShadow       = YES;

// display duration
static const NSTimeInterval GTToastDefaultDuration  = 3.0;

// image view size
static const CGFloat GTToastImageViewWidth      = 80.0;
static const CGFloat GTToastImageViewHeight     = 80.0;

// activity
static const CGFloat GTToastActivityWidth       = 100.0;
static const CGFloat GTToastActivityHeight      = 100.0;
static const NSString * GTToastActivityDefaultPosition = @"center";

// interaction
static const BOOL GTToastHidesOnTap             = YES;     // excludes activity views

// associative reference keys
static const NSString * GTToastTimerKey         = @"GTToastTimerKey";
static const NSString * GTToastActivityViewKey  = @"GTToastActivityViewKey";
static const NSString * GTToastTapCallbackKey   = @"GTToastTapCallbackKey";

// positions
NSString * const GTToastPositionTop             = @"top";
NSString * const GTToastPositionCenter          = @"center";
NSString * const GTToastPositionBottom          = @"bottom";

@interface UIView (GTToastPrivate)

- (void)gt_hideToast:(UIView *)toast;
- (void)gt_toastTimerDidFinish:(NSTimer *)timer;
- (void)gt_handleToastTapped:(UITapGestureRecognizer *)recognizer;
- (CGPoint)gt_centerPointForPosition:(id)position withToast:(UIView *)toast;
- (UIView *)gt_viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image;
- (CGSize)gt_sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end


@implementation UIView (GTToast)

#pragma mark - Toast Methods

- (void)gt_makeToast:(NSString *)message {
    [self gt_makeToast:message duration:GTToastDefaultDuration position:nil];
}

- (void)gt_makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position {
    UIView *toast = [self gt_viewForMessage:message title:nil image:nil];
    [self gt_showToast:toast duration:duration position:position];
}

- (void)gt_makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position title:(NSString *)title {
    UIView *toast = [self gt_viewForMessage:message title:title image:nil];
    [self gt_showToast:toast duration:duration position:position];
}

- (void)gt_makeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position image:(UIImage *)image {
    UIView *toast = [self gt_viewForMessage:message title:nil image:image];
    [self gt_showToast:toast duration:duration position:position];
}

- (void)gt_makeToast:(NSString *)message duration:(NSTimeInterval)duration  position:(id)position title:(NSString *)title image:(UIImage *)image {
    UIView *toast = [self gt_viewForMessage:message title:title image:image];
    [self gt_showToast:toast duration:duration position:position];
}

- (void)gt_showToast:(UIView *)toast {
    [self gt_showToast:toast duration:GTToastDefaultDuration position:nil];
}


- (void)gt_showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position {
    [self gt_showToast:toast duration:duration position:position tapCallback:nil];
    
}


- (void)gt_showToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position
      tapCallback:(void(^)(void))tapCallback
{
    toast.center = [self gt_centerPointForPosition:position withToast:toast];
    toast.alpha = 0.0;
    
    if (GTToastHidesOnTap) {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:toast action:@selector(gt_handleToastTapped:)];
        [toast addGestureRecognizer:recognizer];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    
    [self addSubview:toast];
    
    [UIView animateWithDuration:GTToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(gt_toastTimerDidFinish:) userInfo:toast repeats:NO];
                         // associate the timer with the toast view
                         objc_setAssociatedObject (toast, &GTToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         objc_setAssociatedObject (toast, &GTToastTapCallbackKey, tapCallback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
}


- (void)gt_hideToast:(UIView *)toast {
    [UIView animateWithDuration:GTToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         toast.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [toast removeFromSuperview];
                     }];
}

#pragma mark - Events

- (void)gt_toastTimerDidFinish:(NSTimer *)timer {
    [self gt_hideToast:(UIView *)timer.userInfo];
}

- (void)gt_handleToastTapped:(UITapGestureRecognizer *)recognizer {
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(self, &GTToastTimerKey);
    [timer invalidate];
    
    void (^callback)(void) = objc_getAssociatedObject(self, &GTToastTapCallbackKey);
    if (callback) {
        callback();
    }
    [self gt_hideToast:recognizer.view];
}

#pragma mark - Toast Activity Methods

- (void)gt_makeToastActivity {
    [self gt_makeToastActivity:GTToastActivityDefaultPosition];
}

- (void)gt_makeToastActivity:(id)position {
    // sanity
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &GTToastActivityViewKey);
    if (existingActivityView != nil) return;
    
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GTToastActivityWidth, GTToastActivityHeight)];
    activityView.center = [self gt_centerPointForPosition:position withToast:activityView];
    activityView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:GTToastOpacity];
    activityView.alpha = 0.0;
    activityView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    activityView.layer.cornerRadius = GTToastCornerRadius;
    
    if (GTToastDisplayShadow) {
        activityView.layer.shadowColor = [UIColor blackColor].CGColor;
        activityView.layer.shadowOpacity = GTToastShadowOpacity;
        activityView.layer.shadowRadius = GTToastShadowRadius;
        activityView.layer.shadowOffset = GTToastShadowOffset;
    }
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    // associate the activity view with self
    objc_setAssociatedObject (self, &GTToastActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
    
    [UIView animateWithDuration:GTToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         activityView.alpha = 1.0;
                     } completion:nil];
}

- (void)gt_hideToastActivity {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &GTToastActivityViewKey);
    if (existingActivityView != nil) {
        [UIView animateWithDuration:GTToastFadeDuration
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             existingActivityView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [existingActivityView removeFromSuperview];
                             objc_setAssociatedObject (self, &GTToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}

#pragma mark - Helpers

- (CGPoint)gt_centerPointForPosition:(id)point withToast:(UIView *)toast {
    if([point isKindOfClass:[NSString class]]) {
        if([point caseInsensitiveCompare:GTToastPositionTop] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + GTToastVerticalPadding);
        } else if([point caseInsensitiveCompare:GTToastPositionCenter] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        }
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    // default to bottom
    return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)) - GTToastVerticalPadding);
}

- (CGSize)gt_sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [string sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
}

- (UIView *)gt_viewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    // sanity
    if((message == nil) && (title == nil) && (image == nil)) return nil;

    // dynamically build a toast view with any combination of message, title, & image.
    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    
    // create the parent view
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = GTToastCornerRadius;
    
    if (GTToastDisplayShadow) {
        wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
        wrapperView.layer.shadowOpacity = GTToastShadowOpacity;
        wrapperView.layer.shadowRadius = GTToastShadowRadius;
        wrapperView.layer.shadowOffset = GTToastShadowOffset;
    }

    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:GTToastOpacity];
    
    if(image != nil) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(GTToastHorizontalPadding, GTToastVerticalPadding, GTToastImageViewWidth, GTToastImageViewHeight);
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    
    // the imageView frame values will be used to size & position the other views
    if(imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = GTToastHorizontalPadding;
    } else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    if (title != nil) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = GTToastMaxTitleLines;
        titleLabel.font = [UIFont boldSystemFontOfSize:GTToastFontSize];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.0;
        titleLabel.text = title;
        
        // size the title label according to the length of the text
        CGSize maxSizeTitle = CGSizeMake((self.bounds.size.width * GTToastMaxWidth) - imageWidth, self.bounds.size.height * GTToastMaxHeight);
        CGSize expectedSizeTitle = [self gt_sizeForString:title font:titleLabel.font constrainedToSize:maxSizeTitle lineBreakMode:titleLabel.lineBreakMode];
        titleLabel.frame = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = GTToastMaxMessageLines;
        messageLabel.font = [UIFont systemFontOfSize:GTToastFontSize];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
        // size the message label according to the length of the text
        CGSize maxSizeMessage = CGSizeMake((self.bounds.size.width * GTToastMaxWidth) - imageWidth, self.bounds.size.height * GTToastMaxHeight);
        CGSize expectedSizeMessage = [self gt_sizeForString:message font:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode];
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
    }
    
    // titleLabel frame values
    CGFloat titleWidth, titleHeight, titleTop, titleLeft;
    
    if(titleLabel != nil) {
        titleWidth = titleLabel.bounds.size.width;
        titleHeight = titleLabel.bounds.size.height;
        titleTop = GTToastVerticalPadding;
        titleLeft = imageLeft + imageWidth + GTToastHorizontalPadding;
    } else {
        titleWidth = titleHeight = titleTop = titleLeft = 0.0;
    }
    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;

    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + GTToastHorizontalPadding;
        messageTop = titleTop + titleHeight + GTToastVerticalPadding;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }

    CGFloat longerWidth = MAX(titleWidth, messageWidth);
    CGFloat longerLeft = MAX(titleLeft, messageLeft);
    
    // wrapper width uses the longerWidth or the image width, whatever is larger. same logic applies to the wrapper height
    CGFloat wrapperWidth = MAX((imageWidth + (GTToastHorizontalPadding * 2)), (longerLeft + longerWidth + GTToastHorizontalPadding));    
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + GTToastVerticalPadding), (imageHeight + (GTToastVerticalPadding * 2)));
                         
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    if(titleLabel != nil) {
        titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
        [wrapperView addSubview:titleLabel];
    }
    
    if(messageLabel != nil) {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil) {
        [wrapperView addSubview:imageView];
    }
        
    return wrapperView;
}

@end
