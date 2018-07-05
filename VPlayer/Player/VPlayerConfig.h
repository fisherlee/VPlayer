//
//  VPlayerConfig.h
//  VPlayer
//
//  Created by liwei on 2018/7/5.
//  Copyright © 2018年 liwei. All rights reserved.
//

#ifndef VPlayerConfig_h
#define VPlayerConfig_h


typedef NS_ENUM(NSInteger, VPlayerState){
    VPlayerStatePlaying = 1,
    VPlayerStatePause,
    VPlayerStateFailed,
    VPlayerStateBuffering
};


typedef void(^VPlayerBackBlock) (NSInteger status);
typedef void(^VPlayerTopRightBlock) (UIButton *button);

#endif /* VPlayerConfig_h */
