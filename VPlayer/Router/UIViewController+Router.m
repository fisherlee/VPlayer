//
//  UIViewController+Router.m
//  VPlayer
//
//  Created by liwei on 2018/5/25.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "UIViewController+Router.h"
#import <objc/runtime.h>

static char kVPRoutesAssociatedObjectKey;


@implementation UIViewController (Router)

- (void)setRouter_params:(NSDictionary *)router_params
{
    objc_setAssociatedObject(self, &kVPRoutesAssociatedObjectKey, router_params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)router_params
{
    return objc_getAssociatedObject(self, &kVPRoutesAssociatedObjectKey);
}

@end
