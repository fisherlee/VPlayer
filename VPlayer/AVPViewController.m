
//
//  AVPViewController.m
//  VPlayer
//
//  Created by liwei on 2018/6/25.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "AVPViewController.h"
#import <AliyunVodPlayerSDK/AliyunVodPlayerSDK.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface AVPViewController ()<AliyunVodPlayerDelegate>

@property (nonatomic, strong) AliyunVodPlayer *aliPlayer;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *backButton;
@property (strong, nonatomic) UISlider *videoSlider;//播放进度
@property (strong, nonatomic) UIButton *topRightButton;//顶部右侧按钮
@property (strong, nonatomic) UILabel *timeLabel;//播放时间
@property (strong, nonatomic) UILabel *totalTimeLabel;//视频总时间

@end

@implementation AVPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.router_params[@"title"];
    
    
    //获取播放器视图
    UIView *playerView = self.aliPlayer.playerView;
    playerView.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
    //添加播放器视图到需要展示的界面上
    [self.view addSubview:playerView];
    
    [self player];
    self.playButton.selected = YES;
    [self.aliPlayer start];
    
    [playerView addSubview:self.backButton];
    [playerView addSubview:self.playButton];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(playerView.mas_left).offset(20);
        make.top.equalTo(playerView.mas_top).offset(22);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(playerView.mas_left).offset(20);
        make.bottom.equalTo(playerView.mas_bottom).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)player
{
    //播放方式一：使用vid+STS方式播放（点播用户推荐使用）
    //[self.aliPlayer prepareWithVid:vid accessKeyId:accessKeyId accessKeySecret:accessKeySecret securityToken:securityToken];
    
    //播放方式二：使用URL播放(直播用户推荐使用)
    //NSURL *fileUrl = [NSURL fileURLWithPath:@""];//本地视频,填写文件路径
    NSURL *strUrl = [NSURL URLWithString:@"https://baby-1253952110.cosbj.myqcloud.com/%5B%E8%B4%9D%E7%93%A6%E5%84%BF%E6%AD%8C%5D%E5%B0%8F%E6%98%9F%E6%98%9F.mp4"];//网络视频，填写网络url地址
    NSURL *url = strUrl;
    [self.aliPlayer prepareWithURL:url];
    
    //播放方式三：使用vid+playAuth方式播放（V3.2.0之前版本使用，兼容老用户）
    //[self.aliPlayer prepareWithVid:vid playAuth:playAuth];
    
    //播放四：MPS的vid播放方式（仅限MPS用户使用）
    //[self.aliPlayer prepareWithVid:vid accId:accessKeyId accSecret:accessKeySecret stsToken:stsToken authInfo:authInfo region:region playDomain:playDomain mtsHlsUriToken:mtsHlsUriToken];
}
// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return NO;
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault; // your own style
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - button action

- (void)playerBackAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playAction:(id)sender
{
    _playButton.selected = !_playButton.selected;
    if (_playButton.selected) {
        [self.aliPlayer start];
    }else {
        [self.aliPlayer pause];
    }
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

#pragma mark - set

- (AliyunVodPlayer *)aliPlayer
{
    if (!_aliPlayer) {
        _aliPlayer = [[AliyunVodPlayer alloc] init];
        _aliPlayer.delegate = self;
    }
    return _aliPlayer;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setTitle:@"X" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(playerBackAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setTitle:@"播放" forState:UIControlStateNormal];
        [_playButton setTitle:@"暂停" forState:UIControlStateSelected];
        [_playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

@end
