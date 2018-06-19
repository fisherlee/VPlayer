//
//  VPlayerControlView.m
//  VPlayer
//
//  Created by liwei on 2018/6/19.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "VPlayerControlView.h"
#import "Masonry.h"

@interface VPlayerControlView()

//@property (strong, nonatomic) UIProgressView *videoProgress;
@property (strong, nonatomic) UISlider *videoSlider;//播放进度
@property (strong, nonatomic) UIView *controlView;//
@property (nonatomic, strong) UIButton *startButton;//开始播放按钮
@property (strong, nonatomic) UIButton *backButton;//返回按钮
@property (strong, nonatomic) UIView *bottomView;//底部视图
@property (strong, nonatomic) UIScrollView *itemsView;//视频列表
@property (strong, nonatomic) UILabel *timeLabel;//播放时间
@property (strong, nonatomic) UILabel *totalTimeLabel;//视频总时间

@end

@implementation VPlayerControlView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.bottomView];
        [self addSubview:self.backButton];
        [self.bottomView addSubview:self.startButton];
        [self.bottomView addSubview:self.timeLabel];
        [self.bottomView addSubview:self.totalTimeLabel];
        [self.bottomView addSubview:self.videoSlider];
        [self.bottomView addSubview:self.itemsView];
        
        //添加约束
        [self makeSubViewConstraints];
    }
    return self;
}

//添加控件约束
- (void)makeSubViewConstraints
{
    CGFloat b_height = 135;
    CGFloat items_height = 100;
    CGFloat silder_height = 30;
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
 
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(b_height);
    }];
    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).offset(5);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-items_height);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startButton.mas_right).offset(5);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-items_height);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(silder_height);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView.mas_right).offset(-5);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-items_height);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(silder_height);
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right).offset(5);
        make.right.equalTo(self.totalTimeLabel.mas_left).offset(-5);
        //make.centerX.equalTo(weakSelf.videoProgress.mas_centerX).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-100);
        make.height.mas_equalTo(30);
    }];

    [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).offset(0);
        make.right.equalTo(self.bottomView.mas_right).offset(0);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(0);
        make.height.mas_equalTo(items_height);
    }];
}

/** 播放状态 */
- (void)v_playerPlayingState:(BOOL)state
{
    self.startButton.selected = state;
}

/** 当前播放时间 */
- (void)v_playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime value:(CGFloat)value
{
    //如果正在拖动，不自动进行
    self.videoSlider.value = value;
    
    self.timeLabel.text = [self convertPlayTime:currentTime];
    self.totalTimeLabel.text = [self convertPlayTime:totalTime];
}

- (NSString *)convertPlayTime:(CGFloat)time{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (time/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:date];
    return showtimeNew;
}

#pragma mark - control

- (void)sliderTouchBegan:(UISlider *)slider
{
    
}

- (void)sliderTouchChange:(UISlider *)slider
{
    if ([self.delegate respondsToSelector:@selector(v_playerDraggingSlider:)]) {
        [self.delegate v_playerDraggingSlider:slider.value];
    }
}

- (void)sliderTouchEnd:(UISlider *)slider
{
    if ([self.delegate respondsToSelector:@selector(v_playerDraggedSlider:)]) {
        [self.delegate v_playerDraggedSlider:slider.value];
    }
}

- (void)videoBackAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(v_back)]) {
        [self.delegate v_back];
    }
}

- (void)startButtonClick:(UIButton *)button{
    button.selected = !button.selected;
    if ([self.delegate respondsToSelector:@selector(v_playerPlayButtonAction)]) {
        [self.delegate v_playerPlayButtonAction];
    }
}


#pragma mark - private

- (UISlider *)videoSlider
{
    if (!_videoSlider) {
        _videoSlider = [[UISlider alloc] init];
        _videoSlider.minimumValue = 0;
        _videoSlider.maximumValue = 1;
        _videoSlider.enabled = NO;
        //[_videoSlider addTarget:self action:@selector(sliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        //[_videoSlider addTarget:self action:@selector(sliderTouchChange:) forControlEvents:UIControlEventValueChanged];
        //[_videoSlider addTarget:self action:@selector(sliderTouchEnd:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    return _videoSlider;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setTitle:@"Back" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(videoBackAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)startButton
{
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_startButton setTitle:@"播放" forState:UIControlStateNormal];
        [_startButton setTitle:@"暂停" forState:UIControlStateSelected];
        [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_startButton addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor lightGrayColor];
        _bottomView.alpha = 0.5;
    }
    return _bottomView;
}

- (UIScrollView *)itemsView
{
    if (!_itemsView) {
        _itemsView = [[UIScrollView alloc] init];
        _itemsView.backgroundColor = [UIColor lightGrayColor];
    }
    return _itemsView;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.adjustsFontSizeToFitWidth = YES;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor whiteColor];
    }
    return _timeLabel;
}

- (UILabel *)totalTimeLabel
{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.adjustsFontSizeToFitWidth = YES;
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.font = [UIFont systemFontOfSize:13];
        _totalTimeLabel.textColor = [UIColor whiteColor];
    }
    return _totalTimeLabel;
}

@end
