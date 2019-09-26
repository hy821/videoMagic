//
//  VideoDetailViewController.m
//  KSMovie
//
//  Created by young He on 2018/9/14.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "UIButton+Category.h"
#import "HorizenButton.h"
#import "HJTabViewControllerPlugin_TabViewBar.h"
#import "HJDefaultTabViewBar.h"
#import "LCActionSheet.h"
#import "KSBaseWebViewController.h"
#import "UILabel+Category.h"
#import <zhPopupController.h>
#import "LEEAlert.h"
#import "UIControl+recurClick.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "JQFMDB.h"
#import "UINavigationController+WXSTransition.h"


#import "VideoDetailMsgController.h"
#import "VideoDetailCommentController.h"

//#import "VideoPlayViewController.h"
//#import "ReportViewController.h"
//#import "ErrorReportViewController.h"
//#import "GoWebCountDownView.h"
//#import "EndCoverView.h"
//#import "CountDownView.h"
//#import "ShortVideoShareView.h"
//#import "AdvertisementModel.h"
//#import "GDTMobInterstitial.h"
//#import "GDTNativeExpressAd.h"
//#import "GDTNativeExpressAdView.h"

@interface VideoDetailViewController ()
<HJTabViewControllerDataSource,HJTabViewControllerDelagate,HJDefaultTabViewBarDelegate,LCActionSheetDelegate,VideoDetailCommentDelegate>
/// GDTMobInterstitialDelegate,GDTNativeExpressAdDelegete
{
    dispatch_group_t _group;
}

@property (nonatomic,strong) HJDefaultTabViewBar *tabViewBar;
@property (nonatomic,strong) HJTabViewControllerPlugin_TabViewBar *tabViewBarPlugin;
@property (nonatomic,strong) NSMutableArray * vcArr;
@property (nonatomic, weak) UIImageView *topContainerView;
@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic,strong) UIButton *playBtn;
@property (nonatomic,assign) BOOL isChangeVideo; //是否切换视频了

//@property (nonatomic,weak) EndCoverView *endCoverView;  //短视频观看结束的重播View
//@property (nonatomic,copy) NSString *pi;
//@property (nonatomic,copy) NSString *pt;
//@property (nonatomic,assign) VideoType videoType;
////Common数据源
//@property (nonatomic,strong) VDCommonModel *modelCommon;
//@property (nonatomic,assign) BOOL isOff;  //请求成功但返回model为空时, 为下架
////GuessULikeData
//@property (nonatomic, strong) NSMutableArray<ProgramResultListModel *> *likeDataArray;
//@property (nonatomic,strong) ShortVideoListModel *listModel;  //智推 猜你喜欢 data包data
//
//@property (nonatomic,assign) VideoPlayType videoPlayType;
//@property (nonatomic,copy) NSString *urlPlay;  //播放Url

@property (nonatomic, strong) ZFPlayerControlView *controlView;

////定时器 ---短视频 更新缓存播放时间
//@property (nonatomic,strong) NSTimer *timer;
////当前播放的长视频对应的MediaTipResultModel
//@property (nonatomic,strong) MediaTipResultModel *currentLongVideoModel;
////GDT_Adv_Interstitial 插屏
//@property (nonatomic,strong) AdvertisementModel *advModel;
//@property (nonatomic, strong) GDTMobInterstitial *interstitial;
//@property (nonatomic,strong) AdvertisementModel *interstitialModel;
////GDT_Adv_ShortVideoDayOnceCountDownAdv 短视频 每日首次倒计时广告
//@property (nonatomic,strong) CountDownView *countDownView;
//@property (nonatomic, strong) GDTNativeExpressAdView *expressView;
//@property (nonatomic, strong) GDTNativeExpressAd *nativeExpressAd;
//@property (nonatomic,strong) AdvertisementModel *svDayOnceModel;
////标记 续播发送埋点
//@property (nonatomic,assign) BOOL autoPlayNextForBuryPoint;

@end

@implementation VideoDetailViewController

//- (void)setModel:(ProgramResultListModel *)model {
//    _model = model;
//    self.pi = model.idForModel;
//    self.pt = model.type;
//    self.videoType = model.videoType;
//    if (model.videoType != VideoType_Short) {
//        self.vcType = VideoDetailTypeLong;
//    }else {
//        self.vcType = VideoDetailTypeShort_NoPlayer;
//    }
//}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.player.viewControllerDisappear = NO;
//
//    //如果正在播, 开启Timer
//    if (self.player.currentPlayerManager.isPlaying) {
//        if (!_timer || !_timer.isValid) {
//            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(checkTimeAction) userInfo:nil repeats:YES];
//            _timer = timer;
//            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//        }
//    }
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.player.viewControllerDisappear = YES;
//
//    //如果是短视频, 正在播, 保存一下时间
//    if (self.player.currentPlayerManager.isPlaying && self.modelCommon.videoType == VideoType_Short) {
//        [self checkTimeAction];
//    }
//
//    [[JQFMDB shareDatabase] close];
//    if (_timer) {
//        [_timer invalidate];
//        _timer = nil;
//    }
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    if (self.modelCommon) {
//        NSDictionary *dic = @{PROGRAM_ID : self.modelCommon.idForModel,
//                              PROGRAM_TYPE : self.modelCommon.type
//                              };
//        NSString *bpID = (self.modelCommon.videoType == VideoType_Short) ? BP_ShortDetailBack : BP_DetailBackClick;
//        [[BuryingPointManager shareManager] buryingPointWithEventID:bpID andParameters:dic];
//    }
//}
//
//- (void)refreshWhenLoginNoti {
//    [self firstLoadWithHud:YES];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.tabDataSource = self;
    self.tabDelegate = self;
    
//    HJDefaultTabViewBar *tabViewBar = [HJDefaultTabViewBar new];
//    tabViewBar.delegate = self;
//    tabViewBar.mj_size = CGSizeMake(ScreenWidth, VDTabHeight);
//    self.tabViewBar = tabViewBar;
//    HJTabViewControllerPlugin_TabViewBar *tabViewBarPlugin = [[HJTabViewControllerPlugin_TabViewBar alloc] initWithTabViewBar:tabViewBar delegate:nil];
//    self.tabViewBarPlugin = tabViewBarPlugin;
//    [self enablePlugin:self.tabViewBarPlugin];
    
    [self initUI];
    
    [[SSPlayer manager].player updateNoramlPlayerWithContainerView:self.topContainerView];
    [self configPlayer];
    [self upBackBtnUI];

//    BOOL isHud = (self.vcType == VideoDetailTypeShort_WithPlayer || self.vcType == VideoDetailTypeShort_WithPlayerAdv);
//    [self firstLoadWithHud:!isHud];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(iapSuccessToUpdateDataNoti:) name:IAPSuccessNoti object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWhenLoginNoti) name:LoginAndRefreshNoti object:nil];
}

- (void)initUI {
    UIImageView * topContainerView = [[UIImageView alloc]init];
    topContainerView.clipsToBounds = YES;
    topContainerView.contentMode = UIViewContentModeScaleAspectFill;
    topContainerView.userInteractionEnabled = YES;
    [self.view addSubview:topContainerView];
    self.topContainerView = topContainerView;
    [self.topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([self statusBarHeight]);
        make.left.right.equalTo(self.view);
        make.height.equalTo(VDTopViewH);
    }];
    
    self.topContainerView.image = Image_Named(@"img_user_bg");
    
    UIButton *backBtn = [UIButton buttonWithImage:Image_Named(@"back_nav") selectedImage:Image_Named(@"back_nav")];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topContainerView addSubview:backBtn];
    self.backBtn = backBtn;
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topContainerView).offset(self.sizeW(12));
        make.left.equalTo(self.topContainerView).offset(self.sizeW(12));
    }];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"playLogo"] forState:UIControlStateNormal];
    //    [playBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
    playBtn.uxy_acceptEventInterval = 2.f;
    [self.topContainerView addSubview:playBtn];
    self.playBtn = playBtn;
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topContainerView);
    }];
    
    //    EndCoverView *endCoverView = [[EndCoverView alloc]init];
    //    endCoverView.hidden = YES;
    //    [self.topContainerView addSubview:endCoverView];
    //    self.endCoverView = endCoverView;
    //    WS()
    //    self.endCoverView.replayBlock = ^{
    //        SS()
    //        if(strongSelf.videoPlayType == VideoPlayType_NoSource) {
    //            [strongSelf playAction];
    //        }else {
    //            __block NSMutableArray *labArr = [NSMutableArray array];
    //            [strongSelf.modelCommon.categoryResults enumerateObjectsUsingBlock:^(ZFilterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //                [labArr addObject:obj.idForModel];
    //            }];
    //            NSDictionary *bp_dic = @{PROGRAM_ID : strongSelf.modelCommon.idForModel,
    //                                     LABEL_ID : [labArr componentsJoinedByString:@","],
    //                                     SOURCE_ID : (strongSelf.modelCommon.mediaSourceResultList.count>0) ? strongSelf.modelCommon.mediaSourceResultList.firstObject.idForModel : @""
    //                                     };
    //            [[BuryingPointManager shareManager] buryingPointWithEventID:BP_ShortDetailReplay andParameters:bp_dic];
    //
    //            strongSelf.endCoverView.hidden = YES;
    //            strongSelf.player.currentPlayerManager.seekTime = 0;
    //            [strongSelf.player.currentPlayerManager prepareToPlay];
    //            [strongSelf.player.currentPlayerManager play];
    //            [strongSelf upBackBtnUI];
    //        }
    //    };
    //    //倒计时结束, 播放下一个视频, 相当于点击了猜你喜欢
    //    self.endCoverView.countDownNextBlock = ^{
    //        SS();
    //        strongSelf.endCoverView.hidden = YES;
    //        strongSelf.vcType = VideoDetailTypeShort_NoPlayer;
    //        if (strongSelf.likeDataArray.count>0) {
    //            //如果正在播放 停止播放
    //            if (strongSelf.player) {
    //                [strongSelf.player stop];
    //            }
    //
    //            strongSelf.autoPlayNextForBuryPoint = YES;
    //            ProgramResultListModel *m = strongSelf.likeDataArray.firstObject;
    //            strongSelf.model = m;
    //            [strongSelf firstLoadWithHud:YES];
    //
    //        }else {  //没有猜你喜欢, 重播
    //            strongSelf.player.currentPlayerManager.seekTime = 0;
    //            [strongSelf.player.currentPlayerManager prepareToPlay];
    //            [strongSelf.player.currentPlayerManager play];
    //        }
    //    };
    //    [self.endCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self.topContainerView);
    //    }];
    //
}

////更新播放相关: 第一次数据请求结束 or 切换剧集后
//- (void)refreshPlayerWithIsChangeEpisode:(BOOL)isChange {
//    if (!isChange) {  //非切换剧集
        //        //切换剧集的话,不用清空评论, 这里是非切换剧集, 就是切换影片, 所以清空评论
        //        VideoDetailCommentController * right = (VideoDetailCommentController*)self.vcArr[1];
        //        [right reloadEmptyDataWhenChangeVideo];
//
//        //UIEdgeInsetsMake 在原先的rect上内切出另一个rect出来，-为变大，+为变小
//        [self.topContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view).offset([self statusBarHeight]);
//            make.left.right.equalTo(self.view);
//            make.height.equalTo(VDTopViewH);
//        }];
//        [self upBackBtnUI];
//    }
//
//    VideoDetailMsgController *vc = self.vcArr.firstObject;
//    [vc loadDataWithCommonModel:nil isOff:nil];
//
//}

//配置player播放结束,播放失败等相关
- (void)configPlayer {
    ZFPlayerController *player = [SSPlayer manager].player;
    @weakify(self)
    player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
    player.orientationDidChanged = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        if (!isFullScreen) {
            //            if (!self.endCoverView.isHidden) {
            //                [self.topContainerView bringSubviewToFront:self.endCoverView];
            //            }
            [self upBackBtnUI];
        }
    };
    
    player.playerDidToEnd = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset) {
        @strongify(self)
        //        [self shortVideoPlayEnd];
        [self upBackBtnUI];
    };
    player.playerPlayFailed = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, id  _Nonnull error) {
        @strongify(self)
        [self upBackBtnUI];
        //        if (self.modelCommon.realUrl.length > 0) {
        //            [USER_MANAGER reportPlayFailLogWithProgramID:self.pi andVideoUrl:self.modelCommon.realUrl];
        //        }
    };
}

//#pragma mark - 首次请求数据
//- (void)firstLoadWithHud:(BOOL)isShowHud {
//    _group = dispatch_group_create();
//    if (isShowHud) {
//        SSGifShow(MainWindow, @"加载中");
//    }
//
//    [self loadDateWithAnimation:NO];
//    [self loadYouLikeData];
//
//    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
//        if (isShowHud) {SSDissMissAllGifHud(MainWindow, YES);}
//
//        //刷新VideoHeaderView
//        [self refreshPlayerWithIsChangeEpisode:NO];
//
//        //给MsgVC赋值 刷新UI
//        if (self.vcArr.firstObject) {
//            VideoDetailMsgController *vc = self.vcArr.firstObject;
//            self.modelCommon.likeDataArray = [self.likeDataArray copy];
//            [vc loadDataWithCommonModel:self.modelCommon isOff:self.isOff];
//
//            //暂无数据时, 关掉播放器
//            if (self.modelCommon.videoType == VideoType_UnKnow) {
//                if(self.player.currentPlayerManager.isPlaying) {
//                    [self.player.currentPlayerManager stop];
//                }
//            }
//        }
//    });
//}
//
//- (void)shortVideoPlay {
//    if (self.vcType == VideoDetailTypeShort_WithPlayer || self.vcType == VideoDetailTypeShort_WithPlayerAdv) {
//        if ([self.player.currentPlayerManager isPlaying]) {
//            return;
//        }
//    }
//
////    //tmpChangeHy  为了暂时查看pcrawler视频
////    MediaSourceResultModel *rm =self.modelCommon.mediaSourceResultList.firstObject;
////    MediaTipResultModel *tm = rm.mediaTipResultList.firstObject;
////    if(tm.originLink.length > 0) {
////        self.videoPlayType = VideoPlayType_PlayUrlShort;
////        [self checkNetStateBeforePlayShortVideo];
////    }else {
////        SSMBToast(@"该视频被偷走了~", MainWindow);
////        self.videoPlayType = VideoPlayType_NoSource;
////        [self shortVideoPlayEnd];
////    }
//
//    if(self.modelCommon.realUrl.length > 0) {
//        self.videoPlayType = VideoPlayType_PlayUrlShort;
//        [self checkNetStateBeforePlayShortVideo];
//    }else {
//        SSMBToast(@"该视频被偷走了~", MainWindow);
//        self.videoPlayType = VideoPlayType_NoSource;
//        [self shortVideoPlayEnd];
//    }
//
//    [self upBackBtnUI];
//}
//
////播放器--->播放短视频前的网络监测
//- (void)checkNetStateBeforePlayShortVideo {
//    //网络环境判断
//    if([[USER_MANAGER getNetWorkType] integerValue] == 0) {
//        SSMBToast(@"暂无网络,请检查网络", MainWindow);
//        return;
//    }
//    BOOL canSeeNoWifi = [[USERDEFAULTS objectForKey:CanSeeVideoNoWifi] boolValue];
//    BOOL isWifi = ([[USER_MANAGER getNetWorkType] integerValue] == 1);
//    if (!canSeeNoWifi && !isWifi) {  //不是wifi  不能在流量下播放
//        WS()
//        [LEEAlert alert].config
//        .LeeContent(@"您正在使用手机流量观看，是否继续播放？").LeeAddAction(^(LEEAction *action) {
//            action.type = LEEActionTypeDefault;
//            action.title = @"取消";
//            action.font = KFONT(16);
//            action.titleColor = KCOLOR(@"#666666");
//            action.height = 40.0f;
//            action.clickBlock = ^{
//                return;
//            };
//        })
//        .LeeAddAction(^(LEEAction *action) {
//            action.type = LEEActionTypeDefault;
//            action.title = @"确定";
//            action.titleColor = KCOLOR(@"#9246FB");
//            action.font = KFONT(16);
//            action.height = 40.0f;
//            action.clickBlock = ^{
//                [weakSelf playShortVideo];
//            };
//        })
//        .LeeShow();
//    }else {
//        [self playShortVideo];
//    }
//}
//
//#pragma mark - 播放器--->播放短视频
//- (void)playShortVideo {
//    __block NSMutableArray *labArr = [NSMutableArray array];
//    [self.modelCommon.categoryResults enumerateObjectsUsingBlock:^(ZFilterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [labArr addObject:obj.idForModel ? obj.idForModel : @""];
//    }];
//    NSDictionary *bp_dic = @{PROGRAM_ID : self.modelCommon.idForModel,
//                             LABEL_ID : [labArr componentsJoinedByString:@","],
//                             SOURCE_ID : (self.modelCommon.mediaSourceResultList.count>0) ? self.modelCommon.mediaSourceResultList.firstObject.idForModel : @""
//                             };
//
//    if (self.autoPlayNextForBuryPoint) {
//        self.autoPlayNextForBuryPoint = NO;
//        [[BuryingPointManager shareManager] buryingPointWithEventID:BP_ShortDetailAutoNext andParameters:bp_dic];
//    }
//
//    [[BuryingPointManager shareManager] buryingPointWithEventID:BP_ShortDetailPlay andParameters:bp_dic];
//
//    NSDictionary *inAppPlay_dic = @{PROGRAM_ID : self.modelCommon.idForModel,
//                                    PROGRAM_TYPE : self.modelCommon.type
//                                    };
//    [[BuryingPointManager shareManager] buryingPointWithEventID:BP_LongShortVideoPlayInApp andParameters:inAppPlay_dic];
//
//
//    //开启Timer
//    if (!_timer || !_timer.isValid) {
//        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(checkTimeAction) userInfo:nil repeats:YES];
//        _timer = timer;
//        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//    }
//
//    self.urlPlay = self.modelCommon.realUrl;
//
//    //tmpChangeHy  为了暂时查看pcrawler视频
////    MediaSourceResultModel *rm =self.modelCommon.mediaSourceResultList.firstObject;
////    MediaTipResultModel *tm = rm.mediaTipResultList.firstObject;
////    self.player.assetURL = URL(tm.originLink);
//
//    self.player.assetURL = URL(self.modelCommon.realUrl);
//
//    [self.controlView showTitle:self.modelCommon.name coverURLString:self.modelCommon.poster.url fullScreenMode:ZFFullScreenModeLandscape];
//
//    //查看是否有观看历史缓存, 有的话, 恢复时间点
//    JQFMDB *db = [JQFMDB shareDatabase];
//    if ([db jq_isExistTable:CACHE_Table]) {
//        NSString *selectStr = [NSString stringWithFormat:@"where pi = '%@'",self.modelCommon.idForModel];
//        [db jq_inDatabase:^{
//            NSArray *cacheArr = [db jq_lookupTable:CACHE_Table dicOrModel:[WatchHistoryCacheModel class] whereFormat:selectStr];
//            if (cacheArr.count>0) {
//                WatchHistoryCacheModel *mHistory = cacheArr.firstObject;
//                self.modelCommon.saveTime = mHistory.saveTime;
//                self.player.currentPlayerManager.seekTime = self.modelCommon.saveTime;
//            }
//        }];
//    }
//}
//
//#pragma mark - 短视频播放结束处理  &  短视频无播放源, 跳下一个播放
//- (void)shortVideoPlayEnd {
//    if (self.player.isFullScreen) {  //如果全屏,退出全屏, 把播放结束Viewc放在上面
//        [self.player enterFullScreen:NO animated:YES];
//    }
//
//    if(self.videoPlayType == VideoPlayType_NoSource) {
//
//    }else {
//        //更新 观看历史 的 数据库
//        WatchHistoryCacheModel *m = [[WatchHistoryCacheModel alloc]initWithShortVideoModel:self.modelCommon];
//        m.saveTime = 0;
//        m.updateTime = [Tool getCurrentTimeMillsString];
//
//        if (!m.pi || !m.pt || !m.name || m.type == VideoType_UnKnow) {
//
//        }else {
//            JQFMDB *db = [JQFMDB shareDatabase];
//
//            if ([db jq_isExistTable:CACHE_Table]) {
//                //保证线程安全查找
//                NSString *selectStr = [NSString stringWithFormat:@"where pi = '%@'",m.pi];
//                [db jq_inDatabase:^{
//                    NSArray *cacheArr = [db jq_lookupTable:CACHE_Table dicOrModel:[WatchHistoryCacheModel class] whereFormat:selectStr];
//                    if (cacheArr.count>0) {
//                        [db jq_updateTable:CACHE_Table dicOrModel:m whereFormat:selectStr];
//                    }else {
//                        [db jq_insertTable:CACHE_Table dicOrModel:m];
//                    }
//                }];
//            }else {  //如果没有表 创建表 插入数据
//                [db jq_createTable:CACHE_Table dicOrModel:[WatchHistoryCacheModel class]];
//                [db jq_insertTable:CACHE_Table dicOrModel:m];
//            }
//        }
//    }
//
//    self.player.currentPlayerManager.seekTime = 0;
//    if (self.likeDataArray.count>0) {
//        ProgramResultListModel *m = self.likeDataArray.firstObject;
//        self.endCoverView.hidden = NO;
//        [self.endCoverView startCountDownWithModel:m];
//        [self.topContainerView bringSubviewToFront:self.endCoverView];
//        [self upBackBtnUI];
//    }else {  //没有猜你喜欢, 重播
//        [self.player.currentPlayerManager prepareToPlay];
//        [self.player.currentPlayerManager play];
//    }
//}
//
////检查播放时间 更新短视频的观看历史缓存, 如果接近结束, 设置保存时间为0, 下次进入直接从头播放
//- (void)checkTimeAction {
//    //更新 观看历史 的 数据库
//    WatchHistoryCacheModel *m = [[WatchHistoryCacheModel alloc]initWithShortVideoModel:self.modelCommon];
//    if (self.player.totalTime-self.player.currentTime <= 3) {
//        m.saveTime = 0;
//    }else {
//        m.saveTime = self.player.currentTime;
//    }
//    m.updateTime = [Tool getCurrentTimeMillsString];
//
//    if (!m.pi || !m.pt || !m.name || m.type == VideoType_UnKnow) {
//
//    }else {
//        JQFMDB *db = [JQFMDB shareDatabase];
//
//        if ([db jq_isExistTable:CACHE_Table]) {
//            //保证线程安全查找
//            NSString *selectStr = [NSString stringWithFormat:@"where pi = '%@'",m.pi];
//            [db jq_inDatabase:^{
//                NSArray *cacheArr = [db jq_lookupTable:CACHE_Table dicOrModel:[WatchHistoryCacheModel class] whereFormat:selectStr];
//                if (cacheArr.count>0) {
//                    [db jq_updateTable:CACHE_Table dicOrModel:m whereFormat:selectStr];
//                }else {
//                    [db jq_insertTable:CACHE_Table dicOrModel:m];
//                }
//            }];
//        }else {  //如果没有表 创建表 插入数据
//            [db jq_createTable:CACHE_Table dicOrModel:[WatchHistoryCacheModel class]];
//            [db jq_insertTable:CACHE_Table dicOrModel:m];
//        }
//    }
//}
//
//- (void)longVideoPlay {
//    if(self.modelCommon.mediaSourceResultList.count>0) {
//        MediaSourceResultModel *mSource = self.modelCommon.mediaSourceResultList[self.modelCommon.indexSelectForSource];
//        MediaTipResultModel *mTip = self.modelCommon.episodeDataArray[self.modelCommon.indexSelectForEpisode];
//
//        if([mSource.idForModel integerValue] == -1) {  //自有源
//
//            if (mSource.playModeType == PlayModeType_NORMAL) {  //跳搜索
//
//                self.videoPlayType = VideoPlayType_WebViewSearch;
//
//            }else { // 点击播放按钮, 跳单独播放页面播放
//
//                self.videoPlayType = VideoPlayType_PlayUrlLong;
//                //Mark   ------
////                self.urlPlay = mTip.originLink;
//                NSString *str = [NSString stringWithFormat:@"%@&kfx=%@",mTip.originLink,[Tool getCurrentTimeMillsString]];
//                self.urlPlay = str;
//            }
//
//        }else {  //非自有源: 一部分解析播 一部分要跳转
//            //不解析, 跳转播放: 显示3秒倒计时
//            if (mSource.playModeType == PlayModeType_MINI_HIGH || mSource.playModeType == PlayModeType_HIGH) {
//                if (mSource.playModeType == PlayModeType_MINI_HIGH) {   //跳App内webView
//                    self.videoPlayType = VideoPlayType_WebViewPlay;
//                    self.urlPlay = mTip.originLink;   //不确定有没有
//
//                }else {  // 跳Safari
//
//                    self.videoPlayType = VideoPlayType_SafariPlay;
//                    self.urlPlay = mTip.originLink;   //不确定有没有
//
//                }
//
//            }else { //点击时 解析播放
//                if ([mSource.engine isEqualToString:@"RE002"] && [mTip.analysisPolicy integerValue] == 1) {   //后台解析:
//
//                    //后台解析失败时用
//                    self.urlPlay = mTip.originLink;
//
//                    // 点击播放按钮, 后台解析, 跳单独播放页面播放
//                    self.videoPlayType = VideoPlayType_PlayUrlAnalyseLongVideo;
//                }else {
//                    self.videoPlayType = VideoPlayType_WebViewPlay;
//                    self.urlPlay = mTip.originLink;
//                }
//            }
//        }
//
//    }else {
//        self.videoPlayType = VideoPlayType_NoSource;
//    }
//}
//
//#pragma mark - VideoMsg_CommonRequest
//- (void)loadDateWithAnimation:(BOOL)isAnimation {
//    dispatch_group_enter(_group);
//    if (isAnimation) {SSGifShow(MainWindow, @"加载中");}
//    NSDictionary *dic = @{@"pt" : self.pt ? self.pt : @"",@"pi" : self.pi ? self.pi : @""};
//    [[SSRequest request]GET:VideoDetail_CommonUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
//        if (isAnimation) {SSDissMissAllGifHud(MainWindow, YES);}
//        SSLog(@"VDCommonMsgModel:%@",response);
//        self.modelCommon = [VDCommonModel mj_objectWithKeyValues:response[@"data"]];
//        self.isOff = !self.modelCommon;
//        self.modelCommon.programId = self.pi;
//        if (self.videoType == 1 || self.videoType == 3 || self.videoType == 4) {
//            if (self.modelCommon.mediaSourceResultList.count>0) {
//                [self loadEpisodeDataWithSi:self.modelCommon.siCurrent];
//            }else {
//                [self checkWatchHistoryAndDealWithModel:self.modelCommon isPlayOver:NO];
//            }
//
//        }else {
//            if (self.modelCommon.mediaSourceResultList.count>0) {
//                self.modelCommon.episodeDataArray = self.modelCommon.mediaSourceResultList.firstObject.mediaTipResultList;
//            }
//            [self checkWatchHistoryAndDealWithModel:self.modelCommon isPlayOver:NO];
//        }
//    } failure:^(SSRequest *request, NSString *errorMsg) {
//        if (isAnimation) {SSDissMissAllGifHud(MainWindow, YES);}
//        SSMBToast(errorMsg, MainWindow);
//        self.isOff = NO;  //请求失败, 不是下架, 要显示网络失败
//        dispatch_group_leave(_group);
//    }];
//}
//
//#pragma mark - 请求下来数据之后进行这一步:  获取观看历史记录, 并处理请求下来的数据
//// isPlayOver  播放页面点击返回后, 更新数据, 不用dispatch_group_leave(_group);
//- (void)checkWatchHistoryAndDealWithModel:(VDCommonModel *)model isPlayOver:(BOOL)isPlayOver{
//    JQFMDB *db = [JQFMDB shareDatabase];
//    if ([db jq_isExistTable:CACHE_Table]) {
//        NSString *selectStr = [NSString stringWithFormat:@"where pi = '%@'",self.pi];
//        [db jq_inDatabase:^{
//            NSArray *cacheArr = [db jq_lookupTable:CACHE_Table dicOrModel:[WatchHistoryCacheModel class] whereFormat:selectStr];
//            if (cacheArr.count>0) {
//                WatchHistoryCacheModel *mHistory = cacheArr.firstObject;
//                self.modelCommon.indexSelectForEpisode = mHistory.indexSelectForEpisode;
//                if (self.modelCommon.episodeDataArray && self.modelCommon.episodeDataArray.count>0) {
//
//                    if (self.modelCommon.episodeDataArray.count > mHistory.indexSelectForEpisode) {
//
//                        [self.modelCommon.episodeDataArray enumerateObjectsUsingBlock:^(MediaTipResultModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                            obj.isSelect = (idx == mHistory.indexSelectForEpisode);
//
//                            if (idx == mHistory.indexSelectForEpisode) {
//                                obj.saveTime = mHistory.saveTime;
//                            }
//                        }];
//
//                        if (!isPlayOver) {
//                            dispatch_group_leave(_group);
//                        }
//
//                    }else {
//                        if (!isPlayOver) {
//                            dispatch_group_leave(_group);
//                        }
//                    }
//
//                }else {
//                    if (!isPlayOver) {
//                        dispatch_group_leave(_group);
//                    }
//                }
//
//            }else {
//                if (!isPlayOver) {
//                    dispatch_group_leave(_group);
//                }
//            }
//        }];
//    }else {
//        if (!isPlayOver) {
//            dispatch_group_leave(_group);
//        }
//    }
//}
//
////猜你喜欢   ps:短视频用智能推荐接口获取数据
//- (void)loadYouLikeData {
//    dispatch_group_enter(_group);
//    if(self.model.videoType == VideoType_Short) {
//        NSDictionary *programDic = @{@"pId" : self.model.idForModel,
//                                     @"keyWord" : self.model.name,
//                                     @"playTime" : @"0",
//                                     @"cursor" : @"0"
//                                     };
//        NSArray *programArr = @[programDic];
//
//        NSDictionary *dic = @{
//                              @"projectType" : @"gemini",
//                              @"columnAlias" : @"da_uar_ios_ks2",
//                              @"programUars" : programArr,
//                              @"accessType" : @"2" //1=短视频播放页 有广告  非1 = 短视频详情页猜你喜欢 无广告
//                              };
//        [[SSRequest request]POST:ShortVideoRecomListUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
//            SSLog(@"GuessULikeMsgModel:%@",response);
//
//            self.listModel = [ShortVideoListModel mj_objectWithKeyValues:response[@"data"]];
//            self.likeDataArray = [self.listModel.dataList mutableCopy];
////            self.likeDataArray = [ProgramResultListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
//            dispatch_group_leave(_group);
//
//        } failure:^(SSRequest *request, NSString *errorMsg) {
//            SSMBToast(errorMsg, MainWindow);
//            dispatch_group_leave(_group);
//        }];
//
//    }else {  //非短视频 的 猜你喜欢
//        NSDictionary *dic = @{@"pt" : self.pt ? self.pt : @"", @"pi" : self.pi ? self.pi : @"", @"size" : @(6)};
//        [[SSRequest request]GET:VideoDetail_GuessULikeUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
//
//            SSLog(@"GuessULikeMsgModel:%@",response);
//            self.likeDataArray = [ProgramResultListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
//            dispatch_group_leave(_group);
//
//        } failure:^(SSRequest *request, NSString *errorMsg) {
//            SSMBToast(errorMsg, MainWindow);
//            dispatch_group_leave(_group);
//        }];
//    }
//}
//
//- (void)loadEpisodeDataWithSi:(NSString*)si {
//    NSDictionary *dic = @{@"pt" : self.pt ? self.pt : @"",
//                          @"pi" : self.pi ? self.pi : @"",
//                          @"size" : @(1000),
//                          @"index" : @(0),
//                          @"si" : si,  //来源 默认传
//                          };
//    [[SSRequest request]GET:VideoDetail_NumberOfEpisodeUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
//
//        SSLog(@"EpisodeArrayMsgModel:%@",response);
//        self.modelCommon.episodeDataArray = [MediaTipResultModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
//        [self checkWatchHistoryAndDealWithModel:self.modelCommon isPlayOver:NO];
//
//    } failure:^(SSRequest *request, NSString *errorMsg) {
//        SSMBToast(errorMsg, MainWindow);
//        dispatch_group_leave(_group);
//    }];
//}
//
//
//#pragma mark - 播放按钮事件
//- (void)playClick {
//    //网络环境判断
//    if([[USER_MANAGER getNetWorkType] integerValue] == 0) {
//        SSMBToast(@"暂无网络,请检查网络", MainWindow);
//        return;
//    }
//    BOOL canSeeNoWifi = [[USERDEFAULTS objectForKey:CanSeeVideoNoWifi] boolValue];
//    BOOL isWifi = ([[USER_MANAGER getNetWorkType] integerValue] == 1);
//    if (!canSeeNoWifi && !isWifi) {  //不是wifi  不能在流量下播放
//        WS()
//        [LEEAlert alert].config
//        .LeeContent(@"您正在使用手机流量观看，是否继续播放？").LeeAddAction(^(LEEAction *action) {
//            action.type = LEEActionTypeDefault;
//            action.title = @"取消";
//            action.font = KFONT(16);
//            action.titleColor = KCOLOR(@"#666666");
//            action.height = 40.0f;
//            action.clickBlock = ^{
//                // 点击事件Block
//            };
//        })
//        .LeeAddAction(^(LEEAction *action) {
//            action.type = LEEActionTypeDefault;
//            action.title = @"确定";
//            action.titleColor = KCOLOR(@"#9246FB");
//            action.font = KFONT(16);
//            action.height = 40.0f;
//            action.clickBlock = ^{
//                [weakSelf playAction];
//            };
//        })
//        .LeeShow();
//    }else {
//        [self playAction];
//    }
//}
//
//- (void)playAction {
//    switch (self.videoPlayType) {
//        case VideoPlayType_PlayUrlLong:
//        {
//            MediaTipResultModel *mTip = self.modelCommon.episodeDataArray[self.modelCommon.indexSelectForEpisode];
//            self.currentLongVideoModel = mTip;
//            [self getInterstitialAdvMsg];
//        }
//            break;
//        case VideoPlayType_PlayUrlAnalyse:
//        {
//            MediaTipResultModel *mTip = [[MediaTipResultModel alloc]init];
//            self.currentLongVideoModel = mTip;
//            [self getInterstitialAdvMsg];
//        }
//            break;
//        case VideoPlayType_PlayUrlShort:
//        {
//            NSString *sss = [NSString stringWithFormat:@"%@&kfx=%@",self.modelCommon.realUrl,[Tool getCurrentTimeMillsString]];
//            self.player.assetURL = URL(sss);
//        }
//            break;
//        case VideoPlayType_SafariPlay:
//        {
//            //---3秒倒计时
//            [self showCountDownViewWithType:VideoPlayType_SafariPlay];
//        }
//            break;
//        case VideoPlayType_WebViewPlay:
//        {
//            //---3秒倒计时
//            [self showCountDownViewWithType:VideoPlayType_WebViewPlay];
//        }
//            break;
//        case VideoPlayType_PlayUrlAnalyseLongVideo:
//        {
//            [self longVideoAnalysePlay];
//        }
//            break;
//        case VideoPlayType_NoSource:
//        {
//            SSMBToast(@"暂无播放源,先把视频收藏起来吧~", MainWindow);
//            if (self.videoType == VideoType_Short) {
//                [self shortVideoPlayEnd];
//            }
//        }
//            break;
//        default:
//            break;
//    }
//
//    if (self.videoType == VideoType_Short) return;
//    //长片 埋点
//
//    NSString *sourceID = @"";
//    if (self.modelCommon.indexSelectForSource) {
//        sourceID = self.modelCommon.mediaSourceResultList[self.modelCommon.indexSelectForSource].idForModel;
//    }
//    NSDictionary *dic = @{PROGRAM_ID : self.modelCommon.idForModel,
//                              PROGRAM_TYPE : self.modelCommon.type,
//                              SOURCE_ID : sourceID
//                              };
//    NSString *bpID = @"";
//    switch (self.modelCommon.videoType) {
//        case VideoType_Movie:
//            bpID = BP_DetailMoviePlayClick;
//            break;
//        case VideoType_TV:
//            bpID = BP_DetailTVPlayClick;
//            break;
//        case VideoType_Variety:
//            bpID = BP_DetailVarietyPlayClick;
//            break;
//        case VideoType_Anime:
//            bpID = BP_DetailAnimePlayClick;
//            break;
//        default:
//            break;
//    }
//    [[BuryingPointManager shareManager] buryingPointWithEventID:bpID andParameters:dic];
//}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.fullScreenOnly = YES;
    }return _controlView;
}

-(NSMutableArray  *)vcArr {
    if(_vcArr == nil) {
        _vcArr = @[].mutableCopy;
        VideoDetailMsgController * other = [[VideoDetailMsgController alloc]initWithStyle:UITableViewStyleGrouped];
//        WS()
//        other.loadDataBlock = ^{
//            [weakSelf firstLoadWithHud:YES];
//        };
//        //切换数据源
//        other.updateDataWhenChangeSourceBlock = ^(VDCommonModel *model) {
//            weakSelf.modelCommon = model;
//        };
//        //点击猜你喜欢, 刷新本页
//        other.refreshNewVideoBlock = ^(ProgramResultListModel *model) {
//            //如果正在播放 停止播放
//            if (weakSelf.player) {
//                [weakSelf.player stop];
//            }
//            //如果正在3秒倒计时播放下一个, 销毁Timer
//            [weakSelf.endCoverView invalidateTimer];
//
//            weakSelf.model = model;
//            [weakSelf firstLoadWithHud:YES];
//        };
//        other.playBlock = ^{
//            [weakSelf playClick];
//        };

//        //评论页
//        VideoDetailCommentController * commentVC = [[VideoDetailCommentController alloc]init];
//        commentVC.delegate = self;
//        [_vcArr addObjectsFromArray:@[other,commentVC]];
        
        [_vcArr addObjectsFromArray:@[other]];
    }return _vcArr;
}

//Delegate VideoDetailCommentController
- (void)commentGoLogin {
    [USER_MANAGER gotoLoginFromVC:self];
}

#pragma mark - HJDefaultTabViewBarDelegate
- (NSInteger)numberOfTabForTabViewBar:(HJDefaultTabViewBar *)tabViewBar {
    return [self numberOfViewControllerForTabViewController:self];
}

- (NSInteger)numberOfViewControllerForTabViewController:(HJTabViewController *)tabViewController {
    return self.vcArr.count;
}

- (id)tabViewBar:(HJDefaultTabViewBar *)tabViewBar titleForIndex:(NSInteger)index {
   return (index == 0) ? @"简介" : @"评论";
}

- (void)tabViewBar:(HJDefaultTabViewBar *)tabViewBar didSelectIndex:(NSInteger)index {
    BOOL anim = labs(index - self.curIndex) > 1 ? NO: YES;
    [self scrollToIndex:index animated:anim];
}

- (UIViewController *)tabViewController:(HJTabViewController *)tabViewController viewControllerForIndex:(NSInteger)index {
    return  self.vcArr[index];
}

- (UIEdgeInsets)containerInsetsForTabViewController:(HJTabViewController *)tabViewController {
    return UIEdgeInsetsMake([self statusBarHeight]+VDTopViewH, 0, 0, 0);
//    return UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame), 0, 0, 0);
}

-(void)tabViewController:(HJTabViewController *)tabViewController scrollViewWillScrollFromIndex:(NSInteger)index {
    VideoDetailCommentController * right = (VideoDetailCommentController*)self.vcArr[1];
    if (index==1) {
        [right.view endEditing:YES];
    }
}

- (void)tabViewController:(HJTabViewController *)tabViewController scrollViewDidScrollToIndex:(NSInteger)index {
//    VideoDetailCommentController * right = (VideoDetailCommentController*)self.vcArr[1];
//    if (index==1) {  //不能每次加载, 第一次时, 加载
//        //[right resetReplyModel];
//        if (right.pid && [right.pid isEqualToString:[self getPi]]) {
//        }else {
//            right.pid = [self getPi];
//        }
//    }
}

- (void)upBackBtnUI {
    [self.topContainerView bringSubviewToFront:self.backBtn];
}

////GDT_Adv   Interstitial  长片点击播放时, 获取播放结束展示的插屏广告
//- (void)getInterstitialAdvMsg {
//    NSDictionary *dic = [USER_MANAGER getAdvParamDicWithPositionID:kGDTPositionId_interstitialAfterPlay slotWidth:ScreenWidth slotHeight:ScreenHeight];
//
//    [[SSRequest request]POST:Adv_SplashUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
//        if(response[@"data"]) {  //有广告.
//            AdvertisementModel *m = [AdvertisementModel mj_objectWithKeyValues:response[@"data"]];
//            [m refreshModel];
//            self.interstitialModel = m;
//            [self playLongVideoWithModel:self.currentLongVideoModel];
//        }else {
//           [self playLongVideoWithModel:self.currentLongVideoModel];
//        }
//    } failure:^(SSRequest *request, NSString *errorMsg) {
//        [self playLongVideoWithModel:self.currentLongVideoModel];
//    }];
//}
//
////GDT_Adv_Interstitial 点击播放时加载
//- (void)loadGDTInterstitialAdv {
//    [[BuryingPointManager shareManager] buryingPointWithEventID:BP_DetailPlayFinishAdvRequest andParameters:@{AD_NAME:@"GDT"}];
//
//    [USER_MANAGER callBackAdvWithUrls:self.interstitialModel.reqCallBackList];
//    if(self.interstitial) {
//        self.interstitial.delegate = nil;
//    }
//    self.interstitial = [[GDTMobInterstitial alloc] initWithAppId:kGDTMobSDKAppId placementId:self.interstitialModel.positionCode];
//    self.interstitial.delegate = self;
//    [self.interstitial loadAd];
//
//}
//
//////GDT_Adv_Interstitial 播放结束展示
//- (void)showGDTInterstitialAdv {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.interstitial presentFromRootViewController:self];
//    });
//}
//
//#pragma mark - GDTMobInterstitialDelegate
//// 广告预加载成功回调
//// 详解:当接收服务器返回的广告数据成功后调用该函数
//- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial
//{
//}
//
//// 广告预加载失败回调
//// 详解:当接收服务器返回的广告数据失败后调用该函数
//- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial error:(NSError *)error
//{
//    SSLog(@"interstitial fail to load, Error : %@",error);
//}
//
//// 插屏广告将要展示回调
//// 详解: 插屏广告即将展示回调该函数
//- (void)interstitialWillPresentScreen:(GDTMobInterstitial *)interstitial
//{
//}
//
//// 插屏广告视图展示成功回调
//// 详解: 插屏广告展示成功回调该函数
//- (void)interstitialDidPresentScreen:(GDTMobInterstitial *)interstitial
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [USER_MANAGER callBackAdvWithUrls:self.interstitialModel.fillCallBackList];
//    });
//}
//
//// 插屏广告展示结束回调
//// 详解: 插屏广告展示结束回调该函数
//- (void)interstitialDidDismissScreen:(GDTMobInterstitial *)interstitial
//{
//}
//
///**
// *  插屏广告曝光回调
// */
//- (void)interstitialWillExposure:(GDTMobInterstitial *)interstitial {
//    [[BuryingPointManager shareManager] buryingPointWithEventID:BP_DetailPlayFinishAdvShow andParameters:@{AD_NAME:@"GDT"}];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [USER_MANAGER callBackAdvWithUrls:self.interstitialModel.showCallBackUrlList];
//    });
//}
//
///**
// *  插屏广告点击回调
// */
//- (void)interstitialClicked:(GDTMobInterstitial *)interstitial {
//    [[BuryingPointManager shareManager] buryingPointWithEventID:BP_DetailPlayFinishAdvClick andParameters:@{AD_NAME:@"GDT"}];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [USER_MANAGER callBackAdvWithUrls:self.interstitialModel.clickCallBackUrlList];
//    });
//}
//
//// 应用进入后台时回调
////
//// 详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
//- (void)interstitialApplicationWillEnterBackground:(GDTMobInterstitial *)interstitial
//{
//}
//
////------ShortVideo DayOnceCountDownAdv------//
//- (void)showCountDownAdv {
//    NSDictionary *dic = [USER_MANAGER getAdvParamDicWithPositionID:kGDTPositionId_insertHomeCell slotWidth:ScreenWidth slotHeight:ScreenWidth*0.6];
//
//    [[SSRequest request]POST:Adv_SplashUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
//        if(response[@"data"]) {  //有广告.
//            AdvertisementModel *m = [AdvertisementModel mj_objectWithKeyValues:response[@"data"]];
//            [m refreshModel];
//            self.svDayOnceModel = m;
//            switch (m.adType) {
//                case ADTypeGDT:
//                {
//                    [[BuryingPointManager shareManager] buryingPointWithEventID:BP_SVBeforePlayAdvRequest andParameters:@{AD_NAME:@"GDT"}];
//
//                    [USER_MANAGER callBackAdvWithUrls:m.reqCallBackList];
//                    self.nativeExpressAd = [[GDTNativeExpressAd alloc] initWithAppId:kGDTMobSDKAppId
//                                                                         placementId:m.positionCode
//                                                                              adSize:CGSizeMake(ScreenWidth, ScreenWidth*0.6)];
//                    self.nativeExpressAd.delegate = self;
//                    [self.nativeExpressAd loadAd:1];
//                }
//                    break;
//                default:
//                {
//                    [self shortVideoPlay];
//                }
//                    break;
//            }
//        }else {
//            [self shortVideoPlay];
//        }
//
//    } failure:^(SSRequest *request, NSString *errorMsg) {
//        [self shortVideoPlay];
//    }];
//}
//
//#pragma mark - 短视频广告 倒计时结束, 跳过, 加载失败 时, 播放短视频
//- (void)finishShortVideoDayOnceAdvWithSuccess:(BOOL)isSuccess {
//    if (isSuccess) {
//        [USER_MANAGER showShortVideoDayOnceAdvSuccessWithShortVideoID:self.model.idForModel];
//    }
//    [self shortVideoPlay];
//}
//
//#pragma mark - GDTNativeExpressAdDelegete   ShortVideoDayOnceAdv
///**
// * 拉取广告成功的回调
// */
//- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views {
//    if (views.count>0) {
//        self.expressView = views.firstObject;
//        self.expressView.controller = SelectVC;
//        [self.expressView render];
//    }
//}
//
///**
// * 拉取广告失败的回调
// */
//- (void)nativeExpressAdRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView
//{
//    [self finishShortVideoDayOnceAdvWithSuccess:NO];
//}
//
///**
// * 拉取原生模板广告失败
// */
//- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error
//{
//    [self finishShortVideoDayOnceAdvWithSuccess:NO];
//}
//
//- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView
//{
//    [USER_MANAGER callBackAdvWithUrls:self.advModel.fillCallBackList];
//
//    UIView *subView = (UIView *)[self.topContainerView viewWithTag:1000];
//    if ([subView superview]) {
//        [subView removeFromSuperview];
//    }
//    self.expressView.tag = 1000;
//    self.countDownView.hidden = NO;
//    self.moreBtn.hidden = YES;
//    [self.topContainerView addSubview:self.expressView];
//    [self.expressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.topContainerView);
//    }];
//    [self.topContainerView bringSubviewToFront:self.expressView];
//    [self.topContainerView bringSubviewToFront:self.countDownView];
//    [self upBackBtnUI];
//    [self.countDownView startWithCount:5];
//}
//
//- (void)nativeExpressAdViewExposure:(GDTNativeExpressAdView *)nativeExpressAdView
//{
//    [[BuryingPointManager shareManager] buryingPointWithEventID:BP_SVBeforePlayAdvShow andParameters:@{AD_NAME:@"GDT"}];
//    [USER_MANAGER callBackAdvWithUrls:self.advModel.showCallBackUrlList];
//}
//
//- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView
//{
//    [[BuryingPointManager shareManager] buryingPointWithEventID:BP_SVBeforePlayAdvClick andParameters:@{AD_NAME:@"GDT"}];
//    [USER_MANAGER callBackAdvWithUrls:self.advModel.clickCallBackUrlList];
//}
//
//- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView
//{
//}
//
//-(CountDownView *)countDownView {
//    if (!_countDownView) {
//        _countDownView = [[CountDownView alloc] initWithFrame:CGRectMake(ScreenWidth-self.sizeW(70), self.sizeH(30), self.sizeW(70), self.sizeH(30))];
//        _countDownView.hidden = YES;
//        WS()
//        _countDownView.skipClickBlock = ^{
//            [[BuryingPointManager shareManager] buryingPointWithEventID:BP_SVBeforePlayAdvSkip andParameters:@{AD_NAME:@"GDT"}];
//            weakSelf.countDownView.hidden = YES;
//            weakSelf.moreBtn.hidden = NO;
//            if (weakSelf.expressView) {
//                [weakSelf.expressView removeFromSuperview];
//            }
//            [weakSelf finishShortVideoDayOnceAdvWithSuccess:YES];
//        };
//    }return _countDownView;
//}
//
//- (NSMutableArray<ProgramResultListModel *> *)likeDataArray {
//    if (!_likeDataArray) {
//        _likeDataArray = [NSMutableArray array];
//    }return _likeDataArray;
//}
//
//- (void)moreAction {
//    ProgramResultListModel *m = [[ProgramResultListModel alloc]init];
//    m.name = self.modelCommon.name;
//    m.shareLink = self.modelCommon.shareLink;
//    m.poster = self.modelCommon.poster;
//    [self showMoreShareViewWithModel:m];
//}
//
//- (void)showMoreShareViewWithModel:(ProgramResultListModel *)model
//{
//    __block KSBaseViewController *vc = (KSBaseViewController *)SelectVC.childViewControllers.lastObject;
//    vc.zh_popupController = [zhPopupController new];
//    vc.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
//    vc.zh_popupController.dismissOnMaskTouched = YES;
//
//    BOOL isShortVideo = (self.modelCommon.videoType == VideoType_Short);
//    NSInteger lineNum = [USER_MANAGER getShareNumBeforeShowShareViewWithNotInterest:isShortVideo];
//    CGFloat toolHeight = self.sizeH(90*lineNum+50);
//    ShortVideoShareView * tool =  [[ShortVideoShareView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, toolHeight) andModel:model andIsFromShort:isShortVideo];
//    vc.zh_popupController.popupView.layer.mask = tool.layer.mask;
//    __weak typeof(vc) weakVC = vc;
//    tool.dissmissBlock = ^{
//        [weakVC.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
//    };
//
//    WS()
//    tool.dissmissAndPushBlock = ^(NSInteger type) {
//        [weakVC.zh_popupController dismiss];
//        switch (type) {
//            case 1001:
//            {
//                [weakSelf goReportVC];
//            }
//                break;
//            case 1002:
//            {
//                [weakSelf goErrorReportVC];
//            }
//                break;
//            default:
//                break;
//        }
//    };
//    [vc.zh_popupController presentContentView:tool];
//}
//
//- (void)goReportVC {
//    NSDictionary *dic = @{PROGRAM_ID : self.modelCommon.idForModel,
//                          PROGRAM_TYPE : self.modelCommon.type
//                          };
//    [[BuryingPointManager shareManager] buryingPointWithEventID:BP_DetailReport andParameters:dic];
//
//    ReportViewController *vc = [[ReportViewController alloc]init];
//    vc.model = self.modelCommon;
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//- (void)goErrorReportVC {
//
//    NSDictionary *dic = @{PROGRAM_ID : self.modelCommon.idForModel,
//                          PROGRAM_TYPE : self.modelCommon.type
//                          };
//    [[BuryingPointManager shareManager] buryingPointWithEventID:BP_DetailErrorReport andParameters:dic];
//
//    ErrorReportViewController *vc = [[ErrorReportViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)backAction {
    //    [[JQFMDB shareDatabase] close];
    //    if (_timer) {
    //        [_timer invalidate];
    //        _timer = nil;
    //    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    //来自短视频列表页, 返回短视频列表页时,  之前放在viewDidDisappear里, 当push到别的页面时, 也会触发,所以放在dealloc里
    if (self.detailVCPopCallback) {
        self.detailVCPopCallback(self.isChangeVideo);
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
//    [[JQFMDB shareDatabase] close];
//    if (_timer) {
//        [_timer invalidate];
//        _timer = nil;
//    }
    
    SSLog(@"  VideoDetailViewController  视频详情页Dealloc, timer销毁, 关闭数据库");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


