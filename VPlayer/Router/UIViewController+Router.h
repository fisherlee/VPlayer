//
//  UIViewController+Router.h
//  VPlayer
//
//  Created by liwei on 2018/5/25.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (Router)

@property (nonatomic, strong) NSDictionary *router_params;

- (void)goToTarget:(NSString *)target storyboard:(NSString *)storyboard operation:(NSInteger)operation params:(NSDictionary *)params;


@end
