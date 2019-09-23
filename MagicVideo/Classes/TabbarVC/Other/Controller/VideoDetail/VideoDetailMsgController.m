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

//#import "VideoMsgCell.h"
//#import "VideoDetailAdvCell.h"
//#import "SynopsisCell.h"
//#import "SelectEpisodeCell.h"
//#import "GuessYouLikeCell.h"
//#import "NewGuessLikeCell.h"
//#import "ShortVideoMsgCell.h"
//#import "AllEpisodeView.h"
//#import "CacheView.h"
//#import "DownloadViewController.h"
//#import "GuessLikeActionSheetView.h"

@interface VideoDetailMsgController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,assign) SSNetState isNetError;

////Common数据源
//@property (nonatomic,strong) VDCommonModel *modelCommon;
////GuessULikeData
//@property (nonatomic, strong) NSMutableArray<ProgramResultListModel*> *likeDataArray;
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
//
//@property (nonatomic,assign) BOOL isAdvRequestFail;  //广告请求失败时, block回调,记录一下然后刷新, 关掉广告位, 以及误触时处理一下不用误触了

@end

@implementation VideoDetailMsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNetError = SSNetLoading_state;
    self.tableView.bounces = NO;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
}

//- (NSMutableArray<EpisodeIntroModel *> *)allIntroDataArray {
//    if (!_allIntroDataArray) {
//        _allIntroDataArray = [NSMutableArray array];
//    }return _allIntroDataArray;
//}
//
////加载数据 刷新UI
//- (void)loadDataWithCommonModel:(VDCommonModel*)model isOff:(BOOL)isOff {
//    
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
//    [self.tableView reloadData];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView scrollsToTop];
//    });
//}
//
//#pragma mark - Table view data source
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.isEmpty ? 0 : 5;
//}
//
// - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//     if (indexPath.row==0) {
//         if (self.videoType==VideoType_Short) {
//             ShortVideoMsgCell *cell = [ShortVideoMsgCell cellForTableView:tableView];
//             cell.model = self.modelCommon;
//             return cell;
//         }else {
//             VideoMsgCell *cell = [VideoMsgCell cellForTableView:tableView];
//             cell.model = self.modelCommon;
//             WS()
//             cell.changeSourceBlock = ^(NSInteger indexSel) {
//                 [weakSelf loadEpisodeDataWithIndex:indexSel];
//             };
//             cell.clickBlock = ^(NSInteger btnType) {   //btnType : 1播放 3缓存
//                     switch (btnType) {
//                         case 1:
//                         {
//                             if (weakSelf.isAdvRequestFail) {
//                                 if (weakSelf.playBlock) {
//                                     weakSelf.playBlock();
//                                 }
//                                 break;
//                             }
//                             if (weakSelf.playBlock) {
//                                 weakSelf.playBlock();
//                             }
//                         }
//                             break;
//                         case 3:
//                         {
//                             if (weakSelf.isAdvRequestFail) {
//                                 [weakSelf showCacheView];
//                                 break;
//                             }
//                             [weakSelf showCacheView];
//                         }
//                             break;
//                         default:
//                             break;
//                     }
//             };
//             
//             return cell;
//         }
//     }else if (indexPath.row==1) {
//         VideoDetailAdvCell *cell = [VideoDetailAdvCell cellForTableView:tableView];
//         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//             [cell refreshAdvWithIsShort:(self.modelCommon.videoType == VideoType_Short)];
//         });
//         WS()
//         cell.refreshWhenNoAdvBlock = ^{
//             if (!weakSelf.isAdvRequestFail) {
//                 weakSelf.isAdvRequestFail = YES;
//                 [weakSelf.tableView reloadData];
//             }
//         };
//         return cell;
//     }else if (indexPath.row==2) {
//         SynopsisCell *cell = [SynopsisCell cellForTableView:tableView];
//         cell.model = self.modelCommon;
//         WS()
//         cell.foldOpenBlock = ^(BOOL isOpen) {
//             weakSelf.modelCommon.isOpen = isOpen;
//             [weakSelf.tableView beginUpdates];
//             [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
//             [weakSelf.tableView endUpdates];
//         };
//         return cell;
//     }else if (indexPath.row==3) {
//         SelectEpisodeCell *cell = [SelectEpisodeCell cellForTableView:tableView];
//         cell.model = self.modelCommon;
//         WS()
//         cell.showAllEpisodeBlock = ^{
//             [weakSelf getAllIntroDataArr];
//         };
//         //切换剧集, 更新的数据源model 以及 选中的剧集indexSel
//         cell.changeEpisodeBlock = ^(VDCommonModel *model) {
//             weakSelf.modelCommon = model;
//             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                 if(weakSelf.changeEpisodeBlock) {
//                     weakSelf.changeEpisodeBlock(model);
//                 }
//             });
//         };
//         return cell;
//     }else if (indexPath.row==4) {
//         if (self.videoType == VideoType_Short) {
//             NewGuessLikeCell *cell = [NewGuessLikeCell cellForTableView:tableView];
//             cell.model = self.modelCommon;
//             WS()
//             cell.selectBlock = ^(ProgramResultListModel *model) {
//                 NSDictionary *bp_dic = @{PROGRAM_ID : model.idForModel,
//                                          LABEL_ID : [model.categoryIds componentsJoinedByString:@","]
//                                          };
//                 [[BuryingPointManager shareManager] buryingPointWithEventID:BP_ShortDetailGuessLike andParameters:bp_dic];
//                 
//                 [weakSelf.tableView setContentOffset:CGPointMake(0,0) animated:NO];
//                 if (weakSelf.refreshNewVideoBlock) {
//                     weakSelf.refreshNewVideoBlock(model);
//                 }
//             };
//             cell.showMoreBlock = ^{
//                 [[BuryingPointManager shareManager] buryingPointWithEventID:BP_ShortDetailGuessFolder andParameters:@{}];
//                 [weakSelf showShortVideoGuessLikeView];
//             };
//             return cell;
//         }else {
//             GuessYouLikeCell *cell = [GuessYouLikeCell cellForTableView:tableView];
//             cell.model = self.modelCommon;
//             WS()
//             cell.selectBlock = ^(ProgramResultListModel *model) {
//                 [weakSelf.tableView setContentOffset:CGPointMake(0,0) animated:NO];
//                 if (weakSelf.refreshNewVideoBlock) {
//                     weakSelf.refreshNewVideoBlock(model);
//                 }
//             };
//             return cell;
//         }
//     }else {
//         return nil;
//     }
// }
//
//#pragma mark - 弹出短视频猜你喜欢ActionSheetView
//- (void)showShortVideoGuessLikeView {
//    GuessLikeActionSheetView * tool = [[GuessLikeActionSheetView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - VDTopViewH) AndData:self.modelCommon.likeDataArray];
//    WS()
//    tool.closeBlock = ^{
//        [weakSelf.zh_popupController dismissWithDuration:0.3 springAnimated:NO];
//    };
//    tool.selectBlock = ^(ProgramResultListModel *model) {
//        
//        NSDictionary *bp_dic = @{PROGRAM_ID : model.idForModel,
//                                 LABEL_ID : [model.categoryIds componentsJoinedByString:@","]
//                                 };
//        [[BuryingPointManager shareManager] buryingPointWithEventID:BP_ShortDetailGuessLike andParameters:bp_dic];
//        
//        [weakSelf.zh_popupController dismissWithDuration:0.3 springAnimated:NO];
//        [weakSelf.tableView setContentOffset:CGPointMake(0,0) animated:NO];
//        if (weakSelf.refreshNewVideoBlock) {
//            weakSelf.refreshNewVideoBlock(model);
//        }
//    };
//    weakSelf.zh_popupController = [zhPopupController new];
//    weakSelf.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
//    weakSelf.zh_popupController.dismissOnMaskTouched = YES;
//    [weakSelf.zh_popupController presentContentView:tool];
//}
//
///* 弹出全部剧集View前,请求全部剧集IntroData */
//- (void)getAllIntroDataArr {
//    if (self.allIntroDataArray.count>0) {
//        [self showAllEpisodeView];
//    }else {
//        SSGifShow(MainWindow, @"加载中");
//        NSDictionary *dic = @{@"pt" : self.modelCommon.type ? self.modelCommon.type : @"",
//                              @"pi" : self.modelCommon.idForModel ? self.modelCommon.idForModel : @"",
//                              @"index" : @(0),
//                              @"size" : @(1000),
//                              @"si" : self.modelCommon.siCurrent
//                              };
//        [[SSRequest request]GET:AllEpisodeIntroUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
//            
//            SSDissMissAllGifHud(MainWindow, YES);
//
//            self.allIntroDataArray = [EpisodeIntroModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
//            [self.allIntroDataArray enumerateObjectsUsingBlock:^(EpisodeIntroModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                [obj refreshData];
//            }];
//            [self showAllEpisodeView];
//            
//        } failure:^(SSRequest *request, NSString *errorMsg) {
//            SSDissMissAllGifHud(MainWindow, YES);
//            
//            [self showAllEpisodeView];
//            
//        }];
//    }
//}
//
//- (void)showAllEpisodeView {
//    AllEpisodeView * tool = [[AllEpisodeView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - VDTopViewH) AndData:self.modelCommon AndIntroArr:self.allIntroDataArray.copy];
//    WS()
//    tool.closeBlock = ^{
//        [weakSelf.zh_popupController dismissWithDuration:0.3 springAnimated:NO];
//    };
//    tool.selectBlock = ^(VDCommonModel *model) {
//        [weakSelf.zh_popupController dismissWithDuration:0.3 springAnimated:NO];
//        weakSelf.modelCommon = model;
//        
//        //更新外面的选集UI
//        [weakSelf.tableView reloadData];
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if(weakSelf.changeEpisodeBlock) {
//                weakSelf.changeEpisodeBlock(model);
//            }
//        });
////不用刷新了, 都dismiss了
////        [weakSelf.tableView beginUpdates];
////        NSIndexPath *idx = [NSIndexPath indexPathForRow:2 inSection:0];
////        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:idx,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
////        [weakSelf.tableView endUpdates];
//    };
//    weakSelf.zh_popupController = [zhPopupController new];
//    weakSelf.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
//    weakSelf.zh_popupController.dismissOnMaskTouched = YES;
//    [weakSelf.zh_popupController presentContentView:tool];
//}
//
//#pragma mark - 显示缓存View
//- (void)showCacheView {
//    CacheView * tool = [[CacheView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - VDTopViewH) andData:self.modelCommon];
//    WS()
//    tool.closeBlock = ^{
//        [weakSelf.zh_popupController dismissWithDuration:0.3 springAnimated:NO];
//    };
//    tool.goCacheBlock = ^{
//        [weakSelf.zh_popupController dismissWithDuration:0.3 springAnimated:NO];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            DownloadViewController *vc = [[DownloadViewController alloc]init];
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//        });
//    };
//    
//    weakSelf.zh_popupController = [zhPopupController new];
//    weakSelf.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
//    weakSelf.zh_popupController.dismissOnMaskTouched = YES;
//    [weakSelf.zh_popupController presentContentView:tool];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row==0) {
//        return self.modelCommon.cellHeight_Msg;
//    }else if (indexPath.row==1) {
//        return self.isAdvRequestFail ? 0 : self.modelCommon.cellHeight_Adv;
//    }else if (indexPath.row==2) {
//        if (self.modelCommon.cellHeight_Intro>self.sizeH(45)) {
//            return self.modelCommon.isOpen ? self.modelCommon.cellHeight_Intro : self.sizeH(45+80);
//        }else {
//            return self.modelCommon.cellHeight_Intro;
//        }
//        
//    }else if (indexPath.row==3) {
//        return self.modelCommon.cellHeight_Episode;
//    }else if (indexPath.row==4) {
//        if(self.videoType==VideoType_Short) {
//            NSInteger num = 3;
//            if (self.likeDataArray.count==0) {
//                return 0;
//            }else if (self.likeDataArray.count<3) {
//                num = self.likeDataArray.count;
//                return self.sizeH(50) + self.sizeH(cellHeightForShortVideoGuessLike) * num;
//            }else {
//                return self.sizeH(50+50) + self.sizeH(cellHeightForShortVideoGuessLike) * num;
//            }
//        }else {
//            return self.modelCommon.cellHeight_GuessULike;
//        }
//    }else {
//        return 0;
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0.01;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01;
//}
//
//#pragma mark - 切换时 重新请求
//- (void)loadEpisodeDataWithIndex:(NSInteger)indexSel {
//    //通知外面更新数据
//    self.modelCommon.indexSelectForSource = indexSel;
//    self.modelCommon.siCurrent = self.modelCommon.mediaSourceResultList[indexSel].idForModel;
//    if (self.updateDataWhenChangeSourceBlock) {
//        self.updateDataWhenChangeSourceBlock(self.modelCommon);
//    }
//    
//    NSDictionary *dic = @{@"pt" : self.modelCommon.type ? self.modelCommon.type : @"",
//                          @"pi" : self.modelCommon.idForModel ? self.modelCommon.idForModel : @"",
//                          @"size" : @(1000),
//                          @"index" : @(0),
//                          @"si" : self.modelCommon.siCurrent,  //来源 默认传
//                          };
//    [[SSRequest request]GET:VideoDetail_NumberOfEpisodeUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
//        
//        SSLog(@"EpisodeArrayMsgModel:%@",response);
//        self.episodeDataArray = [MediaTipResultModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
//        self.modelCommon.episodeDataArray = [self.episodeDataArray copy];
//        [self.tableView beginUpdates];
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0],nil] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView endUpdates];
//        
//    } failure:^(SSRequest *request, NSString *errorMsg) {
//        SSMBToast(errorMsg, MainWindow);
//    }];
//}
//
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
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}

@end
