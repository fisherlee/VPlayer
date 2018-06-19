//
//  VPlayerView.h
//  VPlayer
//
//  Created by liwei on 2018/5/28.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPlayer.h"

typedef NS_ENUM(NSInteger, VPlayerState){
    VPlayerStatePlaying = 1,
    VPlayerStatePause,
    VPlayerStateFailed,
    VPlayerStateBuffering
};



typedef void(^VPlayerBackBlock) (NSInteger status);

@interface VPlayerView : UIView

@property (nonatomic, copy) VPlayerBackBlock backBlock;
@property (nonatomic, assign) VPlayerState state;

/**加载播放器**/
- (void)playerWithView:(UIView *)view videoModel:(VPlayerModel *)model;

/**播放**/
- (void)play;

/**暂停**/
- (void)pause;

@end
