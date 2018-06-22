//
//  NSObject+GTKit.h
//  GTKit
//
//  Created by liuxc on 2018/5/18.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (GTKit)

#pragma mark - Sending messages with variable parameters
///=============================================================================
/// @name Sending messages with variable parameters
///=============================================================================

/**
 Sends a specified message to the receiver and returns the result of the message.

 @param sel    A selector identifying the message to send. If the selector is
 NULL or unrecognized, an NSInvalidArgumentException is raised.

 @param ...    Variable parameter list. Parameters type must correspond to the
 selector's method declaration, or unexpected results may occur.
 It doesn't support union or struct which is larger than 256 bytes.

 @return       An object that is the result of the message.

 @discussion   The selector's return value will be wrap as NSNumber or NSValue
 if the selector's `return type` is not object. It always returns nil
 if the selector's `return type` is void.

 Sample Code:

 // no variable args
 [view gt_performSelectorWithArgs:@selector(removeFromSuperView)];

 // variable arg is not object
 [view gt_performSelectorWithArgs:@selector(setCenter:), CGPointMake(0, 0)];

 // perform and return object
 UIImage *image = [UIImage.class gt_performSelectorWithArgs:@selector(imageWithData:scale:), data, 2.0];

 // perform and return wrapped number
 NSNumber *lengthValue = [@"hello" gt_performSelectorWithArgs:@selector(length)];
 NSUInteger length = lengthValue.unsignedIntegerValue;

 // perform and return wrapped struct
 NSValue *frameValue = [view gt_performSelectorWithArgs:@selector(frame)];
 CGRect frame = frameValue.CGRectValue;
 */
- (nullable id)gt_performSelectorWithArgs:(SEL)sel, ...;

/**
 Invokes a method of the receiver on the current thread using the default mode after a delay.

 @warning      It can't cancelled by previous request.

 @param sel    A selector identifying the message to send. If the selector is
 NULL or unrecognized, an NSInvalidArgumentException is raised immediately.

 @param delay  The minimum time before which the message is sent. Specifying
 a delay of 0 does not necessarily cause the selector to be
 performed immediately. The selector is still queued on the
 thread's run loop and performed as soon as possible.

 @param ...    Variable parameter list. Parameters type must correspond to the
 selector's method declaration, or unexpected results may occur.
 It doesn't support union or struct which is larger than 256 bytes.

 Sample Code:

 // no variable args
 [view gt_performSelectorWithArgs:@selector(removeFromSuperView) afterDelay:2.0];

 // variable arg is not object
 [view gt_performSelectorWithArgs:@selector(setCenter:), afterDelay:0, CGPointMake(0, 0)];
 */
- (void)gt_performSelectorWithArgs:(SEL)sel afterDelay:(NSTimeInterval)delay, ...;

/**
 Invokes a method of the receiver on the main thread using the default mode.

 @param sel    A selector identifying the message to send. If the selector is
 NULL or unrecognized, an NSInvalidArgumentException is raised.

 @param wait   A Boolean that specifies whether the current thread blocks until
 after the specified selector is performed on the receiver on the
 specified thread. Specify YES to block this thread; otherwise,
 specify NO to have this method return immediately.

 @param ...    Variable parameter list. Parameters type must correspond to the
 selector's method declaration, or unexpected results may occur.
 It doesn't support union or struct which is larger than 256 bytes.

 @return       While @a wait is YES, it returns object that is the result of
 the message. Otherwise return nil;

 @discussion   The selector's return value will be wrap as NSNumber or NSValue
 if the selector's `return type` is not object. It always returns nil
 if the selector's `return type` is void, or @a wait is YES.

 Sample Code:

 // no variable args
 [view gt_performSelectorWithArgsOnMainThread:@selector(removeFromSuperView), waitUntilDone:NO];

 // variable arg is not object
 [view gt_performSelectorWithArgsOnMainThread:@selector(setCenter:), waitUntilDone:NO, CGPointMake(0, 0)];
 */
- (nullable id)gt_performSelectorWithArgsOnMainThread:(SEL)sel waitUntilDone:(BOOL)wait, ...;

/**
 Invokes a method of the receiver on the specified thread using the default mode.

 @param sel    A selector identifying the message to send. If the selector is
 NULL or unrecognized, an NSInvalidArgumentException is raised.

 @param thread The thread on which to execute aSelector.

 @param wait   A Boolean that specifies whether the current thread blocks until
 after the specified selector is performed on the receiver on the
 specified thread. Specify YES to block this thread; otherwise,
 specify NO to have this method return immediately.

 @param ...    Variable parameter list. Parameters type must correspond to the
 selector's method declaration, or unexpected results may occur.
 It doesn't support union or struct which is larger than 256 bytes.

 @return       While @a wait is YES, it returns object that is the result of
 the message. Otherwise return nil;

 @discussion   The selector's return value will be wrap as NSNumber or NSValue
 if the selector's `return type` is not object. It always returns nil
 if the selector's `return type` is void, or @a wait is YES.

 Sample Code:

 [view gt_performSelectorWithArgs:@selector(removeFromSuperView) onThread:mainThread waitUntilDone:NO];

 [array  gt_performSelectorWithArgs:@selector(sortUsingComparator:)
 onThread:backgroundThread
 waitUntilDone:NO, ^NSComparisonResult(NSNumber *num1, NSNumber *num2) {
 return [num2 compare:num2];
 }];
 */
- (nullable id)gt_performSelectorWithArgs:(SEL)sel onThread:(NSThread *)thread waitUntilDone:(BOOL)wait, ...;

/**
 Invokes a method of the receiver on a new background thread.

 @param sel    A selector identifying the message to send. If the selector is
 NULL or unrecognized, an NSInvalidArgumentException is raised.

 @param ...    Variable parameter list. Parameters type must correspond to the
 selector's method declaration, or unexpected results may occur.
 It doesn't support union or struct which is larger than 256 bytes.

 @discussion   This method creates a new thread in your application, putting
 your application into multithreaded mode if it was not already.
 The method represented by sel must set up the thread environment
 just as you would for any other new thread in your program.

 Sample Code:

 [array  gt_performSelectorWithArgsInBackground:@selector(sortUsingComparator:),
 ^NSComparisonResult(NSNumber *num1, NSNumber *num2) {
 return [num2 compare:num2];
 }];
 */
- (void)gt_performSelectorWithArgsInBackground:(SEL)sel, ...;

/**
 Invokes a method of the receiver on the current thread after a delay.

 @warning     arc-performSelector-leaks

 @param sel   A selector that identifies the method to invoke. The method should
 not have a significant return value and should take no argument.
 If the selector is NULL or unrecognized,
 an NSInvalidArgumentException is raised after the delay.

 @param delay The minimum time before which the message is sent. Specifying a
 delay of 0 does not necessarily cause the selector to be performed
 immediately. The selector is still queued on the thread's run loop
 and performed as soon as possible.

 @discussion  This method sets up a timer to perform the aSelector message on
 the current thread's run loop. The timer is configured to run in
 the default mode (NSDefaultRunLoopMode). When the timer fires, the
 thread attempts to dequeue the message from the run loop and
 perform the selector. It succeeds if the run loop is running and
 in the default mode; otherwise, the timer waits until the run loop
 is in the default mode.
 */
- (void)gt_performSelector:(SEL)sel afterDelay:(NSTimeInterval)delay;


#pragma mark - Swap method (Swizzling)
///=============================================================================
/// @name Swap method (Swizzling)
///=============================================================================

/**
 Swap two instance method's implementation in one class. Dangerous, be careful.

 @param originalSel   Selector 1.
 @param newSel        Selector 2.
 @return              YES if swizzling succeed; otherwise, NO.
 */
+ (BOOL)gt_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;

/**
 Swap two class method's implementation in one class. Dangerous, be careful.

 @param originalSel   Selector 1.
 @param newSel        Selector 2.
 @return              YES if swizzling succeed; otherwise, NO.
 */
+ (BOOL)gt_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;


/**
 Append a new method to an object.

 @param newMethod Method to exchange.
 @param klass Host class.
 */
+ (void)gt_appendMethod:(SEL)newMethod fromClass:(Class)klass;

/**
 Replace a method in an object.

 @param method Method to exchange.
 @param klass Host class.
 */
+ (void)gt_replaceMethod:(SEL)method fromClass:(Class)klass;

/**
 Check whether the receiver implements or inherits a specified method up to and exluding a particular class in hierarchy.

 @param selector A selector that identifies a method.
 @param stopClass A final super class to stop quering (excluding it).
 @return YES if one of super classes in hierarchy responds a specified selector.
 */
- (BOOL)gt_respondsToSelector:(SEL)selector untilClass:(Class)stopClass;

/**
 Check whether a superclass implements or inherits a specified method.

 @param selector A selector that identifies a method.
 @return YES if one of super classes in hierarchy responds a specified selector.
 */
- (BOOL)gt_superRespondsToSelector:(SEL)selector;

/**
 Check whether a superclass implements or inherits a specified method.

 @param selector A selector that identifies a method.
 @param stopClass A final super class to stop quering (excluding it).
 @return YES if one of super classes in hierarchy responds a specified selector.
 */
- (BOOL)gt_superRespondsToSelector:(SEL)selector untilClass:(Class)stopClass;

/**
 Check whether the receiver's instances implement or inherit a specified method up to and exluding a particular class in hierarchy.

 @param selector A selector that identifies a method.
 @param stopClass A final super class to stop quering (excluding it).
 @return YES if one of super classes in hierarchy responds a specified selector.
 */
+ (BOOL)gt_instancesRespondToSelector:(SEL)selector untilClass:(Class)stopClass;

#pragma mark - Associate value
///=============================================================================
/// @name Associate value
///=============================================================================

/**
 Associate one object to `self`, as if it was a strong property (strong, nonatomic).

 @param value   The object to associate.
 @param key     The pointer to get value from `self`.
 */
- (void)gt_setAssociateValue:(nullable id)value withKey:(void *)key;

/**
 Associate one object to `self`, as if it was a weak property (week, nonatomic).

 @param value  The object to associate.
 @param key    The pointer to get value from `self`.
 */
- (void)gt_setAssociateWeakValue:(nullable id)value withKey:(void *)key;

/**
 Get the associated value from `self`.

 @param key The pointer to get value from `self`.
 */
- (nullable id)gt_getAssociatedValueForKey:(void *)key;

/**
 Remove all associated values.
 */
- (void)gt_removeAssociatedValues;


#pragma mark - Copy
///=============================================================================
/// @name Copy
///=============================================================================

/**
 Returns a copy of the instance with `NSKeyedArchiver` and ``NSKeyedUnarchiver``.
 Returns nil if an error occurs.
 */
- (nullable id)gt_deepCopy;

/**
 Returns a copy of the instance use archiver and unarchiver.
 Returns nil if an error occurs.

 @param archiver   NSKeyedArchiver class or any class inherited.
 @param unarchiver NSKeyedUnarchiver clsas or any class inherited.
 */
- (nullable id)gt_deepCopyWithArchiver:(Class)archiver unarchiver:(Class)unarchiver;

@end

NS_ASSUME_NONNULL_END
