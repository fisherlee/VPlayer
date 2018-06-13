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

@interface VPlayerView()

@property (strong, nonatomic) AVPlayer *player;//播放器
@property (strong, nonatomic) AVPlayerItem *playlerItem;//播放单元
@property (strong, nonatomic) AVPlayerLayer *playerLayer;//播放界面（layer）
@property (strong, nonatomic) UISlider *avSlider;//用来现实视频的播放进度，并且通过它来控制视频的快进快退。
@property (strong, nonatomic) UIView *controlView;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIScrollView *itemsScrollView;

@property (assign, nonatomic) BOOL isReadToPlay;//用来判断当前视频是否准备好播放。


@end;

@implementation VPlayerView

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        NSURL *mediaURL = [NSURL URLWithString:@"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4"];
        AVURLAsset *urlAsset = [AVURLAsset assetWithURL:mediaURL];
        _playlerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
        [_playlerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:NULL];
        [_playlerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:NULL];
        _player = [AVPlayer playerWithPlayerItem:_playlerItem];
        
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        [self.layer addSublayer:self.playerLayer];
        
        [_player play];
        
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

- (void)setupPlayerControlView
{
    _controlView = [[UIView alloc] init];
    _controlView.backgroundColor = [UIColor clearColor];
    _controlView.alpha = 1;
    [self addSubview:_controlView];
    [_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPlayerControlView:)];
    [_controlView addGestureRecognizer:tap];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setTitle:@"Back" forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(window.mas_left).offset(15);
        make.top.equalTo(window.mas_top).offset(20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    _avSlider = [[UISlider alloc] init];
    [_avSlider addTarget:self action:@selector(avSliderAction) forControlEvents:
     UIControlEventTouchUpInside|UIControlEventTouchCancel|UIControlEventTouchUpOutside];
    [window addSubview:_avSlider];
    [_avSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(window.mas_left).offset(0);
        make.right.equalTo(window.mas_right).offset(0);
        make.bottom.equalTo(window.mas_bottom).offset(-100);
        make.height.mas_equalTo(30);
    }];
    
    _itemsScrollView = [[UIScrollView alloc] init];
    _itemsScrollView.backgroundColor = [UIColor lightGrayColor];
    [window addSubview:_itemsScrollView];
    [_itemsScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(window.mas_left).offset(0);
        make.right.equalTo(window.mas_right).offset(0);
        make.bottom.equalTo(window.mas_bottom).offset(0);
        make.height.mas_equalTo(100);
    }];
}

- (void)resetPlayControlView
{
    if (_controlView) {
        [_controlView removeFromSuperview];
    }
    if (_backButton) {
        [_backButton removeFromSuperview];
    }
    if (_avSlider) {
        [_avSlider removeFromSuperview];
    }
    if (_itemsScrollView) {
        [_itemsScrollView removeFromSuperview];
    }
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

- (void)avSliderAction{
    //slider的value值为视频的时间
    float seconds = self.avSlider.value;
    //让视频从指定的CMTime对象处播放。
    CMTime startTime = CMTimeMakeWithSeconds(seconds, self.playlerItem.currentTime.timescale);
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

    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSLog(@"_playlerItem.loadedTimeRanges:%@", playerItem.loadedTimeRanges);
        [self.playlerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    }
    else if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        NSLog(@"播放开始");
        //取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] intValue];
        switch (status) {
                case AVPlayerItemStatusFailed:
                NSLog(@"item 有误");
                self.isReadToPlay = NO;
                break;
                case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准好播放了");
                self.isReadToPlay = YES;
                self.avSlider.maximumValue = playerItem.duration.value/playerItem.duration.timescale;
                break;
                case AVPlayerItemStatusUnknown:
                NSLog(@"视频资源出现未知错误");
                self.isReadToPlay = NO;
                break;
            default:
                break;
        }
        //移除监听（观察者）
        [object removeObserver:self forKeyPath:@"status"];
    }
}


@end
