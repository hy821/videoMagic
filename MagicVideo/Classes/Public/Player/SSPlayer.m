//
//  SSPlayer.m
//  MagicVideo
//
//  Created by young He on 2019/9/26.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "SSPlayer.h"

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
        self.player = [[ZFPlayerController alloc]init];
        ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
        self.player.currentPlayerManager = playerManager;
    }return self;
}

@end
