//
//  WatchHistoryCacheModel.m
//  KSMovie
//
//  Created by young He on 2018/11/19.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import "WatchHistoryCacheModel.h"

@implementation WatchHistoryCacheModel
//
////创建 长视频
//- (instancetype)initWithModel:(MediaTipResultModel*)model {
//    if (self = [super init]) {
//        self.mediaId = @"";
//        self.name = model.title;
//        self.pi = model.pi;
//        self.pt = model.pt;
//        self.type = model.videoType;
//        self.urlPoster = model.coverInfo.url;
//        self.urlPosterForHistory = model.poster.url;
//        if (self.type == VideoType_Anime || self.type == VideoType_TV || self.type == VideoType_Variety) {
//            self.indexSelectForEpisode = [model.index integerValue] - 1;
//            self.mediaId = model.mediaId;
//        }
//    }return self;
//}
//
////创建 短视频    VDCommonModel---详情页   ProgramResultListModel---短视频推荐列表页
//- (instancetype)initWithShortVideoModel:(id)model {
//    if (self = [super init]) {
//        if ([model class] == [VDCommonModel class]) {
//            VDCommonModel *m = model;
//            self.name = m.name;
//            self.pi = m.idForModel;
//            self.pt = m.type;
//            self.type = m.videoType;
//            self.urlPoster = m.poster.url;
//            self.urlPosterForHistory = m.poster.url;
//        }else if ([model class] == [ProgramResultListModel class]) {
//            ProgramResultListModel *m = model;
//            self.name = m.name;
//            self.pi = m.idForModel;
//            self.pt = m.type;
//            self.type = m.videoType;
//            self.urlPoster = m.poster.url;
//            self.urlPosterForHistory = m.poster.url;
//        }
//    }return self;
//}

@end
