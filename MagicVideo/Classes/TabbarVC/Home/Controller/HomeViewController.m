//
//  HomeViewController.m
//  MagicVideo
//
//  Created by young He on 2019/9/18.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "HomeViewController.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "UIButton+Category.h"
#import "UINavigationController+WXSTransition.h"

#import "ShortVideoListCell.h"
#import "VideoDetailViewController.h"

//#import "ShortVideoListAdvCell.h"
//#import "ShortVideoFullScreenAdvCell.h"

//#import "ShortVideoShareView.h"
//#import "JQFMDB.h"
//#import "ReportViewController.h"
//#import "ErrorReportViewController.h"
//#import <BUAdSDK/BUFullscreenVideoAd.h>
//#import "GCDTimer.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,ShortVideoListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic,strong) NSIndexPath *currentIndexPath;  //当前显示的Cell 无论是视频还是广告
@property (nonatomic, strong) NSMutableArray *dataSource;


@end

@implementation HomeViewController

static NSString *kIdentifier = @"kIdentifier";

static NSString *TmpVideoUrl = @"http://movies.ks.quanyuer.com/11c09ghjjcb00.mp4";

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        //Tmp
        [_dataSource addObjectsFromArray:@[URL(TmpVideoUrl),URL(TmpVideoUrl),URL(TmpVideoUrl),URL(TmpVideoUrl),URL(TmpVideoUrl),URL(TmpVideoUrl)]];
        
    }return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    // player的tag值必须在cell里设置
    [SSPlayer manager].player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
    [SSPlayer manager].player.controlView = self.controlView;
    [SSPlayer manager].player.playerDisapperaPercent = 0.8; // 0.8是消失80%时候
    [SSPlayer manager].player.WWANAutoPlay = YES; // 移动网络依然自动播放
    self.urls = [NSMutableArray array];
    [self.urls addObjectsFromArray:@[URL(TmpVideoUrl),URL(TmpVideoUrl),URL(TmpVideoUrl),URL(TmpVideoUrl),URL(TmpVideoUrl),URL(TmpVideoUrl)]];
    
    [SSPlayer manager].player.assetURLs = self.urls;
    [self.tableView reloadData];
    WS()
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [weakSelf playTheVideoAtIndexPath:weakSelf.currentIndexPath autoPlayNext:NO];
    });
    
    @weakify(self)
    [SSPlayer manager].player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
        [UIViewController attemptRotationToDeviceOrientation];
        self.tableView.scrollsToTop = !isFullScreen;
    };
    
    [self configPlayer];
    
//    [self requestDataWithAnimation:NO isFirst:YES];
//    [self addNotification];
    
}

//初始化时设置, 从详情页返回时,再次设置,不然自动播放下一个失效
- (void)configPlayer {
    //播放完时, 自动播放下一个
    @weakify(self)
    [SSPlayer manager].player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self playEndOrFailed];
    };
    
    //播放失败时, 自动播放下一个:   会导致播放失败时 无法上滑, 一上滑, 播放失败, 然后自动下一个.
    [SSPlayer manager].player.playerPlayFailed = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, id  _Nonnull error) {
//        @strongify(self)
        SSMBToast(@"该视频被盗走了~", MainWindow);
//        ProgramResultListModel *model = self.dataSource[self.currentIndexPath.row];
//        if (model.urlFromRealUrl && model.idForModel) {
//            [USER_MANAGER reportPlayFailLogWithProgramID:model.idForModel andVideoUrl:model.realUrl];
//        }
//
//        [self saveFailPlayVideoWithModel:model];
    };
}

- (void)playEndOrFailed {
    if ([SSPlayer manager].player.isFullScreen) {  //如果全屏,退出全屏
        [[SSPlayer manager].player enterFullScreen:NO animated:YES];
    }
    
//    //更新播放完的视频的时间
//    [SSPlayer manager].player.currentPlayerManager.seekTime = 0;
//    [self updateHistorySaveTimeWithIndexPath:[SSPlayer manager].player.playingIndexPath];
    
    NSInteger currentRow = [SSPlayer manager].player.playingIndexPath.row;
    if (currentRow+2 <= self.urls.count) {  //还有下一个
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentRow+1 inSection:0];
        [self playTheVideoAtIndexPath:indexPath autoPlayNext:YES];
        
//        if (currentRow+2 == self.urls.count) {  //下一个是最后一个的话, loadMoreData
//            if (_tableView.mj_footer.state != MJRefreshStateNoMoreData && (!self.tableView.mj_footer.isRefreshing)) {
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [_tableView.mj_footer beginRefreshing];
//                    [self requestDataWithAnimation:NO isFirst:NO];
//                });
//            }
//        }
//
//        //重新计时
//        [self startTimerWithModel:self.dataSource[currentRow+1]];

    }else {
        if (_tableView.mj_footer.state == MJRefreshStateNoMoreData) {
            [[SSPlayer manager].player stopCurrentPlayingCell];
            SSMBToast(@"暂无更多内容~", MainWindow);
        }else {
//            if (!self.tableView.mj_footer.isRefreshing) {
//                [self.tableView.mj_footer beginRefreshing];
//                [self requestDataWithAnimation:NO isFirst:NO];
//            }else {
//                [[SSPlayer manager].player stopCurrentPlayingCell];
//            }
        }
    }
}

- (void)requestDataWithAnimation:(BOOL)animate isFirst:(BOOL)isFirst {
//    if (animate) {
//        SSGifShow(MainWindow, @"");
//    }
//
//    NSDictionary *dic = @{};
//    [[SSRequest request]POST:ShortVideoRecomListUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
//        if (animate) {SSDissMissAllGifHud(MainWindow, YES);}
//
//    } failure:^(SSRequest *request, NSString *errorMsg) {
//        if (animate) {SSDissMissAllGifHud(MainWindow, YES);}
//        SSMBToast(errorMsg, MainWindow);
//        [self.tableView reloadData];
//        [self.tableView.mj_footer endRefreshing];
//    }];
}

#pragma mark - private method
/// play the video
// autoPlayNext:   自动播放下一个时, 且下一个为全屏广告时, 需要偏移一下
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath autoPlayNext:(BOOL)autoNext {
    _currentIndexPath = indexPath;

//    ProgramResultListModel *model = self.dataSource[indexPath.row];
//    //Add--- 是广告Cell 播放广告
//    if (model.ad && model.ad.sspId && model.ad.sspType) {
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//
//        if (model.ad.adType == ADTypeTT) {
//            //停止当前视频播放
//            [[SSPlayer manager].player stopCurrentPlayingCell];
//
//            AdvVideoType type = model.ad.videoInfo.advVideoType;
//            if (type == AdvVideoTypeDraw || type == AdvVideoTypeFeed) {
//                //showMaskView hideMaskViewe里面已经做了视频广告的播放和暂停的处理
//                return;
//            }else {  //FullScreen & 激励
//                [self loadFullScreenAdvWithModel:model];
//                if (autoNext) {
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        CGFloat newY = _tableView.contentOffset.y;
//                        newY = _tableView.contentOffset.y + (ScreenHeight/3);
//                        [_tableView setContentOffset:CGPointMake(_tableView.contentOffset.x, newY) animated:YES];
//                    });
//                }
//                return;
//            }
//        }else {
//
//        }
//    }
    
//    //Add--- 判断是不是第一个cell, 判断是播放还是显示cell上的GDT Adv
//    if (indexPath.row==0) {  //第一个视频,判断要不要广告倒计时  不播放
//        if ([USER_MANAGER isShowShortVideoDayOnceAdvWithShortVideoID:self.dataSource.firstObject.idForModel]) {
//            [[SSPlayer manager].player stopCurrentPlayingCell];
//            return;
//        }
//    }
//
//    //如果正在播全屏广告 or 激励广告
//    if(self.fullscreenVideoAd.adValid) {
//        return;
//    }
    
    @weakify(self)
    [[SSPlayer manager].player playTheIndexPath:indexPath scrollToTop:YES completionHandler:^{
        @strongify(self)
        
//        //查看是否有观看历史
//        [weakSelf checkHistorySaveTimeWithIndexPath:indexPath];
        
//    [self.controlView showTitle:model.name
//                 coverURLString:model.poster.url
//                 fullScreenMode:model.isVerticalVideo ? ZFFullScreenModePortrait : ZFFullScreenModeLandscape];
        
        [self.controlView showTitle:@"一部好莱坞顶级科幻动作电影 简直是一场视觉的饕餮盛宴 极度震撼"
                     coverURLString:TmpVideoUrl
                     fullScreenMode:ZFFullScreenModePortrait];
    }];
}

- (void)initUI {
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat h = CGRectGetMaxY(self.view.frame);
    self.tableView.frame = CGRectMake(0, [self statusBarHeight], ScreenWidth, h-[self statusBarHeight]);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.urls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShortVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /// 如果正在播放的index和当前点击的index不同，则停止当前播放的index
    if ([SSPlayer manager].player.playingIndexPath && [SSPlayer manager].player.playingIndexPath != indexPath) {
        [[SSPlayer manager].player stopCurrentPlayingCell];
        [self playTheVideoAtIndexPath:indexPath autoPlayNext:NO];
        if (indexPath.row == 0) {  //第一个cell 在playTheVideoAtIndexPath方法里, 不scrollToTop且不播放
            //滚动 toTop 并且播放   ------暂时不加了
        }
        return;
    }
    
//    ProgramResultListModel *model = self.dataSource[indexPath.row];
//    if (model.ad && model.ad.sspId && model.ad.sspType) {
//        return;
//    }else {
        //更新正在播放的视频的时间
//        [self updateHistorySaveTimeWithIndexPath:_currentIndexPath];
        ShortVideoListCell *cell = (ShortVideoListCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell setDelegate:self withIndexPath:indexPath];

//        ProgramResultListModel *mDetail = self.dataSource[indexPath.row];
        // 到详情页 : 暂停时, 播放时, 播放失败时, showGDTAdv时
        VideoDetailViewController *vc = [[VideoDetailViewController alloc]init];
//        vc.model = mDetail;
//        vc.vcType = (indexPath.row==0) ? VideoDetailTypeShort_WithPlayerAdv : VideoDetailTypeShort_WithPlayer;
        vc.player = [SSPlayer manager].player;
        
//        @weakify(self)
//        vc.detailVCPopCallback = ^{  // 详情页返回的回调
//            @strongify(self)
//            [self configPlayer];
//            if (indexPath.row==0) {  //第一个Cell 判断要不要广告倒计时
//                [cell hideMaskViewWithAdv:[USER_MANAGER isShowShortVideoDayOnceAdvWithShortVideoID:model.idForModel]];
//            }else {
//                [cell hideMaskViewWithAdv:NO];
//            }
//            [self playTheVideoAtIndexPath:_currentIndexPath autoPlayNext:NO];
//
//            //和进入后台后重新打开一个效果,继续计时
//            [self appDidBecomeActiveNotification];
//
//            //重新加上通知
//            [self addNotification];
//        };
//
//        //和进入后台一个效果,暂停计时
//        [self appWillEnterBackgroundNotification];
    
        //移除通知, 避免在详情页进入后台再打开App之后,通知继续计时
        [NOTIFICATION removeObserver:self];
    vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.sizeH(260);
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[ShortVideoListCell class] forCellReuseIdentifier:kIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        //Add---
        _tableView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.backgroundColor = KCOLOR(@"ffffff");
        [[UITableView appearance] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [[UITableView appearance] setSeparatorInset:UIEdgeInsetsZero];
        [[UITableViewCell appearance] setSeparatorInset:UIEdgeInsetsZero];
        if ([UITableView instancesRespondToSelector:@selector(setLayoutMargins:)]) {
            [[UITableView appearance] setLayoutMargins:UIEdgeInsetsZero];
            [[UITableViewCell appearance] setLayoutMargins:UIEdgeInsetsZero];
            [[UITableViewCell appearance] setPreservesSuperviewLayoutMargins:NO];
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
//        /// 停止的时候找出最合适的播放
//        @weakify(self)
//        _tableView.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
//            @strongify(self)
//            [self playTheVideoAtIndexPath:indexPath autoPlayNext:NO];
//        };
//        /// 明暗回调
//        _tableView.zf_shouldPlayIndexPathCallback = ^(NSIndexPath * _Nonnull indexPath) {
//            @strongify(self)
//
//            if ([indexPath compare:self.tableView.zf_shouldPlayIndexPath] != NSOrderedSame) {
//                /// 显示黑色蒙版
//                ProgramResultListModel *model1 = self.dataSource[self.tableView.zf_shouldPlayIndexPath.row];
//                //Add---
//                if (model1.ad && model1.ad.sspId && model1.ad.sspType) {
//                    ShortVideoListAdvCell *cell1 = [self.tableView cellForRowAtIndexPath:self.tableView.zf_shouldPlayIndexPath];
//                    [cell1 showMaskView];
//                }else {
//                    ShortVideoListCell *cell1 = [self.tableView cellForRowAtIndexPath:self.tableView.zf_shouldPlayIndexPath];
//                    [cell1 showMaskView];
//                }
//
//                /// 隐藏黑色蒙版
//                ProgramResultListModel *model = self.dataSource[indexPath.row];
//                //Add---
//                if (model.ad && model.ad.sspId && model.ad.sspType) {
//                    ShortVideoListAdvCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//                    [cell hideMaskView];
//                }else {
//                    ShortVideoListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//                    if (indexPath.row==0) {  //第一个视频,判断要不要广告倒计时
//                        [cell hideMaskViewWithAdv:[USER_MANAGER isShowShortVideoDayOnceAdvWithShortVideoID:model.idForModel]];
//                    }else {
//                        [cell hideMaskViewWithAdv:NO];
//                    }
//                }
//            }
//        };
//        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            @strongify(self)
//
//            [[BuryingPointManager shareManager] buryingPointWithEventID:BP_SVListRefreshMore andParameters:@{}];
//
//            [self requestDataWithAnimation:NO isFirst:NO];
//        }];
//
//        //Add---headerView
//        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.sizeH(50))];
//        headerView.backgroundColor = KCOLOR(@"#ffffff");
//        _tableView.tableHeaderView = headerView;
//
//        //Add---footerView
//        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.sizeH(100))];
//        footerView.backgroundColor = KCOLOR(@"#ffffff");
//        _tableView.tableFooterView = footerView;

        //Add---Gesture
        UISwipeGestureRecognizer *recognizerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [_tableView addGestureRecognizer:recognizerUp];

        UISwipeGestureRecognizer *recognizerDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizerDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [_tableView addGestureRecognizer:recognizerDown];

    }return _tableView;
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    //    //视频播放情况 数据上报
    //    if([SSPlayer manager].player.currentTime > 0 && [SSPlayer manager].player.totalTime >0 && self.dataSource[self.currentIndexPath.row].keyWordId) {
    //        [[BuryingPointManager shareManager] videoPlayMsgReportWithProgramId:self.dataSource[[SSPlayer manager].player.playingIndexPath.row].idForModel andLabelId:self.dataSource[[SSPlayer manager].player.playingIndexPath.row].keyWordId andPercentage:round([SSPlayer manager].player.progress*100) andPlayTime:round([SSPlayer manager].player.currentTime*1000)];
    //    }
    
//    //滑动触发 更新数据库: 当前cell播放视频的时间
//    [self updateHistorySaveTimeWithIndexPath:_currentIndexPath];
    
//    //保存当前播放视频曝光数据, 处理timer相关
//    ProgramResultListModel *currentModel = _dataSource[_currentIndexPath.row];
//    if (_currentIndexPath.row>0) {  //第一个不需要保存
//        [self saveUserActivityWithModel:currentModel];
//    }
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {   // Next One
        NSInteger row = (_currentIndexPath.row+1 < self.dataSource.count) ? (_currentIndexPath.row+1) : _currentIndexPath.row;
        if (_currentIndexPath.row+1 == self.dataSource.count) {
            [self fakeFooterRefreshing];
            _currentIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
            return;
        }
        _currentIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    }
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {  // Last One
        if(_currentIndexPath.row == 0) return;
        NSInteger row = (_currentIndexPath.row-1 >= 0) ? (_currentIndexPath.row-1) : 0;
        _currentIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    }
    
//    ProgramResultListModel *nextPlayModel = _dataSource[_currentIndexPath.row];
//    if (nextPlayModel.ad && nextPlayModel.ad.sspId && nextPlayModel.ad.sspType) {
//        if (nextPlayModel.ad.adType == ADTypeTT) {
//            AdvVideoType type = nextPlayModel.ad.videoInfo.advVideoType;
//            if (type == AdvVideoTypeDraw || type == AdvVideoTypeFeed) {
//                _tableView.zf_playingIndexPath = nil;
//                if ([SSPlayer manager].player.currentPlayerManager.isPlaying) {
//                    [[SSPlayer manager].player.currentPlayerManager pause];
//                }
//            }
//        }
//    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.tableView scrollToRowAtIndexPath:self.currentIndexPath atScrollPosition:(UITableViewScrollPositionMiddle) animated:NO];
    }];
    //播放
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playTheVideoAtIndexPath:self.currentIndexPath autoPlayNext:NO];
    });
    
//    //重新计时
//    [self startTimerWithModel:nextPlayModel];
    
//    //如果是全屏广告, 根据滑动方向, 让tableview滚动到下一个位置, 全屏广告播放完触发viewDidAppear 才会自动播放下一个
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        ProgramResultListModel *model = self.dataSource[_currentIndexPath.row];
//        if (model.ad && model.ad.sspId && model.ad.sspType) {
//            if (model.ad.adType == ADTypeTT) {
//                AdvVideoType type = model.ad.videoInfo.advVideoType;
//                if (type == AdvVideoTypeFullScreen || type == AdvVideoTypeReward) {  ////FullScreen & 激励
//                    //滚动scrollview, 当广告播放结束, 才会触发下一个cell播放
//                    CGFloat newY = _tableView.contentOffset.y;
//                    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
//                        newY = _tableView.contentOffset.y - (ScreenHeight/3);
//                    }else if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
//                        newY = _tableView.contentOffset.y + (ScreenHeight/3);
//                    }
//                    [_tableView setContentOffset:CGPointMake(_tableView.contentOffset.x, newY) animated:YES];
//                    _tableView.bouncesZoom = NO;
//                }
//            }
//        }
//    });

}

- (void)fakeFooterRefreshing {
    if (_tableView.mj_footer.state == MJRefreshStateNoMoreData) {
        SSMBToast(@"暂无更多内容~", MainWindow);
        return;
    }
    if (!_tableView.mj_footer.isRefreshing && (_tableView.mj_footer.state != MJRefreshStateNoMoreData)) {
        [_tableView.mj_footer beginRefreshing];
        [self requestDataWithAnimation:NO isFirst:NO];
    }
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
    }return _controlView;
}

@end
