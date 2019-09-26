//
//  SSPlayer.h
//  MagicVideo
//
//  Created by young He on 2019/9/26.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"



NS_ASSUME_NONNULL_BEGIN

@interface SSPlayer : NSObject

+ (instancetype)manager;

@property (nonatomic, strong) ZFPlayerController *player;

@end

NS_ASSUME_NONNULL_END
