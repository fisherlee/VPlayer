//
//  ABCExchange.m
//  VPlayer
//
//  Created by liwei on 2018/4/28.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "ABCRuntimeExchange.h"

@implementation ABCRuntimeExchange

#pragma mark - exchange imp class

+ (void)abc_exchangeImpClass:(Class)cls origin_sel:(SEL)origin_sel new_sel:(SEL)new_sel {
    
    Method origin_method = class_getInstanceMethod(cls, origin_sel);
    Method new_method = class_getInstanceMethod(cls, new_sel);
    
    BOOL add = class_addMethod(cls, origin_sel, method_getImplementation(new_method), method_getTypeEncoding(new_method));
    if (add) {
        class_replaceMethod(cls, new_sel, method_getImplementation(origin_method), method_getTypeEncoding(origin_method));
    }else {
        method_exchangeImplementations(origin_method, new_method);
    }
}


@end
