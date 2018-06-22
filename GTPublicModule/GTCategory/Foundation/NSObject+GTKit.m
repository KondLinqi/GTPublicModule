//
//  NSObject+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/18.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "NSObject+GTKit.h"
#import <objc/objc.h>
#import <objc/runtime.h>


BOOL gt_method_swizzle(Class klass, SEL origSel, SEL altSel)
{
    if (!klass)
        return NO;

    Method __block origMethod, __block altMethod;

    void (^find_methods)(void) = ^
    {
        unsigned methodCount = 0;
        Method *methodList = class_copyMethodList(klass, &methodCount);

        origMethod = altMethod = NULL;

        if (methodList)
            for (unsigned i = 0; i < methodCount; ++i)
            {
                if (method_getName(methodList[i]) == origSel)
                    origMethod = methodList[i];

                if (method_getName(methodList[i]) == altSel)
                    altMethod = methodList[i];
            }

        free(methodList);
    };

    find_methods();

    if (!origMethod)
    {
        origMethod = class_getInstanceMethod(klass, origSel);

        if (!origMethod)
            return NO;

        if (!class_addMethod(klass, method_getName(origMethod), method_getImplementation(origMethod), method_getTypeEncoding(origMethod)))
            return NO;
    }

    if (!altMethod)
    {
        altMethod = class_getInstanceMethod(klass, altSel);

        if (!altMethod)
            return NO;

        if (!class_addMethod(klass, method_getName(altMethod), method_getImplementation(altMethod), method_getTypeEncoding(altMethod)))
            return NO;
    }

    find_methods();

    if (!origMethod || !altMethod)
        return NO;

    method_exchangeImplementations(origMethod, altMethod);

    return YES;
}

void gt_method_append(Class toClass, Class fromClass, SEL selector)
{
    if (!toClass || !fromClass || !selector)
        return;

    Method method = class_getInstanceMethod(fromClass, selector);

    if (!method)
        return;

    class_addMethod(toClass, method_getName(method), method_getImplementation(method), method_getTypeEncoding(method));
}

void gt_method_replace(Class toClass, Class fromClass, SEL selector)
{
    if (!toClass || !fromClass || ! selector)
        return;

    Method method = class_getInstanceMethod(fromClass, selector);

    if (!method)
        return;

    class_replaceMethod(toClass, method_getName(method), method_getImplementation(method), method_getTypeEncoding(method));
}


@implementation NSObject (GTKit)

/*
 NSInvocation is much slower than objc_msgSend()...
 Do not use it if you have performance issues.
 */

#define INIT_INV(_last_arg_, _return_) \
NSMethodSignature * sig = [self methodSignatureForSelector:sel]; \
if (!sig) { [self doesNotRecognizeSelector:sel]; return _return_; } \
NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig]; \
if (!inv) { [self doesNotRecognizeSelector:sel]; return _return_; } \
[inv setTarget:self]; \
[inv setSelector:sel]; \
va_list args; \
va_start(args, _last_arg_); \
[NSObject setInv:inv withSig:sig andArgs:args]; \
va_end(args);

#pragma mark - Sending messages with variable parameters

- (id)gt_performSelectorWithArgs:(SEL)sel, ...{
    INIT_INV(sel, nil);
    [inv invoke];
    return [NSObject getReturnFromInv:inv withSig:sig];
}

- (void)gt_performSelectorWithArgs:(SEL)sel afterDelay:(NSTimeInterval)delay, ...{
    INIT_INV(delay, );
    [inv retainArguments];
    [inv performSelector:@selector(invoke) withObject:nil afterDelay:delay];
}

- (id)gt_performSelectorWithArgsOnMainThread:(SEL)sel waitUntilDone:(BOOL)wait, ...{
    INIT_INV(wait, nil);
    if (!wait) [inv retainArguments];
    [inv performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:wait];
    return wait ? [NSObject getReturnFromInv:inv withSig:sig] : nil;
}

- (id)gt_performSelectorWithArgs:(SEL)sel onThread:(NSThread *)thr waitUntilDone:(BOOL)wait, ...{
    INIT_INV(wait, nil);
    if (!wait) [inv retainArguments];
    [inv performSelector:@selector(invoke) onThread:thr withObject:nil waitUntilDone:wait];
    return wait ? [NSObject getReturnFromInv:inv withSig:sig] : nil;
}

- (void)gt_performSelectorWithArgsInBackground:(SEL)sel, ...{
    INIT_INV(sel, );
    [inv retainArguments];
    [inv performSelectorInBackground:@selector(invoke) withObject:nil];
}

#undef INIT_INV

+ (id)getReturnFromInv:(NSInvocation *)inv withSig:(NSMethodSignature *)sig {
    NSUInteger length = [sig methodReturnLength];
    if (length == 0) return nil;

    char *type = (char *)[sig methodReturnType];
    while (*type == 'r' || // const
           *type == 'n' || // in
           *type == 'N' || // inout
           *type == 'o' || // out
           *type == 'O' || // bycopy
           *type == 'R' || // byref
           *type == 'V') { // oneway
        type++; // cutoff useless prefix
    }

#define return_with_number(_type_) \
do { \
_type_ ret; \
[inv getReturnValue:&ret]; \
return @(ret); \
} while (0)

    switch (*type) {
        case 'v': return nil; // void
        case 'B': return_with_number(bool);
        case 'c': return_with_number(char);
        case 'C': return_with_number(unsigned char);
        case 's': return_with_number(short);
        case 'S': return_with_number(unsigned short);
        case 'i': return_with_number(int);
        case 'I': return_with_number(unsigned int);
        case 'l': return_with_number(int);
        case 'L': return_with_number(unsigned int);
        case 'q': return_with_number(long long);
        case 'Q': return_with_number(unsigned long long);
        case 'f': return_with_number(float);
        case 'd': return_with_number(double);
        case 'D': { // long double
            long double ret;
            [inv getReturnValue:&ret];
            return [NSNumber numberWithDouble:ret];
        };

        case '@': { // id
            void *ret;
            [inv getReturnValue:&ret];
            return (__bridge id)(ret);
        };

        case '#': { // Class
            Class ret = nil;
            [inv getReturnValue:&ret];
            return ret;
        };

        default: { // struct / union / SEL / void* / unknown
            const char *objCType = [sig methodReturnType];
            char *buf = calloc(1, length);
            if (!buf) return nil;
            [inv getReturnValue:buf];
            NSValue *value = [NSValue valueWithBytes:buf objCType:objCType];
            free(buf);
            return value;
        };
    }
#undef return_with_number
}

+ (void)setInv:(NSInvocation *)inv withSig:(NSMethodSignature *)sig andArgs:(va_list)args {
    NSUInteger count = [sig numberOfArguments];
    for (int index = 2; index < count; index++) {
        char *type = (char *)[sig getArgumentTypeAtIndex:index];
        while (*type == 'r' || // const
               *type == 'n' || // in
               *type == 'N' || // inout
               *type == 'o' || // out
               *type == 'O' || // bycopy
               *type == 'R' || // byref
               *type == 'V') { // oneway
            type++; // cutoff useless prefix
        }

        BOOL unsupportedType = NO;
        switch (*type) {
            case 'v': // 1: void
            case 'B': // 1: bool
            case 'c': // 1: char / BOOL
            case 'C': // 1: unsigned char
            case 's': // 2: short
            case 'S': // 2: unsigned short
            case 'i': // 4: int / NSInteger(32bit)
            case 'I': // 4: unsigned int / NSUInteger(32bit)
            case 'l': // 4: long(32bit)
            case 'L': // 4: unsigned long(32bit)
            { // 'char' and 'short' will be promoted to 'int'.
                int arg = va_arg(args, int);
                [inv setArgument:&arg atIndex:index];
            } break;

            case 'q': // 8: long long / long(64bit) / NSInteger(64bit)
            case 'Q': // 8: unsigned long long / unsigned long(64bit) / NSUInteger(64bit)
            {
                long long arg = va_arg(args, long long);
                [inv setArgument:&arg atIndex:index];
            } break;

            case 'f': // 4: float / CGFloat(32bit)
            { // 'float' will be promoted to 'double'.
                double arg = va_arg(args, double);
                float argf = arg;
                [inv setArgument:&argf atIndex:index];
            } break;

            case 'd': // 8: double / CGFloat(64bit)
            {
                double arg = va_arg(args, double);
                [inv setArgument:&arg atIndex:index];
            } break;

            case 'D': // 16: long double
            {
                long double arg = va_arg(args, long double);
                [inv setArgument:&arg atIndex:index];
            } break;

            case '*': // char *
            case '^': // pointer
            {
                void *arg = va_arg(args, void *);
                [inv setArgument:&arg atIndex:index];
            } break;

            case ':': // SEL
            {
                SEL arg = va_arg(args, SEL);
                [inv setArgument:&arg atIndex:index];
            } break;

            case '#': // Class
            {
                Class arg = va_arg(args, Class);
                [inv setArgument:&arg atIndex:index];
            } break;

            case '@': // id
            {
                id arg = va_arg(args, id);
                [inv setArgument:&arg atIndex:index];
            } break;

            case '{': // struct
            {
                if (strcmp(type, @encode(CGPoint)) == 0) {
                    CGPoint arg = va_arg(args, CGPoint);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGSize)) == 0) {
                    CGSize arg = va_arg(args, CGSize);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGRect)) == 0) {
                    CGRect arg = va_arg(args, CGRect);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGVector)) == 0) {
                    CGVector arg = va_arg(args, CGVector);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
                    CGAffineTransform arg = va_arg(args, CGAffineTransform);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(CATransform3D)) == 0) {
                    CATransform3D arg = va_arg(args, CATransform3D);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(NSRange)) == 0) {
                    NSRange arg = va_arg(args, NSRange);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(UIOffset)) == 0) {
                    UIOffset arg = va_arg(args, UIOffset);
                    [inv setArgument:&arg atIndex:index];
                } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
                    UIEdgeInsets arg = va_arg(args, UIEdgeInsets);
                    [inv setArgument:&arg atIndex:index];
                } else {
                    unsupportedType = YES;
                }
            } break;

            case '(': // union
            {
                unsupportedType = YES;
            } break;

            case '[': // array
            {
                unsupportedType = YES;
            } break;

            default: // what?!
            {
                unsupportedType = YES;
            } break;
        }

        if (unsupportedType) {
            // Try with some dummy type...

            NSUInteger size = 0;
            NSGetSizeAndAlignment(type, &size, NULL);

#define case_size(_size_) \
else if (size <= 4 * _size_ ) { \
struct dummy { char tmp[4 * _size_]; }; \
struct dummy arg = va_arg(args, struct dummy); \
[inv setArgument:&arg atIndex:index]; \
}
            if (size == 0) { }
            case_size( 1) case_size( 2) case_size( 3) case_size( 4)
            case_size( 5) case_size( 6) case_size( 7) case_size( 8)
            case_size( 9) case_size(10) case_size(11) case_size(12)
            case_size(13) case_size(14) case_size(15) case_size(16)
            case_size(17) case_size(18) case_size(19) case_size(20)
            case_size(21) case_size(22) case_size(23) case_size(24)
            case_size(25) case_size(26) case_size(27) case_size(28)
            case_size(29) case_size(30) case_size(31) case_size(32)
            case_size(33) case_size(34) case_size(35) case_size(36)
            case_size(37) case_size(38) case_size(39) case_size(40)
            case_size(41) case_size(42) case_size(43) case_size(44)
            case_size(45) case_size(46) case_size(47) case_size(48)
            case_size(49) case_size(50) case_size(51) case_size(52)
            case_size(53) case_size(54) case_size(55) case_size(56)
            case_size(57) case_size(58) case_size(59) case_size(60)
            case_size(61) case_size(62) case_size(63) case_size(64)
            else {
                /*
                 Larger than 256 byte?! I don't want to deal with this stuff up...
                 Ignore this argument.
                 */
                struct dummy {char tmp;};
                for (int i = 0; i < size; i++) va_arg(args, struct dummy);
                NSLog(@"YYKit performSelectorWithArgs unsupported type:%s (%lu bytes)",
                      [sig getArgumentTypeAtIndex:index],(unsigned long)size);
            }
#undef case_size

        }
    }
}

- (void)gt_performSelector:(SEL)sel afterDelay:(NSTimeInterval)delay {
    [self performSelector:sel withObject:nil afterDelay:delay];
}


#pragma mark - Swap method (Swizzling)

+ (BOOL)gt_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!originalMethod || !newMethod) return NO;

    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));

    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

+ (BOOL)gt_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel {
    Class class = object_getClass(self);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod) return NO;
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}

+ (void)gt_replaceMethod:(SEL)method fromClass:(Class)klass
{
    gt_method_replace(self.class, klass, method);
}

+ (void)gt_appendMethod:(SEL)newMethod fromClass:(Class)klass
{
    gt_method_append(self.class, klass, newMethod);
}

- (BOOL)gt_respondsToSelector:(SEL)selector untilClass:(Class)stopClass
{
    return [self.class gt_instancesRespondToSelector:selector untilClass:stopClass];
}

- (BOOL)gt_superRespondsToSelector:(SEL)selector
{
    return [self.superclass instancesRespondToSelector:selector];
}

- (BOOL)gt_superRespondsToSelector:(SEL)selector untilClass:(Class)stopClass
{
    return [self.superclass gt_instancesRespondToSelector:selector untilClass:stopClass];
}

+ (BOOL)gt_instancesRespondToSelector:(SEL)selector untilClass:(Class)stopClass
{
    BOOL __block (^ __weak block_self)(Class klass, SEL selector, Class stopClass);
    BOOL (^block)(Class klass, SEL selector, Class stopClass) = [^
                                                                 (Class klass, SEL selector, Class stopClass)
                                                                 {
                                                                     if (!klass || klass == stopClass)
                                                                         return NO;

                                                                     unsigned methodCount = 0;
                                                                     Method *methodList = class_copyMethodList(klass, &methodCount);

                                                                     if (methodList)
                                                                         for (unsigned i = 0; i < methodCount; ++i)
                                                                             if (method_getName(methodList[i]) == selector)
                                                                                 return YES;

                                                                     return block_self(klass.superclass, selector, stopClass);
                                                                 } copy];

    block_self = block;

    return block(self.class, selector, stopClass);
}


#pragma mark - Associate value

- (void)gt_setAssociateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)gt_setAssociateWeakValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (void)gt_removeAssociatedValues {
    objc_removeAssociatedObjects(self);
}

- (id)gt_getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

#pragma mark - Copy

- (id)gt_deepCopy {
    id obj = nil;
    @try {
        obj = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    return obj;
}

- (id)gt_deepCopyWithArchiver:(Class)archiver unarchiver:(Class)unarchiver {
    id obj = nil;
    @try {
        obj = [unarchiver unarchiveObjectWithData:[archiver archivedDataWithRootObject:self]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    return obj;
}

@end

