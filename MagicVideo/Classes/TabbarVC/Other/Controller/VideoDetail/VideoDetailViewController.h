//
//  VideoDetailViewController.h
//  KSMovie
//
//  Created by young He on 2018/9/14.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import "KSBaseViewController.h"
#import "HJTabViewController.h"
#import "WatchHistoryCacheModel.h"
#import "ZFPlayerControlView.h"

typedef enum : NSUInteger {
    VideoDetailTypeShort_NoPlayer = 0, //from 外面短视频list 直接进详情页
    VideoDetailTypeShort_WithPlayer = 1, //from短视频列表(带player) 非第一个Cell
    VideoDetailTypeShort_WithPlayerAdv = 2 //from短视频列表(带player) 第一个Cell  check广告
} VideoDetailType;

@interface VideoDetailViewController : HJTabViewController

//@property (nonatomic,strong) ProgramResultListModel *model;
//@property (nonatomic,strong) RecycleModel  *modelFromRecycle;  //轮播图
//@property (nonatomic,strong) WatchHistoryCacheModel *modelHistory;  //观看历史进来的
//@property (nonatomic,strong) DailyPopOutModel *modelFromDailyPopOut;  //每日弹框进来的,和轮播图类似 model里已处理

@property (nonatomic,assign) VideoDetailType vcType;  //进入详情页的, 如果是短视频List页带player的一定要赋值, 其他的无所谓
@property (nonatomic, strong) ZFPlayerController *player;

//ZF block
@property (nonatomic, copy) void(^detailVCPopCallback)(void);
@property (nonatomic, copy) void(^detailVCPlayCallback)(void);  //带进来的视频, 点击重播的回调 or 播放完广告开始播放视频
//@property (nonatomic, copy) void(^detailVCPlayOverCallback)(void);  //Add---

@end
