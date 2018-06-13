//
//  StoryboardRouter.m
//  VPlayer
//
//  Created by liwei on 2018/5/25.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "VPRouter.h"

@implementation VPRouter

+ (VPRouter *)shareInstance
{
    static VPRouter *router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[VPRouter alloc] init];
    });
    return router;
}

/**
[S:Self|ID:SS]

 **/
- (void)goToStoryboardType:(NSInteger)type target:(NSString *)target source:(id)source storyboard:(NSArray *)storyboard params:(NSDictionary *)params
{
    Class target_class = NSClassFromString(target);
    if (target_class == nil) {
        return;
    }
    Class target_super_class= [target_class superclass];
    NSString *target_super = NSStringFromClass(target_super_class);
    if (![target_super isEqualToString:@"UIViewController"]) {
        return;
    }
    UIViewController *vc = (UIViewController *)target_class;
    if (vc == nil) {
        return;
    }
    
    NSString *sbId = @"";
    if ([storyboard count] == 1) {
        sbId = storyboard[0];
        UIViewController *svc = (UIViewController *)source;
        vc = [svc.storyboard instantiateViewControllerWithIdentifier:sbId];
    }
    else if ([storyboard count] == 2) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboard[0] bundle:nil];
        sbId = storyboard[1];
        vc = [sb instantiateViewControllerWithIdentifier:sbId];
    }
    else {
        return;
    }
    

    
    
    if (type == 0) {
        id nav_class = [source parentViewController];
        if (![nav_class isKindOfClass:[UINavigationController class]]) {
            return;
        }
        UINavigationController *nav = (UINavigationController *)nav_class;
        [nav pushViewController:vc animated:YES];
    }else if (type == 1) {
        [source presentViewController:vc animated:YES completion:nil];
    }

}

@end
