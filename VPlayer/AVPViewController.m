
//
//  AVPViewController.m
//  VPlayer
//
//  Created by liwei on 2018/6/25.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import "AVPViewController.h"

@interface AVPViewController ()

@end

@implementation AVPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.router_params[@"title"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
