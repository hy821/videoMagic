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

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#import "ShortVideoListCell.h"

//#import "ShortVideoListAdvCell.h"
//#import "ShortVideoFullScreenAdvCell.h"
//#import "VideoDetailViewController.h"
//#import "ShortVideoShareView.h"
//#import "JQFMDB.h"
//#import "ReportViewController.h"
//#import "ErrorReportViewController.h"
//#import <BUAdSDK/BUFullscreenVideoAd.h>
//#import "GCDTimer.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic,strong) NSIndexPath *currentIndexPath;  //当前显示的Cell 无论是视频还是广告


@end

@implementation HomeViewController

static NSString *kIdentifier = @"kIdentifier";

static NSString *TmpVideoUrl = @"http://movies.ks.quanyuer.com/11c09ghjjcb00.mp4";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    // player的tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
    self.player.controlView = self.controlView;
    self.player.playerDisapperaPercent = 0.8; // 0.8是消失80%时候
    self.player.WWANAutoPlay = YES; // 移动网络依然自动播放
    self.urls = [NSMutableArray array];

    [self.urls addObjectsFromArray:@[URL(TmpVideoUrl),URL(TmpVideoUrl),URL(TmpVideoUrl),URL(TmpVideoUrl),URL(TmpVideoUrl),URL(TmpVideoUrl)]];
    
    self.player.assetURLs = self.urls;
    [self.tableView reloadData];
    _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self playTheVideoAtIndexPath:_currentIndexPath autoPlayNext:NO];
    
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
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
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self playEndOrFailed];
    };
    
    //播放失败时, 自动播放下一个:   会导致播放失败时 无法上滑, 一上滑, 播放失败, 然后自动下一个.
    self.player.playerPlayFailed = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, id  _Nonnull error) {
        @strongify(self)
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
    if (self.player.isFullScreen) {  //如果全屏,退出全屏
        [self.player enterFullScreen:NO animated:YES];
    }
    
//    //更新播放完的视频的时间
//    self.player.currentPlayerManager.seekTime = 0;
//    [self updateHistorySaveTimeWithIndexPath:_player.playingIndexPath];
    
    
    NSInteger currentRow = _player.playingIndexPath.row;
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
            [self.player stopCurrentPlayingCell];
            SSMBToast(@"暂无更多内容~", MainWindow);
        }else {
//            if (!self.tableView.mj_footer.isRefreshing) {
//                [self.tableView.mj_footer beginRefreshing];
//                [self requestDataWithAnimation:NO isFirst:NO];
//            }else {
//                [self.player stopCurrentPlayingCell];
//            }
        }
    }
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
//            [self.player stopCurrentPlayingCell];
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
//            [self.player stopCurrentPlayingCell];
//            return;
//        }
//    }
//
//    //如果正在播全屏广告 or 激励广告
//    if(self.fullscreenVideoAd.adValid) {
//        return;
//    }
    
    @weakify(self)
    [self.player playTheIndexPath:indexPath scrollToTop:YES completionHandler:^{
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
    [self.tableView reloadEmptyDataSet];
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
//        _tableView.separatorColor = KCOLOR(@"#231F1F");
        _tableView.backgroundColor = White_Color;
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
//        headerView.backgroundColor = KCOLOR(@"#231F1F");
//        _tableView.tableHeaderView = headerView;
//
//        //Add---footerView
//        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.sizeH(100))];
//        footerView.backgroundColor = KCOLOR(@"#231F1F");
//        _tableView.tableFooterView = footerView;
//
//        //Add---Gesture
//        UISwipeGestureRecognizer *recognizerUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//        [recognizerUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
//        [_tableView addGestureRecognizer:recognizerUp];
//
//        UISwipeGestureRecognizer *recognizerDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//        [recognizerDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
//        [_tableView addGestureRecognizer:recognizerDown];
//
    }return _tableView;
}

#pragma mark--DZ
-(UIImage*)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if(self.isNetError==SSNetLoading_state)return nil;
    return self.isNetError == SSNetNormal_state ? Image_Named(@"netError") : Image_Named(@"netError");
}

-(NSAttributedString*)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if(self.isNetError==SSNetLoading_state)return nil;
    NSString *text = self.isNetError==SSNetError_state?@"网络请求失败":@"暂无数据";
    NSDictionary *attribute = self.isNetError?@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: KCOLOR(@"#333333")}:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: KCOLOR(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

// 返回详情文字
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if(self.isNetError!=SSNetError_state)return nil;
    NSString *text = @"加载失败,点击重试";
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: KCOLOR(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

-(UIImage*)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    if(self.isNetError!=SSNetError_state)return nil;
    return Image_Named(@"reload");
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    self.isNetError = SSNetLoading_state;
//    [self.mainTableView reloadEmptyDataSet];
//    [self loadDateWithAnimation:YES];
}

//- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
//    return (self.dataArr.count==0);
//}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
    }return _controlView;
}

@end