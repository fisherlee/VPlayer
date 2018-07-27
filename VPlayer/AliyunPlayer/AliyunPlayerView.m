
//
//  AliyunPlayerView.m
//  VPlayer
//
//  Created by liwei on 2018/7/27.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "AliyunPlayerView.h"
#import <AliyunVodPlayerSDK/AliyunVodPlayerSDK.h>

@interface AliyunPlayerView ()<AliyunVodPlayerDelegate,VPlayerControlViewDelegate>

@property (nonatomic, strong) AliyunVodPlayer *aliPlayer;
@property (nonatomic, strong) VPlayerControlView *controlView;

@property (nonatomic, strong) id timeObser;

@end

@implementation AliyunPlayerView

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
    self.aliPlayer.playerView.frame = self.bounds;// self.bounds;
}

#pragma mark - 加载播放器

- (id)initWithFrame:(CGRect)frame url:(NSURL *)url
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configVodlayerWithURL:url];
        [self addControlView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame vid:(NSString *)vid
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configVodlayerWithVid:vid];
        [self addControlView];
    }
    return self;
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
}


#pragma mark -  播放器

//设置播放器
- (void)configVodlayerWithURL:(NSURL *)url
{
    [self addPlayerView];
    
    //播放方式二：使用URL播放(直播用户推荐使用)
    //NSURL *fileUrl = [NSURL fileURLWithPath:@""];//本地视频,填写文件路径
    //NSURL *strUrl = @"";//网络视频，填写网络url地址
    [self.aliPlayer prepareWithURL:url];
    
    //播放方式三：使用vid+playAuth方式播放（V3.2.0之前版本使用，兼容老用户）
    //[self.aliPlayer prepareWithVid:vid playAuth:playAuth];
    
    //播放四：MPS的vid播放方式（仅限MPS用户使用）
    //[self.aliPlayer prepareWithVid:vid accId:accessKeyId accSecret:accessKeySecret stsToken:stsToken authInfo:authInfo region:region playDomain:playDomain mtsHlsUriToken:mtsHlsUriToken];
    
}

- (void)configVodlayerWithVid:(NSString *)vid
{
    [self addPlayerView];
    
    //播放方式一：使用vid+STS方式播放（点播用户推荐使用）
    NSString *accessKeyId = @"";
    NSString *accessKeySecret = @"";
    NSString *securityToken = @"";
    [self.aliPlayer prepareWithVid:vid accessKeyId:accessKeyId accessKeySecret:accessKeySecret securityToken:securityToken];
}

- (void)addPlayerView
{
    [self addSubview:self.aliPlayer.playerView];
}

#pragma mark - 播放 暂停

- (void)play
{
    [self.controlView v_playerPlayingState:YES];
    self.state = VPlayerStatePlaying;
    [self.aliPlayer start];
}

- (void)pause
{
    [self.controlView v_playerPlayingState:NO];
    self.state = VPlayerStatePause;
    [self.aliPlayer pause];
}

#pragma mark - VPlayerControlViewDelegate

- (void)v_back
{
    //移除监听
    if (self.timeObser) {
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
   
}

/** 正在拖动进度条 */
- (void)v_playerDraggingSlider:(CGFloat)value
{
    
}

#pragma mark - AliyunVodPlayerDelegate

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer onEventCallback:(AliyunVodPlayerEvent)event{
    //这里监控播放事件回调
    //主要事件如下：
    switch (event) {
        case AliyunVodPlayerEventPrepareDone:
            NSLog(@"播放准备完成时触发");
            break;
        case AliyunVodPlayerEventPlay:
            NSLog(@"暂停后恢复播放时触发");
            break;
        case AliyunVodPlayerEventFirstFrame:
            NSLog(@"播放视频首帧显示出来时触发");
            break;
        case AliyunVodPlayerEventPause:
            NSLog(@"视频暂停时触发");
            break;
        case AliyunVodPlayerEventStop:
            NSLog(@"主动使用stop接口时触发");
            break;
        case AliyunVodPlayerEventFinish:
            NSLog(@"视频正常播放完成时触发");
            break;
        case AliyunVodPlayerEventBeginLoading:
            NSLog(@"视频开始载入时触发");
            break;
        case AliyunVodPlayerEventEndLoading:
            NSLog(@"视频加载完成时触发");
            break;
        case AliyunVodPlayerEventSeekDone:
            NSLog(@"视频Seek完成时触发");
            break;
        default:
            break;
    }
}

/**
 * 功能：播放器播放时发生错误时，回调信息
 * 参数：errorModel 播放器报错时提供的错误信息对象
 */
- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer playBackErrorModel:(AliyunPlayerVideoErrorModel *)errorModel
{
    NSLog(@"error: %@", errorModel.errorMsg);
}

- (void)vodPlayer:(AliyunVodPlayer*)vodPlayer willSwitchToQuality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString*)videoDefinition{
    //将要切换清晰度时触发
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer didSwitchToQuality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString*)videoDefinition{
    //清晰度切换完成后触发
}

- (void)vodPlayer:(AliyunVodPlayer*)vodPlayer failSwitchToQuality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString*)videoDefinition{
    //清晰度切换失败触发
}

- (void)onCircleStartWithVodPlayer:(AliyunVodPlayer*)vodPlayer{
    //开启循环播放功能，开始循环播放时接收此事件。
}

- (void)onTimeExpiredErrorWithVodPlayer:(AliyunVodPlayer *)vodPlayer{
    //播放器鉴权数据过期回调，出现过期可重新prepare新的地址或进行UI上的错误提醒。
}

/*
 *功能：播放过程中鉴权即将过期时提供的回调消息（过期前一分钟回调）
 *参数：videoid：过期时播放的videoId
 *参数：quality：过期时播放的清晰度，playauth播放方式和STS播放方式有效。
 *参数：videoDefinition：过期时播放的清晰度，MPS播放方式时有效。
 *备注：使用方法参考高级播放器-点播。
 */
- (void)vodPlayerPlaybackAddressExpiredWithVideoId:(NSString *)videoId quality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString*)videoDefinition{
    //鉴权有效期为2小时，在这个回调里面可以提前请求新的鉴权，stop上一次播放，prepare新的地址，seek到当前位置
}


#pragma mark - get/set

- (AliyunVodPlayer *)aliPlayer
{
    if (!_aliPlayer) {
        _aliPlayer = [[AliyunVodPlayer alloc] init];
        _aliPlayer.delegate = self;
    }
    return _aliPlayer;
}


- (void)setState:(VPlayerState)state
{
    _state = state;
}

@end
