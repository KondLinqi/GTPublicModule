//
//  UITextField+History.m
//  Demo
//
//  Created by DamonDing on 15/5/26.
//  Copyright (c) 2015年 morenotepad. All rights reserved.
//

#import "UITextField+GTHistory.h"
#import <objc/runtime.h>

#define gt_history_X(view) (view.frame.origin.x)
#define gt_history_Y(view) (view.frame.origin.y)
#define gt_history_W(view) (view.frame.size.width)
#define gt_history_H(view) (view.frame.size.height)

static char kTextFieldIdentifyKey;
static char kTextFieldHistoryviewIdentifyKey;

#define gt_ANIMATION_DURATION 0.3f
#define gt_ITEM_HEIGHT 40
#define gt_CLEAR_BUTTON_HEIGHT 45
#define gt_MAX_HEIGHT 300


@interface UITextField ()<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) UITableView *gt_historyTableView;

@end


@implementation UITextField (GTHistory)

- (NSString*)gt_identify {
    return objc_getAssociatedObject(self, &kTextFieldIdentifyKey);
}

- (void)setGt_identify:(NSString *)identify {
    objc_setAssociatedObject(self, &kTextFieldIdentifyKey, identify, OBJC_ASSOCIATION_RETAIN);
}

- (UITableView*)gt_historyTableView {
    UITableView* table = objc_getAssociatedObject(self, &kTextFieldHistoryviewIdentifyKey);
    
    if (table == nil) {
        table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITextFieldHistoryCell"];
        table.layer.borderColor = [UIColor grayColor].CGColor;
        table.layer.borderWidth = 1;
        table.delegate = self;
        table.dataSource = self;
        objc_setAssociatedObject(self, &kTextFieldHistoryviewIdentifyKey, table, OBJC_ASSOCIATION_RETAIN);
    }
    
    return table;
}

- (NSArray*)gt_loadHistroy {
    if (self.gt_identify == nil) {
        return nil;
    }

    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSDictionary* dic = [def objectForKey:@"UITextField+GTHistory"];
    
    if (dic != nil) {
        return [dic objectForKey:self.gt_identify];
    }

    return nil;
}

- (void)gt_synchronize {
    if (self.gt_identify == nil || [self.text length] == 0) {
        return;
    }
    
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSDictionary* dic = [def objectForKey:@"UITextField+GTHistory"];
    NSArray* history = [dic objectForKey:self.gt_identify];
    
    NSMutableArray* newHistory = [NSMutableArray arrayWithArray:history];
    
    __block BOOL haveSameRecord = false;
    __weak typeof(self) weakSelf = self;
    
    [newHistory enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([(NSString*)obj isEqualToString:weakSelf.text]) {
            *stop = true;
            haveSameRecord = true;
        }
    }];
    
    if (haveSameRecord) {
        return;
    }
    
    [newHistory addObject:self.text];
    
    NSMutableDictionary* dic2 = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dic2 setObject:newHistory forKey:self.gt_identify];
    
    [def setObject:dic2 forKey:@"UITextField+GTHistory"];
    
    [def synchronize];
}

- (void) gt_showHistory; {
    NSArray* history = [self gt_loadHistroy];
    
    if (self.gt_historyTableView.superview != nil || history == nil || history.count == 0) {
        return;
    }
    
    CGRect frame1 = CGRectMake(gt_history_X(self), gt_history_Y(self) + gt_history_H(self) + 1, gt_history_W(self), 1);
    CGRect frame2 = CGRectMake(gt_history_X(self), gt_history_Y(self) + gt_history_H(self) + 1, gt_history_W(self), MIN(gt_MAX_HEIGHT, gt_ITEM_HEIGHT * history.count + gt_CLEAR_BUTTON_HEIGHT));
    
    self.gt_historyTableView.frame = frame1;
    
    [self.superview addSubview:self.gt_historyTableView];
    
    [UIView animateWithDuration:gt_ANIMATION_DURATION animations:^{
        self.gt_historyTableView.frame = frame2;
    }];
}

- (void) gt_clearHistoryButtonClick:(UIButton*) button {
    [self gt_clearHistory];
    [self gt_hideHistroy];
}

- (void)gt_hideHistroy; {
    if (self.gt_historyTableView.superview == nil) {
        return;
    }

    CGRect frame1 = CGRectMake(gt_history_X(self), gt_history_Y(self) + gt_history_H(self) + 1, gt_history_W(self), 1);
    
    [UIView animateWithDuration:gt_ANIMATION_DURATION animations:^{
        self.gt_historyTableView.frame = frame1;
    } completion:^(BOOL finished) {
        [self.gt_historyTableView removeFromSuperview];
    }];
}

- (void) gt_clearHistory; {
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    
    [def setObject:nil forKey:@"UITextField+GTHistory"];
    [def synchronize];
}


#pragma mark tableview datasource
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    return [self gt_loadHistroy].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITextFieldHistoryCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITextFieldHistoryCell"];
    }
    
    cell.textLabel.text = [self gt_loadHistroy][indexPath.row];
    
    return cell;
}
#pragma clang diagnostic pop

#pragma mark tableview delegate
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section; {
    UIButton* clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(gt_clearHistoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return clearButton;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    return gt_ITEM_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section; {
    return gt_CLEAR_BUTTON_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    self.text = [self gt_loadHistroy][indexPath.row];
    [self gt_hideHistroy];
}

@end
