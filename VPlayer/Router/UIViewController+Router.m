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


- (void)goToTarget:(NSString *)target storyboard:(NSString *)storyboard operation:(NSInteger)operation params:(NSDictionary *)params
{
    Class target_class = NSClassFromString(target);
    if (target_class == nil) {
        return;
    }
    
    UIViewController *vc = (UIViewController *)target_class;
    if (vc == nil) {
        return;
    }
    
    id source = self;
    
    if ([storyboard containsString:@"|"]) {
        NSArray *sbArr = [storyboard componentsSeparatedByString:@"|"];
        if ([sbArr count] != 2) {
            return;
        }
        UIStoryboard *sb = [UIStoryboard storyboardWithName:sbArr[0] bundle:nil];
        vc = [sb instantiateViewControllerWithIdentifier:sbArr[1]];
    }else {
        UIViewController *svc = (UIViewController *)source;
        vc = [svc.storyboard instantiateViewControllerWithIdentifier:storyboard];
    }

    vc.router_params = params;
    
    if (operation == 0) {
        id nav_class = [source parentViewController];
        if (![nav_class isKindOfClass:[UINavigationController class]]) {
            return;
        }
        UINavigationController *nav = (UINavigationController *)nav_class;
        [nav pushViewController:vc animated:YES];
    }else if (operation == 1) {
        [source presentViewController:vc animated:YES completion:nil];
    }
}

@end
