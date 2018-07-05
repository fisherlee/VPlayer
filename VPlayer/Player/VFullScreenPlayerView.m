//
//  VFullScreenPlayerView.m
//  VPlayer
//
//  Created by liwei on 2018/7/5.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "VFullScreenPlayerView.h"
#import<AVFoundation/AVFoundation.h>
#import "Masonry.h"

@interface VFullScreenPlayerView()<VPlayerControlViewDelegate>

//@property (nonatomic, strong) AVAssetImageGenerator *imageGenertor;//视频缩略图

@property (nonatomic, strong) AVPlayer *player;//播放器
@property (nonatomic, strong) AVPlayerItem *playerItem;//播放单元
@property (nonatomic, strong) AVPlayerLayer *playerLayer;//播放界面（layer）
@property (nonatomic, strong) AVURLAsset *urlAsset;

@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) UIView *fatherView;
@property (nonatomic, strong) VPlayerControlView *controlView;

@property (nonatomic, strong) VPlayerModel *videoModel;

@property (nonatomic, strong) id timeObser;

@end

@implementation VFullScreenPlayerView

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.playerLayer.frame = self.playerView.bounds;// self.bounds;
}

#pragma mark - 加载播放器

//加载播放
- (void)playerWithView:(UIView *)view videoModel:(VPlayerModel *)model
{
    _fatherView = view;
    
    if (self.window) {
        [self removeFromSuperview];
    }
    [view addSubview:self];
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    self.videoModel = model;
    
    [self addControlView];
}

#pragma mark -  显示/隐藏控制界面

- (void)addControlView
{
    if (_controlView) {
        _controlView.alpha = 1;
    }else {
        _controlView = [[VPlayerControlView alloc] initWithFullScreen];
        _controlView.delegate = self;
        [self addSubview:_controlView];
        
        [_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsZero);
        }];
    }
    
    [_playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        //make.width.equalTo(self.mas_height).multipliedBy(16/9);
        make.centerX.equalTo(self.mas_centerX).offset(0);
    }];
}


#pragma mark - 播放 暂停
- (void)play
{
    [self.controlView v_playerPlayingState:YES];
    self.state = VPlayerStatePlaying;
    [_player play];
}

- (void)pause
{
    [self.controlView v_playerPlayingState:NO];
    self.state = VPlayerStatePause;
    [_player pause];
}

#pragma mark - 播放回调 kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        if (playerItem == nil) {
            return;
        }
        
        if ([keyPath isEqualToString:@"status"]) {
            NSLog(@"播放状态");
            AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] intValue];
            if (status == AVPlayerItemStatusReadyToPlay) {
                NSLog(@"准备播放");
                [self play];
            }else {
                self.state = VPlayerStateFailed;
                NSLog(@"error 视频错误:%@", @(status));
            }
            //移除监听（观察者）
            [object removeObserver:self forKeyPath:@"status"];
        }
    }else if ([object isKindOfClass:[AVPlayer class]]){
        if ([keyPath isEqualToString:@"rate"]) {
            AVPlayer *player = (AVPlayer *)object;
            if (player.rate == 0) {
                //暂停
                self.state = VPlayerStatePause;
            }else if (player.rate == 1){
                //播放
                self.state = VPlayerStatePlaying;
            }
            [object removeObserver:self forKeyPath:@"rate"];
        }
    }
}

#pragma mark - 通知

/**
 播放完成的通知
 */
- (void)playerMovieFinish:(NSNotification *)notice{
    
}


#pragma mark - VPlayerControlViewDelegate

- (void)v_back
{
    //移除监听
    if (self.timeObser) {
        [self.player removeTimeObserver:self.timeObser];
        self.timeObser = nil;
    }
    
    if (self.backBlock) {
        self.backBlock(0);
    }
}

- (void)v_playerPlayButtonAction
{
    if (self.state == VPlayerStatePlaying) {
        [self pause];
    }else if (self.state == VPlayerStatePause){
        [self play];
    }
}

/** 拖动进度条结束 */
- (void)v_playerDraggedSlider:(CGFloat)value
{
    NSInteger drageSecond = CMTimeGetSeconds(self.playerItem.duration)*value;
    [self seekToTime:drageSecond completionHandler:nil];
}

/** 正在拖动进度条 */
- (void)v_playerDraggingSlider:(CGFloat)value
{

}

- (void)seekToTime:(NSInteger)drageSecond completionHandler:(void (^)(BOOL))completionHandler{
    
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        __weak __typeof(self) weakSelf = self;
        
        [self.player seekToTime:CMTimeMake(drageSecond, 1) toleranceBefore:CMTimeMake(1, 1) toleranceAfter:CMTimeMake(1, 1) completionHandler:^(BOOL finished) {
            if (completionHandler) {
                completionHandler(finished);
            }
            [weakSelf.player play];
        }];
    }
    
}

#pragma mark -  播放器

//设置播放器
- (void)configVPlayer
{
    self.urlAsset = [AVURLAsset assetWithURL:self.videoModel.videoUrl];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    self.player= [AVPlayer playerWithPlayerItem:self.playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.playerView.layer insertSublayer:self.playerLayer atIndex:0];
    
    [self addPlayerItemObserVer];//回调
    [self addNotification];//通知
    [self addTimeObserve];//计时器
}

- (void)addPlayerItemObserVer{
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:NULL];
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)addNotification{
    //播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerMovieFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)addTimeObserve{
    __weak __typeof(self) weakSelf = self;
    self.timeObser = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
        AVPlayerItem *item = weakSelf.playerItem;
        //两种方式求绝对时间
        NSInteger currentTime = item.currentTime.value/item.currentTime.timescale;
        NSInteger totalTime   = (NSInteger)CMTimeGetSeconds(item.duration);
        CGFloat value = CMTimeGetSeconds(item.currentTime)/CMTimeGetSeconds(item.duration);
        [weakSelf.controlView v_playerCurrentTime:currentTime totalTime:totalTime value:value];
    }];
}


#pragma mark - get/set
- (UIView *)playerView
{
    if (!_playerView) {
        _playerView = [[UIView alloc] init];
        //_playerView.backgroundColor = [UIColor redColor];
        [self addSubview:_playerView];
    }
    return _playerView;
}

- (void)setVideoModel:(VPlayerModel *)videoModel
{
    _videoModel = videoModel;
    [self configVPlayer];
}

- (void)setState:(VPlayerState)state
{
    _state = state;
    if (state == VPlayerStateFailed) {
        NSError *error = [self.playerItem error];
        NSLog(@"播放失败: %@", error);
    }
}


@end
