//
//  BBPlayerViewController.m
//  VPlayer
//
//  Created by liwei on 2018/6/12.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "BBPlayerViewController.h"
#import "AliyunPlayerView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface BBPlayerViewController ()

@property (strong, nonatomic) AliyunPlayerView *playerView;

@end

@implementation BBPlayerViewController

- (void)dealloc {
    NSLog(@"dealloc: %s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    [UIView animateWithDuration:0.25 animations:^{
//        self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
//    }];
    

    
    //---
    UIView *fatherView = [[UIView alloc] init];
    [self.view addSubview:fatherView];
    
    [fatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
//    VPlayerModel *videoModel = [[VPlayerModel alloc] init];
//    videoModel.title = @"电影鉴赏";
//    videoModel.videoUrl = [NSURL URLWithString:@"https://baby-1253952110.cosbj.myqcloud.com/%5B%E8%B4%9D%E7%93%A6%E5%84%BF%E6%AD%8C%5D%E5%B0%8F%E6%98%9F%E6%98%9F.mp4"];
//
    
    NSURL *url = [NSURL URLWithString:@"https://baby-1253952110.cosbj.myqcloud.com/%5B%E8%B4%9D%E7%93%A6%E5%84%BF%E6%AD%8C%5D%E5%B0%8F%E6%98%9F%E6%98%9F.mp4"];
    _playerView = [[AliyunPlayerView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth) url:url];
    [_playerView play];
    [self.view addSubview:_playerView];

    __weak typeof(self) weakSelf = self;
    _playerView.backBlock = ^(NSInteger status) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
