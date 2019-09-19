//
//  CacheModel.m
//  KSMovie
//
//  Created by young He on 2018/10/26.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import "CacheModel.h"

@implementation CacheModel

//- (instancetype)initWithModel:(VDCommonModel*)model {
//    if (self = [super init]) {
//        _albumId = model.programId;
//        _mediaId = model.idForModel;
//        _videoType = model.videoType;
//        _name = model.name;
//        _cover = model.poster.url;
////        _status = CacheStatusType_Wait;
//        _source = model.siCurrent;
//
////        __block NSMutableArray *labIdArr = [NSMutableArray array];
////        [model.categoryResults enumerateObjectsUsingBlock:^(ZFilterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////            [labIdArr addObject:obj.idForModel];
////        }];
////        _labelIds = [labIdArr componentsJoinedByString:@","];
//
//        MediaSourceResultModel *mSource = model.mediaSourceResultList[model.indexSelectForSource];
//        MediaTipResultModel *mTip = model.episodeDataArray[model.indexSelectForEpisode];
//
//        _engine = mSource.engine;
//        _indexForEpisode = mTip.index;
//
//        if([mSource.idForModel integerValue] == -1) {  //自有源
//            _detailUrl = mTip.originLink;
//        }else {  //非自有源: 一部分可直接播 一部分要跳转
//
//            if ([mSource.engine isEqualToString:@"RE002"] && [mTip.analysisPolicy integerValue] == 1) {   //后台解析:
////                WS()
//                [USER_MANAGER analyseVideoUrlWithModel:model success:^(id response) {
//                    if (response[@"data"]) {  //解析成功, 返回不同分辨率的播放Url, 直接播放
//                        model.analyseUrlModel = [AnalyseUrlBackModel mj_objectWithKeyValues:response[@"data"]];
//                        if (model.analyseUrlModel.data.filterStream) {
//                            NSString *url = model.analyseUrlModel.data.filterStream.segs.firstObject.url;
//                            if (url.length>0) {
//                                _detailUrl =  url;
//                            }else {
//                                _detailUrl =  mTip.originLink;
//                            }
//                        }else {
//                            _detailUrl =  mTip.originLink;
//                        }
//                    }else {  //用点量解析,  目前不下载
//                        _detailUrl = mTip.originLink;
//                    }
//
//                } failure:^(NSString *errMsg) {
//                    _detailUrl = mTip.originLink;
//                }];
//            }else {
//                _detailUrl = mTip.originLink;
//            }
//        }
//    }return self;
//}

@end
