//
//  UIBarButtonItem+GTKit.m
//  GTKit
//
//  Created by liuxc on 2018/5/19.
//  Copyright © 2018年 liuxc. All rights reserved.
//

#import "UIBarButtonItem+GTKit.h"
#import <objc/runtime.h>

static const int block_key;

@interface _GTUIBarButtonItemBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);

- (id)initWithBlock:(void (^)(id sender))block;
- (void)invoke:(id)sender;

@end

@implementation _GTUIBarButtonItemBlockTarget

- (id)initWithBlock:(void (^)(id sender))block{
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

- (void)invoke:(id)sender {
    if (self.block) self.block(sender);
}

@end

@implementation UIBarButtonItem (GTKit)

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image
                                  highImage:(UIImage *)highImage
                                     target:(id)target
                                     action:(SEL)action
                           forControlEvents:(UIControlEvents)controlEvents

{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [btn sizeToFit];
    
    [btn addTarget:target action:action forControlEvents:controlEvents];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}


- (void)setGt_actionBlock:(void (^)(id sender))block {
    _GTUIBarButtonItemBlockTarget *target = [[_GTUIBarButtonItemBlockTarget alloc] initWithBlock:block];
    objc_setAssociatedObject(self, &block_key, target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setTarget:target];
    [self setAction:@selector(invoke:)];
}

- (void (^)(id)) gt_actionBlock {
    _GTUIBarButtonItemBlockTarget *target = objc_getAssociatedObject(self, &block_key);
    return target.block;
}

@end
