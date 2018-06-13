//
//  VPlayerView.h
//  VPlayer
//
//  Created by liwei on 2018/5/28.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VPlayerBackBlock) (NSInteger status);

@interface VPlayerView : UIView

@property (nonatomic, copy) VPlayerBackBlock backBlock;

@end
