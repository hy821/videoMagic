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
#import "GCDTimer.h"
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

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation HomeViewController

static NSString *kIdentifier = @"kIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShortVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.sizeH(220);
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[ShortVideoListCell class] forCellReuseIdentifier:kIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = YES;
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
    return self.isNetError == SSNetNormal_state ? K_IMG(@"netError") : K_IMG(@"netError");
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
    return K_IMG(@"reload");
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

@end
