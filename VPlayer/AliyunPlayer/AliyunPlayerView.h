//
//  AliyunPlayerView.h
//  VPlayer
//
//  Created by liwei on 2018/7/27.
//  Copyright © 2018年 liwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPlayerConfig.h"

@interface AliyunPlayerView : UIView

@property (nonatomic, copy) VPlayerBackBlock backBlock;
@property (nonatomic, assign) VPlayerState state;

- (id)initWithFrame:(CGRect)frame url:(NSURL *)url;
- (id)initWithFrame:(CGRect)frame vid:(NSString *)vid;

/**播放**/
- (void)play;

/**暂停**/
- (void)pause;

@end
