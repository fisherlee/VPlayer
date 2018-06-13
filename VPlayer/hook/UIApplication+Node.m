//
//  UIApplication+Node.m
//  VPlayer
//
//  Created by liwei on 2018/4/28.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "UIApplication+Node.h"
#import "ABCRuntimeExchange.h"

@implementation UIApplication (Node)


+ (void)load
{
    NSLog(@"%@", [[UIApplication sharedApplication] keyWindow].rootViewController);
    [ABCRuntimeExchange abc_exchangeImpClass:[self class] origin_sel:@selector(sendAction:to:from:forEvent:)
                                     new_sel:@selector(abc_sendAction:to:from:forEvent:)];
    
    
}


- (BOOL)abc_sendAction:(SEL)action to:(nullable id)target from:(nullable id)sender forEvent:(nullable UIEvent *)event
{
    NSLog(@"abc_sendAction target:%@, sender:%@, action:%@, event:%@", NSStringFromClass([target class]), NSStringFromClass([sender class]), NSStringFromSelector(action), event);
    return [self abc_sendAction:action to:target from:sender forEvent:event];
}


@end
