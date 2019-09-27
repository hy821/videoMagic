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
@property (nonatomic, strong) ZFPlayerControlView *controlView;

/** 列表页player初始化 */
- (void)playerWithScrollView:(UIScrollView *)scrollView;

/** 详情页player初始化 */
- (void)playerWithContainerView:(nonnull UIView *)containerView;

@end

NS_ASSUME_NONNULL_END
