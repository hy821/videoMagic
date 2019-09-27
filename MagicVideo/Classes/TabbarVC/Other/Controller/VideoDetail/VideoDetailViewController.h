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
    VideoDetailType_NoPlayer = 0, //推送or轮播图等 直接进详情页 的情况
    VideoDetailType_WithPlayer = 1 //from短视频列表(带player) 非第一个Cell

    //暂时不用,加广告后看情况用
    //    VideoDetailType_WithPlayerAdv = 2 //from短视频列表(带player) 第一个Cell  check广告
} VideoDetailType;

@interface VideoDetailViewController : HJTabViewController

//@property (nonatomic,strong) ProgramResultListModel *model;
//@property (nonatomic,strong) RecycleModel  *modelFromRecycle;  //轮播图
//@property (nonatomic,strong) WatchHistoryCacheModel *modelHistory;  //观看历史进来的
//@property (nonatomic,strong) DailyPopOutModel *modelFromDailyPopOut;  //每日弹框进来的,和轮播图类似 model里已处理

/*
 1,判断 进入详情页, player配置
 2,判断dealloc返回时, 是否Stop_Player, 回播放列表页,不用stop
 */
@property (nonatomic,assign) VideoDetailType vcType;  //进入详情页的, 如果是短视频List页带player的一定要赋值, 其他的无所谓

//返回列表页
//isChangeVideo:
//        NO 列表页cell继续播放,
//        YES:换视频了,更新player播放原来列表页cell上的视频
@property (nonatomic, copy) void(^detailVCPopCallback)(BOOL isChangeVideo);

//@property (nonatomic, copy) void(^detailVCPlayCallback)(void);  //带进来的视频, 点击重播的回调 or 播放完广告开始播放视频
//@property (nonatomic, copy) void(^detailVCPlayOverCallback)(void);  //Add---

@end
