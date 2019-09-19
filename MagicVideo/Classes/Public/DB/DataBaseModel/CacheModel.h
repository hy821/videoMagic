//
//  CacheModel.h
//  KSMovie
//
//  Created by young He on 2018/10/26.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheModel : NSObject
//创建
//- (instancetype)initWithModel:(VDCommonModel*)model;

@property (nonatomic,copy) NSString *albumId;  //相册id, 多集数对应同一个    pi
@property (nonatomic,copy) NSString *mediaId;  //唯一标识, 每个电影,每一集对应唯一  idForModel
@property (nonatomic,assign) VideoType videoType;
@property (nonatomic,copy) NSString *detailUrl; // analysis/url/1  掉接口 取最新下载地址

@property (nonatomic,copy) NSString *downloadUrl; // analysis/url/1 接口获取的下载地址. 可能会失效
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *cover;  //封面图的Url
//@property (nonatomic,assign) CacheStatusType status;
@property (nonatomic,copy) NSString *secretInfo;  //秘钥信息, 下载时, 解析视频时用到  暂时用不到
@property (nonatomic,copy) NSString *source;  //siCurrent  来源id
@property (nonatomic,copy) NSString *labelIds;   //categoryResults   用 , 拼接id
@property (nonatomic,copy) NSString *engine;   //MediaSource.ParseEngine engine;
@property (nonatomic,copy) NSString *indexForEpisode;  //如果是多集的, index是当前集数,第几集

@end


