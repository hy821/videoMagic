//
//  VideoDetailMsgController.m
//  KSMovie
//
//  Created by young He on 2018/9/17.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import "VideoDetailMsgController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <zhPopupController.h>
#import "VideoMsgCell.h"
#import "VideoRecomCell.h"

@interface VideoDetailMsgController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,assign) SSNetState isNetError;
//RecomData
@property (nonatomic, strong) NSMutableArray *recomDataArray;
@property (nonatomic,assign) BOOL isLoadingRecom; //请求推荐数据: YES:正在请求  NO:请求完成
@property (nonatomic,assign) NSInteger pageRecom;


////Common数据源
//@property (nonatomic,strong) VDCommonModel *modelCommon;
////EpisodeData
//@property (nonatomic, strong) NSMutableArray<MediaTipResultModel*> *episodeDataArray;
//
////All_Episode_IntroDataArr
//@property (nonatomic, strong) NSMutableArray<EpisodeIntroModel*> *allIntroDataArray;
//
//@property (nonatomic,assign) VideoType videoType;
//
//@property (nonatomic,assign) BOOL isEmpty;
//@property (nonatomic,assign) BOOL isOff;  //下架

@end

@implementation VideoDetailMsgController

- (NSMutableArray *)recomDataArray {
    if (!_recomDataArray) {
        _recomDataArray = [NSMutableArray array];
        _recomDataArray = @[@"",@"",@"",@"",@""].mutableCopy;
    }return _recomDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNetError = SSNetLoading_state;
    self.pageRecom = 0;
    [self initTableView];
}

//请求推荐数据
- (void)loadRecomDataWithAnimation:(BOOL)isAnimation {
    if (isAnimation) {SSGifShow(MainWindow, @"加载中");}
    self.isLoadingRecom = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isAnimation) {SSDissMissAllGifHud(MainWindow, YES);}
       //只有加载更多,无下拉刷新
        NSArray *arr;
        if (self.pageRecom == 10) {
            arr = @[];
        }else {
            arr = @[@"",@"",@"",@"",@""];
        }
        if (arr.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.isLoadingRecom = NO;
        }else {
            [self.recomDataArray addObjectsFromArray:arr];
            
            //reloadData 不会挑动
            [self.tableView reloadData];
            
//            //reloadSections tableView会挑动
//            [self.tableView beginUpdates];
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:(UITableViewRowAnimationNone)];
//            [self.tableView endUpdates];

            if (@available(iOS 11,*)) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //iOS11之后reloadData方法会执行
                    //- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 方法
                    //将当前所有的cell过一遍，而iOS11之前只是将展示的cell过一遍。故加此方法使其在过第一次的时候不执行加载更多数据
                    self.isLoadingRecom = NO;
                });
            }else {
                self.isLoadingRecom = NO;
            }
        }
    });
    
//    NSDictionary *dic = @{
//                          @"<#xxx#>" : <#xxx#>,
//                          @"size" : @(PageCount_Normal)
//                          };
//    [[SSRequest request]POST:<#Url#> parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
//
//        if (isAnimation) {
//            SSDissMissAllGifHud(MainWindow, YES);
//        }
//
//        self.isNetError = SSNetNormal_state;
//        [self.mainTableView.mj_header endRefreshing];
//
//        if(self.page == 1 && (self.dataArr.count>0)) {
//            [self.dataArr removeAllObjects];
//        }
//
//        NSArray *arr = [SubjectListModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
//
//        [self.dataArr addObjectsFromArray:arr];
//
//        if (arr.count<PageCount_Normal) {
//            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
//        }else {
//            [self.mainTableView.mj_footer endRefreshing];
//        }
//
//        [self.mainTableView reloadData];
//
//    } failure:^(SSRequest *request, NSString *errorMsg) {
//        if (isAnimation) {SSDissMissAllGifHud(MainWindow, YES);}
//        SSMBToast(errorMsg, MainWindow);
//        self.isNetError = SSNetError_state;
//        [self.mainTableView reloadData];
//        [self.mainTableView.mj_header endRefreshing];
//        [self.mainTableView.mj_footer endRefreshing];
//    }];
}

//加载数据 刷新UI
- (void)loadDataWithCommonModel:(id*)model isOff:(BOOL)isOff {
//    self.modelCommon = model;
//    self.likeDataArray = model.likeDataArray.mutableCopy;
//    self.episodeDataArray = model.episodeDataArray.mutableCopy;
//    self.videoType = model.videoType;
//
//    self.isOff = isOff;
//
//    if (!model) {
//        self.isEmpty = YES;
//        self.isNetError = SSNetError_state;
//    }else {
//        if (model.videoType != VideoType_UnKnow) {
//            self.isEmpty = NO;
//        }else {
//            self.isEmpty = YES;
//            self.isNetError = SSNetError_state;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//        }
//    }
    [self.tableView reloadData];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView scrollsToTop];
    });
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0 ? 1 : self.recomDataArray.count;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section==0) {
         VideoMsgCell *cell = [VideoMsgCell cellForTableView:tableView];
         return cell;
     }else if (indexPath.section==1) {
         VideoRecomCell *cell = [VideoRecomCell cellForTableView:tableView];
         cell.indexPath = indexPath;
         return cell;
     }else {
         return nil;
     }
 }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return self.sizeW(195);
    }else if (indexPath.section==1) {
        return self.sizeW(110);
    }else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        NSInteger row = [indexPath row];
        if (row == self.recomDataArray.count - 2 && !self.isLoadingRecom) { //isfinish是请求是否完成的标识
            self.pageRecom++;//第几页
            [self loadRecomDataWithAnimation:NO];//具体请求
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)initTableView {
//    self.tableView.bounces = NO;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    //关闭预估算高度. 避免 加载更多数据时抖动
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    WS()
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        if (self.isLoadingRecom) {return;}
        weakSelf.pageRecom++;
        [weakSelf loadRecomDataWithAnimation:NO];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//#pragma mark--DZ
//-(UIImage*)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    if(self.isNetError==SSNetLoading_state)return nil;
//    return self.isNetError == SSNetNormal_state ? K_IMG(@"netError") : K_IMG(@"netError");
//}
//-(NSAttributedString*)titleForEmptyDataSet:(UIScrollView *)scrollView
//{
//    if(self.isNetError==SSNetLoading_state)return nil;
//    NSString *text = self.isNetError==SSNetError_state?@"网络请求失败":@"暂无记录";
//    if (self.isOff) {text = @"该视频已下架";}
//    NSDictionary *attribute = self.isNetError?@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: KCOLOR(@"#333333")}:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: KCOLOR(@"#999999")};
//    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
//}
//
//// 返回详情文字
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
//    if(self.isNetError!=SSNetError_state)return nil;
//    NSString *text = @"加载失败, 点击重试";
//    if (self.isOff) {text = @"";}
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: KCOLOR(@"#999999")};
//    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
//}
//
//-(UIImage*)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    if(self.isNetError!=SSNetError_state)return nil;
//    return K_IMG(@"reload");
//}
//
//- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
//    if (self.isNetError!=SSNetError_state) {return;}
//    if (self.isOff) {return;}
//    self.isNetError = SSNetLoading_state;
//    [self.tableView reloadEmptyDataSet];
//    if (self.loadDataBlock) {
//        self.loadDataBlock();
//    }
//}
//
//-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
//    return YES;
//}

@end
