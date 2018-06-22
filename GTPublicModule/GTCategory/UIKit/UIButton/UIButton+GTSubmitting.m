//
//  UIButton+Submitting.m
//  FXCategories
//
//  Created by foxsofter on 15/4/2.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//

#import "UIButton+GTSubmitting.h"
#import  <objc/runtime.h>

@interface UIButton ()

@property(nonatomic, strong) UIView *gt_modalView;
@property(nonatomic, strong) UIActivityIndicatorView *gt_spinnerView;
@property(nonatomic, strong) UILabel *gt_spinnerTitleLabel;

@end

@implementation UIButton (GTSubmitting)

- (void)gt_beginSubmitting:(NSString *)title {
    [self gt_endSubmitting];
    
    self.gt_submitting = @YES;
    self.hidden = YES;
    
    self.gt_modalView = [[UIView alloc] initWithFrame:self.frame];
    self.gt_modalView.backgroundColor =
    [self.backgroundColor colorWithAlphaComponent:0.6];
    self.gt_modalView.layer.cornerRadius = self.layer.cornerRadius;
    self.gt_modalView.layer.borderWidth = self.layer.borderWidth;
    self.gt_modalView.layer.borderColor = self.layer.borderColor;
    
    CGRect viewBounds = self.gt_modalView.bounds;
    self.gt_spinnerView = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.gt_spinnerView.tintColor = self.titleLabel.textColor;
    
    CGRect spinnerViewBounds = self.gt_spinnerView.bounds;
    self.gt_spinnerView.frame = CGRectMake(
                                        15, viewBounds.size.height / 2 - spinnerViewBounds.size.height / 2,
                                        spinnerViewBounds.size.width, spinnerViewBounds.size.height);
    self.gt_spinnerTitleLabel = [[UILabel alloc] initWithFrame:viewBounds];
    self.gt_spinnerTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.gt_spinnerTitleLabel.text = title;
    self.gt_spinnerTitleLabel.font = self.titleLabel.font;
    self.gt_spinnerTitleLabel.textColor = self.titleLabel.textColor;
    [self.gt_modalView addSubview:self.gt_spinnerView];
    [self.gt_modalView addSubview:self.gt_spinnerTitleLabel];
    [self.superview addSubview:self.gt_modalView];
    [self.gt_spinnerView startAnimating];
}

- (void)gt_endSubmitting {
    if (!self.isGTSubmitting.boolValue) {
        return;
    }
    
    self.gt_submitting = @NO;
    self.hidden = NO;
    
    [self.gt_modalView removeFromSuperview];
    self.gt_modalView = nil;
    self.gt_spinnerView = nil;
    self.gt_spinnerTitleLabel = nil;
}

- (NSNumber *)isGTSubmitting {
    return objc_getAssociatedObject(self, @selector(setGt_submitting:));
}

- (void)setGt_submitting:(NSNumber *)submitting {
    objc_setAssociatedObject(self, @selector(setGt_submitting:), submitting, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (UIActivityIndicatorView *)gt_spinnerView {
    return objc_getAssociatedObject(self, @selector(setGt_spinnerView:));
}

- (void)setGt_spinnerView:(UIActivityIndicatorView *)spinnerView {
    objc_setAssociatedObject(self, @selector(setGt_spinnerView:), spinnerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)gt_modalView {
    return objc_getAssociatedObject(self, @selector(setGt_modalView:));

}

- (void)setGt_modalView:(UIView *)modalView {
    objc_setAssociatedObject(self, @selector(setGt_modalView:), modalView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)gt_spinnerTitleLabel {
    return objc_getAssociatedObject(self, @selector(setGt_spinnerTitleLabel:));
}

- (void)setGt_spinnerTitleLabel:(UILabel *)spinnerTitleLabel {
    objc_setAssociatedObject(self, @selector(setGt_spinnerTitleLabel:), spinnerTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
