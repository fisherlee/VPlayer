//
//  ViewController.m
//  VPlayer
//
//  Created by liwei on 2018/4/27.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "ViewController.h"

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
    [self goToTarget:@"AVPViewController" storyboard:@"Main|kAVPStoryboardId" operation:1 params:@{@"title":@"AVP"}];
}

- (IBAction)avPlayerCustomAction:(id)sender
{
    [self goToTarget:@"BBPlayerViewController" storyboard:@"kBBPlayerStoryboardId" operation:1 params:nil];
}

- (IBAction)zfPlayerCustomAction:(id)sender
{
    [self goToTarget:@"AVPViewController" storyboard:@"Main|kAVPStoryboardId" operation:0 params:@{@"title":@"ZFP"}];
}

@end
