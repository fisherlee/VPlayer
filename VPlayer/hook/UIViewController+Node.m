//
//  UIViewController+Node.m
//  VPlayer
//
//  Created by liwei on 2018/4/27.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "UIViewController+Node.h"
#import "ABCRuntimeExchange.h"

@implementation UIViewController (Node)


+ (void)load
{
    [ABCRuntimeExchange abc_exchangeImpClass:[self class]
                                origin_sel:@selector(viewWillAppear:)
                                   new_sel:@selector(abc_viewWillAppear:)];
    [ABCRuntimeExchange abc_exchangeImpClass:[self class]
                                origin_sel:@selector(viewDidDisappear:)
                                   new_sel:@selector(abc_viewDidDisappear:)];
    [ABCRuntimeExchange abc_exchangeImpClass:[self class]
                                  origin_sel:@selector(didReceiveMemoryWarning)
                                     new_sel:@selector(abc_didReceiveMemoryWarning)];
}

- (void)abc_didReceiveMemoryWarning
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSLog(@" -------- abc_didReceiveMemoryWarning %@ %@ --------",NSStringFromClass([self class]), dateStr);
    [self abc_didReceiveMemoryWarning];
}

- (void)abc_viewWillAppear:(BOOL)animated
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSLog(@" -------- abc_viewWillAppear start %@ --------", dateStr);
    Class self_cls = [self class];
//    if (![NSStringFromClass(self_cls) isEqualToString:@"PlayerCustomViewController"]) {
//        return;
//    }
    Class super_cls = [self superclass];
    NSLog(@"self: %@; super: %@", NSStringFromClass(self_cls), NSStringFromClass(super_cls));
    NSArray *childs = [self childViewControllers];
    for (id obj in childs) {
        if ([obj isKindOfClass:[UIViewController class]]) {
            Class child_cls = [(UIViewController *)obj class];
            NSLog(@"child: %@", NSStringFromClass(child_cls));
        }
    }
    NSArray *subViews = [self.view subviews];
    for (id obj in subViews) {
        NSLog(@"subViews: %@", [obj class]);
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            NSLog(@"subViews button: %@[%@] (%@)", btn.titleLabel.text, @(btn.tag), btn);
        }
    }
    
    NSLog(@" -------- abc_viewWillAppear end --------");
    [self abc_viewDidDisappear:YES];
}

- (void)abc_viewDidDisappear:(BOOL)animated
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSLog(@" -------- abc_viewDidDisappear %@ %@ --------",NSStringFromClass([self class]), dateStr);
    [self abc_viewDidDisappear:YES];
}


@end
