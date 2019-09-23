//
//  VideoDetailCommentController.m
//  KSMovie
//
//  Created by young He on 2018/9/17.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import "VideoDetailCommentController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

//#import "CommentSectionHeaderView.h"
//#import "CommentSectionFooterView.h"
//#import "CommentCell.h"
//#import "CommentSeeAllCell.h"
//#import "SubCommentView.h"
//#import <zhPopupController.h>

@interface VideoDetailCommentController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) SSNetState isNetError;

//@property (nonatomic,strong) NSMutableArray<CommentModel *> *dataArr;
//@property (nonatomic,copy) NSString *cursor;
//@property (nonatomic,strong) CommentModel *replyModel;  //点击header获取
@end

@implementation VideoDetailCommentController

static NSString * CommentHeadID = @"CommentHeadID";
static NSString * CommentFooterID = @"CommentFooterID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = White_Color;
//    self.cursor = @"-1";
//
//    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(VDTabHeight, 0, 45, 0));
//    }];
//    [self.view addSubview:self.inputView];
//    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.equalTo(self.view);
//        make.height.equalTo(45);
//    }];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDateWhenLogin) name:LoginAndRefreshNoti object:nil];
}

//- (NSMutableArray<CommentModel *> *)dataArr {
//    if (!_dataArr) {
//        _dataArr = [NSMutableArray array];
//    }return _dataArr;
//}
//
//- (void)setPid:(NSString *)pid {
//    _pid = pid;
//    [self loadDateWithAnimation:YES];
//}
//
//- (void)loadDateWhenLogin {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.cursor = @"-1";
//        [self loadDateWithAnimation:NO];
//    });
//}
//
//-(void)loadDateWithAnimation:(BOOL)isAnimation {
//    if (!self.pid || self.pid.length == 0) {
//        self.isNetError = SSNetError_state;
//        if(self.dataArr.count>0) { [self.dataArr removeAllObjects]; }
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//        [self.tableView reloadData];
//        return;
//    }
//    if (isAnimation) {SSGifShow(MainWindow, @"加载中");}
//    NSDictionary *dic = @{
//                          @"pid" : self.pid,
//                          @"cursor" : self.cursor,
//                          @"size" : @(PageCount_Normal)
//                          };
//    [[SSRequest request]GET:VideoDetailCommentListUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
//        if (isAnimation) {SSDissMissAllGifHud(MainWindow, YES);}
//        self.isNetError = SSNetNormal_state;
//        [self.tableView.mj_header endRefreshing];
//        
//        if([self.cursor isEqualToString:@"-1"] && (self.dataArr.count>0)) {
//            [self.dataArr removeAllObjects];
//        }
//        
//        NSArray *arr = [CommentModel mj_objectArrayWithKeyValuesArray:response[@"data"]];
//        [arr enumerateObjectsUsingBlock:^(CommentModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if(obj.commentInfoList.count>0) {
//                [obj.commentInfoList enumerateObjectsUsingBlock:^(CommentModel * _Nonnull subObj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    [subObj refreshSubComment];
//                }];
//            }
//        }];
//        [self.dataArr addObjectsFromArray:arr];
//        
//        if (arr.count<PageCount_Normal) {
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        }else {
//            [self.tableView.mj_footer endRefreshing];
//        }
//        [self.tableView reloadData];
//    } failure:^(SSRequest *request, NSString *errorMsg) {
//        if (isAnimation) {SSDissMissAllGifHud(MainWindow, YES);}
//        SSMBToast(errorMsg, MainWindow);
//        self.isNetError = SSNetError_state;
//        [self.tableView reloadEmptyDataSet];
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//    }];
//}
//
//#pragma mark - Table view data source
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.dataArr.count>0 && self.dataArr[indexPath.section].commentInfoList.count>0)
//    {
//        if ([self.dataArr[indexPath.section].count integerValue] > 2 && (indexPath.row==2)) {
//            CommentSeeAllCell *seeAllCell = [CommentSeeAllCell cellForTableView:tableView];
//            seeAllCell.model = self.dataArr[indexPath.section];
//            return seeAllCell;
//        }
//        CommentCell * cell = [CommentCell  cellForTableView:tableView];
//        cell.model = self.dataArr[indexPath.section].commentInfoList[indexPath.row];
//        return cell;
//    }
//    CommentCell * cell = [CommentCell  cellForTableView:tableView];
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(self.inputView.isFirstResponder) {
//        [self.view endEditing:YES];
//        return;
//    }
//    if (self.dataArr.count==0) {return;}
//    if (self.dataArr[indexPath.section].commentInfoList.count>0) {
//        //显示子评论详情View
//        [self showSubCommentViewWithModel:self.dataArr[indexPath.section]];
//    }
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (self.dataArr.count==0) {return nil;}
//    CommentSectionHeaderView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CommentHeadID];
//    if(header == nil) { header = [[CommentSectionHeaderView alloc]initWithReuseIdentifier:CommentHeadID]; }
//    header.model = self.dataArr[section];
//    WS()
//    header.replyBlock = ^(){  //点击header弹出回复框
//        if(![USER_MANAGER isLogin]) {  //评论先登录
//            SSMBToast(@"登录后可评论喔~", MainWindow);
//            [weakSelf goLogin];
//            return;
//        }
//        CommentModel *m = weakSelf.dataArr[section];
//        if ([m.userBasic.userId isEqualToString:[USER_MANAGER getUserID]]) {
//            SSMBToast(@"不能回复自己的评论喔~", MainWindow);
//            return;
//        }
//        weakSelf.replyModel = m;
//        weakSelf.replyModel.indexReply = section;
//        [weakSelf.inputView setPlaceHolder:[NSString stringWithFormat:@"回复%@:",weakSelf.replyModel.userBasic.nickName]];
//        [weakSelf.inputView becomeFirstResponder];
//    };
//    header.likeBtnToLoginBlock = ^(){
//        SSMBToast(@"登录后可点赞喔~", MainWindow);
//        [weakSelf goLogin];
//    };
//    return header;
//}
//
//- (void)goLogin {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(commentGoLogin)]) {
//        [self.delegate commentGoLogin];
//    }
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (self.dataArr.count==0) {return nil;}
//    CommentSectionFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CommentFooterID];
//    if(footer == nil) { footer = [[CommentSectionFooterView alloc]initWithReuseIdentifier:CommentFooterID]; }
//    return footer;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return (self.dataArr.count>0) ? self.dataArr[section].headerHeight : 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return (self.dataArr.count>0) ? self.dataArr[section].footerHeight : 0;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.dataArr.count>0) {
//        if (self.dataArr[indexPath.section].commentInfoList.count > 0) {
//            if ([self.dataArr[indexPath.section].count integerValue] > 2) {
//                if (indexPath.row==2) {
//                    return self.sizeH(22);  //查看全部回复
//                }else {
//                    return self.dataArr[indexPath.section].commentInfoList[indexPath.row].contentHeight;
//                }
//            }else {
//                return self.dataArr[indexPath.section].commentInfoList[indexPath.row].contentHeight;
//            }
//        }
//    }return 0;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return (self.dataArr.count>0) ? self.dataArr.count : 0;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.dataArr.count>0) {
//        if (self.dataArr[section].commentInfoList.count > 0) {
//            if ([self.dataArr[section].count integerValue] > 2) {
//                return 3;
//            }else {
//                return self.dataArr[section].commentInfoList.count;
//            }
//        }
//    }return 0;
//}
//
//- (void)showSubCommentViewWithModel:(CommentModel*)m {
//    m.pid = self.pid;
//    SubCommentView * tool = [[SubCommentView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-VDTopViewH)];
//    m.videoType = [self.assetType integerValue];
//    tool.model = m;
//    WS()
//    tool.closeBlock = ^{
//        [weakSelf.zh_popupController dismissWithDuration:0.2 springAnimated:NO];
//    };
//    
//    tool.keyBoardShowHideBlock = ^(CGFloat h) {
//        if (weakSelf.zh_popupController.offsetSpacingOfKeyboard != -h) {
//            weakSelf.zh_popupController.offsetSpacingOfKeyboard = -h;
//        }
//    };
//    tool.goLoginBlock = ^{
//        [weakSelf.zh_popupController dismissWithDuration:0.2 springAnimated:NO];
//        [weakSelf goLogin];
//    };
//    self.zh_popupController = [zhPopupController new];
//    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
//    self.zh_popupController.dismissOnMaskTouched = YES;
//    [self.zh_popupController presentContentView:tool];
//}
//
////切换影片后, 清空评论
//- (void)reloadEmptyDataWhenChangeVideo {
//    self.isNetError = SSNetNormal_state;
//    [self.dataArr removeAllObjects];
//    [self.tableView reloadData];
//    
//    if (self.replyModel) {
//        self.replyModel = nil;
//    }
//    if(self.inputView) {
//        [self.inputView setPlaceHolder:@"我要来吐槽..."];
//    }
//}
//
////评论成功, 重置回复对象为空
//- (void)resetReplyModel {
//    if (self.replyModel) {
//        self.replyModel = nil;
//    }
//    if(self.inputView) {
//        [self.inputView setPlaceHolder:@"我要来吐槽..."];
//    }
//}
//
//- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
//    return (self.dataArr.count==0);
//}
//
//-(KeyboardTextView *)inputView {
//    if (!_inputView) {
//        _inputView = [[KeyboardTextView alloc] initWithTextViewFrame:CGRectMake(0, 0, ScreenWidth, 45)];
//        WS()
//        [_inputView setSendMesButtonClickedBlock:^(NSString *text) {
//            [weakSelf replyActionWithDetails:text];
//        }];
//        _inputView.keyboardWillHideShow = ^(CGFloat height, CGFloat dur) {
//            [weakSelf remakeInputViewWithHeight:height andDu:dur];
//        };
//    }return _inputView;
//}
//
//- (void)remakeInputViewWithHeight:(CGFloat)h andDu:(CGFloat)du{
//    [_inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.height.equalTo(45);
//        make.bottom.equalTo(self.view).offset(-h);
//    }];
//    [UIView animateWithDuration:du animations:^{
//        [self.view layoutIfNeeded];
//    }];
//}
//
//- (void)replyActionWithDetails:(NSString*)details {
//    if(![USER_MANAGER isLogin]) {  //评论先登录
//        SSMBToast(@"登录后可评论喔~", MainWindow);
//        [self goLogin];
//        return;
//    }
//    
//    [self.view endEditing:YES];
//    SSGifShow(MainWindow, @"加载中");
//    NSDictionary *dic = @{@"ownerId" : self.pid,
//                          @"details" : details,
//                          @"assetType" : self.assetType ? self.assetType : @"",
//                          @"associateId" : self.replyModel ? self.replyModel.idForModel : @"",
//                          @"rootId" : self.replyModel ? self.replyModel.rootId : @"",
//                          @"machine" : [USER_MANAGER getDeviceName]
//                          };
//    SSLog(@"%@",dic);
//    [[SSRequest request]POST:ReplyCommentUrl parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
//        SSDissMissAllGifHud(MainWindow, YES);
//        
//        if (self.replyModel) {  //子评论
//            CommentModel *m = [[CommentModel alloc]init];
//            m.details = details;
//            m.timeString = @"刚刚";
//            UserBasicModel *uModel = [[UserBasicModel alloc]init];
//            uModel.nickName = [USER_MANAGER getUserNickName];
//            uModel.portrait = [USER_MANAGER getUserIcon];
//            uModel.userId = [USER_MANAGER getUserID];
//            m.userBasic = uModel;
//            CommentModel *mReply = self.dataArr[self.replyModel.indexReply];
//            [m refreshSubComment];
//            NSMutableArray *newSubComList = [NSMutableArray arrayWithArray:[mReply.commentInfoList copy]];
//            [newSubComList insertObject:m atIndex:0];
//            mReply.commentInfoList = [newSubComList copy];
//            [self.tableView reloadData];
//            
//        }else {  //一级评论
//            CommentModel *m = [[CommentModel alloc]init];
//            m.details = details;
//            m.timeString = @"刚刚";
//            UserBasicModel *uModel = [[UserBasicModel alloc]init];
//            uModel.nickName = [USER_MANAGER getUserNickName];
//            uModel.portrait = [USER_MANAGER getUserIcon];
//            uModel.userId = [USER_MANAGER getUserID];
//            m.userBasic = uModel;
//            [self.dataArr insertObject:m atIndex:0];
//            [self.tableView reloadData];
//        }
//        
//        [self resetReplyModel];
//        
//    } failure:^(SSRequest *request, NSString *errorMsg) {
//        SSDissMissAllGifHud(MainWindow, YES);
//        SSMBToast(errorMsg, MainWindow);
//    }];
//}
//
//- (UITableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.emptyDataSetSource = self;
//        _tableView.emptyDataSetDelegate = self;
//        _tableView.backgroundColor = White_Color;
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.estimatedRowHeight = 0.f;
//        _tableView.estimatedSectionFooterHeight = 0.f;
//        _tableView.estimatedSectionHeaderHeight = 0.f;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//        [_tableView registerClass:[CommentSectionHeaderView class] forHeaderFooterViewReuseIdentifier:CommentHeadID];
//        [_tableView registerClass:[CommentSectionFooterView class] forHeaderFooterViewReuseIdentifier:CommentFooterID];
//        WS()
//        _tableView.mj_header = [MYHRocketHeader headerWithRefreshingBlock:^{
//            weakSelf.cursor = @"-1";
//            [weakSelf loadDateWithAnimation:NO];
//        }];
//        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            weakSelf.cursor = self.dataArr.count>0 ? self.dataArr.lastObject.createTime : @"-1";
//            [weakSelf loadDateWithAnimation:NO];
//        }];
//    }return _tableView;
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
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
//    NSString *text = self.isNetError==SSNetError_state?@"网络请求失败":@"暂无评论, 快来抢沙发~";
//    NSDictionary *attribute = self.isNetError?@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: KCOLOR(@"#333333")}:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: KCOLOR(@"#999999")};
//    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
//}
//
//// 返回详情文字
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
//    if(self.isNetError!=SSNetError_state)return nil;
//    NSString *text = @"加载失败, 点击重试";
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
//    self.isNetError = SSNetLoading_state;
//    [self.tableView reloadEmptyDataSet];
//    self.cursor = @"-1";
//    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
//    [self loadDateWithAnimation:YES];
//}
//
//-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
//    return YES;
//}

//-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    return self.sizeH(50);
//}

@end
