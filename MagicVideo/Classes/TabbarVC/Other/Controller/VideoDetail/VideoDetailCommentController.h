//
//  VideoDetailCommentController.h
//  KSMovie
//
//  Created by young He on 2018/9/17.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import "KSBaseViewController.h"
//#import "MYHRocketHeader.h"
//#import "KeyboardTextView.h"

@protocol VideoDetailCommentDelegate <NSObject>
-(void)commentGoLogin; //评论先登录
@end

@interface VideoDetailCommentController : UIViewController

@property (nonatomic,assign) id<VideoDetailCommentDelegate>delegate;

////发表评论需要影片类型
//@property (nonatomic,copy) NSString *assetType;
//
//@property (nonatomic,copy) NSString *pid;
//
//@property (nonatomic,strong) NSIndexPath * indexPath;
//
//@property (nonatomic,strong) KeyboardTextView *inputView;
//
////切换影片后, 清空评论, 重置回复评论
//- (void)reloadEmptyDataWhenChangeVideo;
//
////评论回复成功, 重置回复对象为空
//- (void)resetReplyModel;

@end
