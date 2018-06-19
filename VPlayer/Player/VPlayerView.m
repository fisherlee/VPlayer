//
//  VPlayerView.m
//  VPlayer
//
//  Created by liwei on 2018/5/28.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "VPlayerView.h"
#import<AVFoundation/AVFoundation.h>
#import "Masonry.h"

@interface VPlayerView()<VPlayerControlViewDelegate>

//@property (nonatomic, strong) AVAssetImageGenerator *imageGenertor;//视频缩略图

@property (strong, nonatomic) AVPlayer *player;//播放器
@property (strong, nonatomic) AVPlayerItem *playerItem;//播放单元
@property (strong, nonatomic) AVPlayerLayer *playerLayer;//播放界面（layer）
@property (nonatomic, strong) AVURLAsset *urlAsset;

@property (nonatomic, strong) UIView *fatherView;

@property (nonatomic, strong) VPlayerModel        *videoModel;
@property (nonatomic, strong) VPlayerControlView *controlView;

@property (strong, nonatomic) id timeObser;
@property (assign, nonatomic) BOOL isReadToPlay;//用来判断当前视频是否准备好播放。


@end;

@implementation VPlayerView

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPlayerControlView:)];
        [self addGestureRecognizer:tap];
        
        //=====
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

//加载播放
- (void)playerWithView:(UIView *)view videoModel:(VPlayerModel *)model{
    _fatherView = view;
    [self addPlayerToFatherView:view];
    
    self.videoModel = model;
}

//player添加到父视图上
- (void)addPlayerToFatherView:(UIView *)view{
    if (self.window) {
        [self removeFromSuperview];
    }
    
    [view addSubview:self];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsZero);
    }];
    
    if (!_controlView) {
        _controlView = [[VPlayerControlView alloc] init];
        _controlView.delegate = self;
        //_controlView.backgroundColor = [UIColor blackColor];
        [self addSubview:_controlView];
        
        [_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsZero);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPlayerControlView:)];
        [_controlView addGestureRecognizer:tap];
    }
}

- (void)addPlayerItemObserVer{
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:NULL];
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)addNotification{
    //播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerMovieFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}


- (void)play
{
    [self.controlView v_playerPlayingState:YES];
    [_player play];
}

- (void)pause
{
    [self.controlView v_playerPlayingState:NO];
    [_player pause];
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

/**
 添加计时器
 */
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

/**
 配置播放器
 */
- (void)configVPlayer{
    self.urlAsset = [AVURLAsset assetWithURL:self.videoModel.videoUrl];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    self.player= [AVPlayer playerWithPlayerItem:self.playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    //要把playerlayer加到视图layer之上
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    
    [self addPlayerItemObserVer];
    
    [self addNotification];
    
    //添加计时器
    [self addTimeObserve];
}

- (void)resetPlayer{
    //移除监听
    if (self.timeObser) {
        [self.player removeTimeObserver:self.timeObser];
        self.timeObser = nil;
    }
}

- (void)setupPlayerControlView
{
   
}

- (void)resetPlayControlView
{
  
}

- (void)showPlayerControlView:(UITapGestureRecognizer *)gr
{
    [UIView animateWithDuration:0.5 animations:^{
        [self setupPlayerControlView];
    }];
}

- (void)hiddenPlayerControlView:(UITapGestureRecognizer *)gr
{
    [UIView animateWithDuration:0.5 animations:^{
        [self resetPlayControlView];
    }];
}

- (void)backAction:(UIButton *)button
{
    [self resetPlayControlView];
    [self.player removeTimeObserver:_timeObser];
    if (self.backBlock) {
        self.backBlock(0);
    }
}

- (void)playAction{
    if ( self.isReadToPlay) {
        [self.player play];
    }else{
        NSLog(@"视频正在加载中");
    }
}

- (void)videoSliderAction:(UISlider *)slider{
    //slider的value值为视频的时间
    float seconds = slider.value;
    //让视频从指定的CMTime对象处播放。
    CMTime startTime = CMTimeMakeWithSeconds(seconds, self.playerItem.currentTime.timescale);
    //让视频从指定处播放
    [self.player seekToTime:startTime completionHandler:^(BOOL finished) {
        if (finished) {
            [self playAction];
        }
    }];
}

#pragma mark -

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
                NSLog(@"error 视频错误:%@", @(status));
                self.isReadToPlay = NO;
            }
            //移除监听（观察者）
            [object removeObserver:self forKeyPath:@"status"];
        }
    }else if ([object isKindOfClass:[AVPlayer class]]){
        if ([keyPath isEqualToString:@"rate"]) {
            AVPlayer *player = (AVPlayer *)object;
            if (player.rate == 0) {
                //正在暂停
            }else if (player.rate == 1){
                //正在播放
            }
            [object removeObserver:self forKeyPath:@"rate"];
        }
    }
}

#pragma mark - 通知

/**
 播放完成的通知
 */
- (void)playerMovieFinish:(NSNotification *)noti{
    
}


#pragma mark - VPlayerControlViewDelegate

- (void)v_playerPlayButtonAction{
    if (self.state == VPlayerStatePlaying) {
        [self pause];
    }else if (self.state == VPlayerStatePause){
        [self play];
    }

}

/**
 拖动进度条
 value 拖动
 */
- (void)v_playerDraggedSlider:(CGFloat)value
{
    NSInteger drageSecond = CMTimeGetSeconds(self.playerItem.duration)*value;
    [self seekToTime:drageSecond completionHandler:nil];
}

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

#pragma mark - private

@end
