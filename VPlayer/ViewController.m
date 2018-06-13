//
//  ViewController.m
//  VPlayer
//
//  Created by liwei on 2018/4/27.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "ViewController.h"
#import "VPRouter.h"
//#import "BBPlayerViewController.h"
#import "UIViewController+Router.h"

static NSString * const play_url_string = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)avPlayerVCAction:(id)sender
{

}

- (IBAction)avPlayerCustomAction:(id)sender
{
    [[VPRouter shareInstance] goToStoryboardType:1
                                          target:@"BBPlayerViewController"
                                          source:self
                                      storyboard:@[@"kBBPlayerStoryboardId"]
                                          params:nil];
    //BBPlayerViewController *bbPlayer = [[BBPlayerViewController alloc] init];
    //[self presentViewController:bbPlayer animated:YES completion:nil];
}

- (IBAction)zfPlayerCustomAction:(id)sender
{
    [[VPRouter shareInstance] goToStoryboardType:0
                                          target:@"MoviePlayerViewController"
                                          source:self
                                      storyboard:@[@"Video", @"kMoviePlayerStoryboardId"]
                                          params:nil];
}

@end
