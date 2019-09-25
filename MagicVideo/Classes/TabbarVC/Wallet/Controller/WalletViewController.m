//
//  WalletViewController.m
//  MagicVideo
//
//  Created by young He on 2019/9/18.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "WalletViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "UILabel+Category.h"
#import "UIButton+Category.h"
#import "WalletHeaderView.h"
#import "WalletDetailCell.h"

@interface WalletViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, copy) NSMutableArray<NSArray *> *dataArrayRed;
@property (nonatomic, copy) NSMutableArray<NSArray *> *dataArrayMoney;
@property (nonatomic, weak) WalletHeaderView *headerView;
@property (nonatomic,strong) WalletUnLoginView *unLoginView;
@property (nonatomic,assign) BOOL isRedDetail; //红包明细 or 提现
@end

@implementation WalletViewController

static NSString * const cellHeader_ID = @"WalletHeaderView_ID";


- (NSMutableArray<NSArray *> *)dataArrayRed {
    if (!_dataArrayRed) {
        _dataArrayRed = [NSMutableArray array];
    }return _dataArrayRed;
}

- (NSMutableArray<NSArray *> *)dataArrayMoney {
    if (!_dataArrayMoney) {
        _dataArrayMoney = [NSMutableArray array];
    }return _dataArrayMoney;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isRedDetail = YES;
    [self initTableView];
    [self refreshWhenLoginChange];
    
    [self loadDateWithAnimation:YES];
    
    [NOTIFICATION addObserver:self selector:@selector(refreshWhenLoginChange) name:LOGIN_IN_Noti object:nil];
    [NOTIFICATION addObserver:self selector:@selector(refreshWhenLoginChange) name:LOGIN_OUT_Noti object:nil];
    [NOTIFICATION addObserver:self selector:@selector(refreshWhenLoginChange) name:RefreshUserMsgNoti object:nil];
    
    
}


- (void)loadDateWithAnimation:(BOOL)isAnimation {
    if (isAnimation) {SSGifShow(MainWindow, @"加载中");}
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isAnimation) {SSDissMissAllGifHud(MainWindow, YES);}
        self.isNetError = SSNetNormal_state;
        [self.mainTableView reloadEmptyDataSet];
    });
    
//    NSDictionary *dic = @{
//                          @"<#xxx#>" : <#xxx#>,
//                          @"size" : @(PageCount_Normal)
//                          };
//    [[SSRequest request]POST:<#Url#> parameters:dic.mutableCopy success:^(SSRequest *request, id response) {
//
//        if (isAnimation) {SSDissMissAllGifHud(MainWindow, YES);}
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

//登录状态改变时 or 用户资料改变时(用户名) 的UI处理
- (void)refreshWhenLoginChange {
    if ([USER_MANAGER isLogin]) {
        //用户资料改变时(用户名) UI更新
        [self.headerView refreshMsg];
        
        self.fd_prefersNavigationBarHidden = YES;
        if(_unLoginView) {
            _unLoginView.hidden = YES;
            [self.view sendSubviewToBack:_unLoginView];
        }
    }else {
        self.fd_prefersNavigationBarHidden = NO;
        self.navigationItem.title = @"个人钱包";
        if(!_unLoginView) {
            [self.view addSubview:self.unLoginView];
            [self.unLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }
        _unLoginView.hidden = NO;
        [self.view bringSubviewToFront:_unLoginView];
    }
}

- (void)initTableView {
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isRedDetail ? self.dataArrayRed.count : self.dataArrayMoney.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isRedDetail ? self.dataArrayRed[section].count : self.dataArrayMoney[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WalletDetailCell *cell = [WalletDetailCell cellForTableView:tableView];
//    cell.model = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section==1) {
//        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.sizeH(10))];
//        header.backgroundColor = KCOLOR(@"#f8f8f8");
//        return header;
//    }else {
//        return [[UIView alloc]init];
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return (section==1) ? self.sizeH(10) : 0.01;
//}

#pragma mark - lazyLoad
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.emptyDataSetDelegate = self;
        _mainTableView.emptyDataSetSource = self;
        _mainTableView.backgroundColor = White_Color;
        _mainTableView.rowHeight = self.sizeW(48);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.bounces = NO;
        WalletHeaderView *headerView = [[WalletHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
        WS()
        headerView.withdrawBlock = ^{
            if (IS_LOGIN) {
//                ModifyMsgViewController *vc = [[ModifyMsgViewController alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else {
                [USER_MANAGER gotoLoginFromVC:weakSelf];
            }
        };
        headerView.barBtnClickBlock = ^(BOOL isRed) {
            if (isRed) {
                
            }else {
                
            }
        };
        headerView.tipShowBlock = ^(BOOL isWithdraw) { 
            if (isWithdraw) {
                
            }else {
                
            }
        };
        self.headerView = headerView;
        _mainTableView.tableHeaderView = self.headerView;
        
    }return _mainTableView;
}

-(WalletUnLoginView *)unLoginView {
    if (!_unLoginView) {
        _unLoginView = [[WalletUnLoginView alloc]init];
        WS()
        _unLoginView.loginBlock = ^{
            [USER_MANAGER gotoLoginFromVC:weakSelf];
        };
    }return _unLoginView;
}

#pragma mark--DZ
-(UIImage*)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if(self.isNetError==SSNetLoading_state)return nil;
    return self.isNetError == SSNetNormal_state ? Image_Named(@"netError") : Image_Named(@"netError");
}

-(NSAttributedString*)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if(self.isNetError==SSNetLoading_state)return nil;
    NSString *text = self.isNetError==SSNetError_state?@"网络请求失败": self.isRedDetail ? @"您暂时还没有红包记录哦" : @"您暂时还没有提现记录哦";
    NSDictionary *attribute = self.isNetError?@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: KCOLOR(@"#333333")}:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0f], NSForegroundColorAttributeName: KCOLOR(@"#999999")};
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}

// 返回详情文字
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    if(self.isNetError==SSNetNormal_state && self.isRedDetail) {
        NSString *text = @"快来 看视频 抢红包吧";
        NSRange ran = [text rangeOfString:@"看视频"];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
        [attrString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:KCOLOR(@"#999999")} range:NSMakeRange(0, text.length)];
        [attrString addAttributes:@{NSForegroundColorAttributeName:Red_Color,NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:ran];
        return attrString;
    }
    
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
    if(self.isRedDetail) {  //跳去 看视频
        SSMBToast(@"跳去看视频", MainWindow);
        return;
    }
    
    self.isNetError = SSNetLoading_state;
    //    [self.mainTableView reloadEmptyDataSet];
    //    [self loadDateWithAnimation:YES];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if(self.isRedDetail) {
        return (self.dataArrayRed.count==0);
    }else {
        return (self.dataArrayMoney.count==0);
    }
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return self.sizeW(135);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end


@interface WalletUnLoginView()
@end

@implementation WalletUnLoginView

- (instancetype)init {
    if(self = [super init]) {
        [self initUI];
    }return self;
}

- (void)initUI {
    self.backgroundColor = White_Color;
    UIImageView *iv = [[UIImageView alloc]initWithImage:Image_Named(@"wallet_not_login")];
    [self addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(self.sizeH(76)+[self contentOffset]);
    }];
    UILabel *lab = [UILabel labelWithTitle:@"您当前未登录账户，无法进行钱包操作，登录后方可进行操作" font:18 textColor:color_defaultText textAlignment:1];
    lab.numberOfLines = 0;
    [self addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iv.mas_bottom).offset(self.sizeH(24));
        make.centerX.equalTo(iv);
        make.left.equalTo(self).offset(self.sizeW(50));
        make.right.equalTo(self).offset(self.sizeW(-50));
    }];
    
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"去登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = Font_Size(19);
    [loginBtn setTitleColor:White_Color forState:UIControlStateNormal];
    [loginBtn setTitleColor:White_Color forState:UIControlStateSelected];
    [loginBtn setBackgroundColor:KCOLOR(@"#D9D919") forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:KCOLOR(@"#D9D919") forState:UIControlStateHighlighted];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = self.sizeH(10);
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(self.sizeH(30));
        make.centerX.equalTo(iv);
        make.width.equalTo(self.sizeH(142));
        make.height.equalTo(self.sizeH(42));
    }];
}

- (void)loginBtnClick {
    if(self.loginBlock) {
        self.loginBlock();
    }
}

@end
