//
//  ABCExchange.h
//  VPlayer
//
//  Created by liwei on 2018/4/28.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface ABCRuntimeExchange : NSObject

+ (void)abc_exchangeImpClass:(Class)cls origin_sel:(SEL)origin_sel new_sel:(SEL)new_sel;

@end
