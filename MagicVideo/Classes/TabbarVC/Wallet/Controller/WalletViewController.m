//
//  WalletViewController.m
//  MagicVideo
//
//  Created by young He on 2019/9/18.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "WalletViewController.h"
#import "UILabel+Category.h"
#import "UIButton+Category.h"
#import "WalletHeaderView.h"
#import "WalletDetailCell.h"

@interface WalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, copy) NSMutableArray<NSArray *> *dataArray;
@property (nonatomic, weak) WalletHeaderView *headerView;
@property (nonatomic,strong) WalletUnLoginView *unLoginView;

@end

@implementation WalletViewController

static NSString * const cellHeader_ID = @"WalletHeaderView_ID";

- (NSMutableArray<NSArray *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray *arr = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        [_dataArray addObject:[arr copy]];
    }return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NOTIFICATION addObserver:self selector:@selector(refreshWhenLoginChange) name:LOGIN_IN_Noti object:nil];
    [NOTIFICATION addObserver:self selector:@selector(refreshWhenLoginChange) name:LOGIN_OUT_Noti object:nil];
    [self initTableView];
    [self refreshWhenLoginChange];
}

//登录状态改变时的UI处理
- (void)refreshWhenLoginChange {
    if ([USER_MANAGER isLogin]) {
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
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].count;
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
        _mainTableView.bounces = NO;
        _mainTableView.backgroundColor = White_Color;
        _mainTableView.rowHeight = self.sizeW(48);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        WalletHeaderView *headerView = [[WalletHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth+self.sizeW(20))];
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
