//
//  WatchHistoryCacheModel.h
//  KSMovie
//
//  Created by young He on 2018/11/19.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WatchHistoryCacheModel : NSObject
//
////创建 长视频
//- (instancetype)initWithModel:(MediaTipResultModel*)model;
//
////创建 短视频   VDCommonModel---详情页   ProgramResultListModel---短视频推荐列表页
//- (instancetype)initWithShortVideoModel:(id)model;
//
//@property (nonatomic,copy) NSString *name;
//@property (nonatomic,copy) NSString *urlPoster;  //播放未开始时的占位图
//
//@property (nonatomic,copy) NSString *pi;
//@property (nonatomic,copy) NSString *pt;
//@property (nonatomic,assign) VideoType type;
//
////长片
////如果有剧集:综艺,动漫,电视剧     选中播放的集数
////选中的播放的集数  根据这个, episodeDataArray里面的isSelect遍历处理一下
//@property (nonatomic,assign) NSInteger indexSelectForEpisode;
////剧集的mediaID, 意见反馈页面, 上报错误时用
//@property (nonatomic,copy) NSString *mediaId;
//
////记录播放时间
//@property (nonatomic, assign) NSTimeInterval saveTime;
//
////更新时间  根据这个排序
//@property (nonatomic,copy) NSString *updateTime;
//
//@property (nonatomic,copy) NSString *urlPosterForHistory;  //海报  观看历史页面用
//
////意见反馈页面用, 用来标记选中的是哪个影片
//@property (nonatomic,assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
