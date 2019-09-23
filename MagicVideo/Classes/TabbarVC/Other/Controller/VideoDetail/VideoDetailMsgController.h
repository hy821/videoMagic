//
//  VideoDetailMsgController.h
//  KSMovie
//
//  Created by young He on 2018/9/17.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import "KSBaseViewController.h"

@interface VideoDetailMsgController : UITableViewController

////加载数据 刷新UI,  model为空时: 网络请求失败 或者 网络请求成功,返回model为空(下架)
//- (void)loadDataWithCommonModel:(VDCommonModel*)model isOff:(BOOL)isOff;
//
//@property (nonatomic,copy) void(^loadDataBlock)(void); //数据为空时, 点击emptyDataSet 请求数据
//
//@property (nonatomic,copy) void(^updateDataWhenChangeSourceBlock)(VDCommonModel *model); //切换数据源时,更新外面数据
//
////切换剧集 通知上一层 请求数据
//@property (nonatomic,copy) void(^changeEpisodeBlock)(VDCommonModel *model);
//
////点击猜你喜欢, 本页面刷新切换新视频
//@property (nonatomic,copy) void(^refreshNewVideoBlock)(ProgramResultListModel *model);
//
////点击了收藏旁边的 播放按钮 通知上一层 播放
//@property (nonatomic,copy) void(^playBlock)(void);

@end
