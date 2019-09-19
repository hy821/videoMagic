//
//  ShortVideoListCell.h
//  KSMovie
//
//  Created by young He on 2019/2/11.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CountDownView.h"

@protocol ShortVideoListCellDelegate <NSObject>

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ShortVideoListCell : UITableViewCell

//@property (nonatomic,strong) ProgramResultListModel *model;
//@property (nonatomic,copy) void(^upDataModelBlock)(ProgramResultListModel *model);  //点过赞或踩之后更新数据
//@property (nonatomic,copy) void(^showMoreShareViewBlock)(void);
//
//@property (nonatomic, copy) void(^playCallback)(void);
//
////广告倒计时完 or 跳过 or 加载失败时, 通知去播放视频 isFinish: YES 今日播放成功   NO今日播放还未成功,下次还得播---暂时都成功
//@property (nonatomic,copy) void(^advFinishToPlayVideoBlock)(BOOL isFinish);
//
//- (void)setDelegate:(id<ShortVideoListCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath;
//
//- (void)showCountDownAdv;
//
////重置广告相关  移除广告  隐藏countDownView  显示coverImageView
////暴露出来, 是为了展示广告的时候, 点击进入详情页, 需要
//- (void)resetAdvUI;
//
//- (void)showMaskView;
//
//- (void)hideMaskViewWithAdv:(BOOL)isShowAdv;  //是否是第一个cell 是的话, 是否展示adv
//
//- (void)setNormalMode;

@end
