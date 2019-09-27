//
//  SSPlayer.m
//  MagicVideo
//
//  Created by young He on 2019/9/26.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "SSPlayer.h"

@interface SSPlayer ()

@end

@implementation SSPlayer

static SSPlayer *ssplayer = nil;

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ssplayer = [[SSPlayer alloc]init];
    });
    return ssplayer;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ssplayer == nil) {
            ssplayer = [super allocWithZone:zone];
        }
    });
    return ssplayer;
}

- (instancetype)init {
    self = [super init];
    if (self) {

    }return self;
}

/** 列表页---player初始化 */
- (void)playerWithScrollView:(UIScrollView *)scrollView {
    [self.player stop];
    
    self.player = [ZFPlayerController playerWithScrollView:scrollView playerManager:[[ZFAVPlayerManager alloc] init] containerViewTag:12321];
    self.player.playerDisapperaPercent = 0.8; // 0.8是消失80%时候
    self.player.WWANAutoPlay = YES; // 移动网络依然自动播放
    self.player.controlView = self.controlView;
}

/** 详情页头部---player初始化 */
- (void)playerWithContainerView:(nonnull UIView *)containerView {
    [self.player stop];
    
    self.player = [ZFPlayerController playerWithPlayerManager:[[ZFAVPlayerManager alloc] init] containerView:containerView];
    self.player.controlView = self.controlView;
}

/** 详情页controlView */
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.fullScreenOnly = YES;
    }return _controlView;
}

@end
