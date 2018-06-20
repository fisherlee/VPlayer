//
//  VPlayerControlView.h
//  VPlayer
//
//  Created by liwei on 2018/6/19.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol VPlayerControlViewDelegate <NSObject>

@optional

/** 播放/暂停 */
- (void)v_playerPlayButtonAction;

/** 返回 */
- (void)v_back;

/** 拖动进度条结束 */
- (void)v_playerDraggedSlider:(CGFloat)value;

/** 正在拖动进度条 */
- (void)v_playerDraggingSlider:(CGFloat)value;

@end

@interface VPlayerControlView : UIView

@property (nonatomic, weak) id<VPlayerControlViewDelegate> delegate;

/** 播放状态 */
- (void)v_playerPlayingState:(BOOL)state;

/** 当前播放时间 */
- (void)v_playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime value:(CGFloat)value;

@end
