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

@interface WalletViewController ()

@property (nonatomic,strong) WalletUnLoginView *unLoginView;

@end

@implementation WalletViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NOTIFICATION addObserver:self selector:@selector(refreshWhenLoginChange) name:LOGIN_IN_Noti object:nil];
    [NOTIFICATION addObserver:self selector:@selector(refreshWhenLoginChange) name:LOGIN_OUT_Noti object:nil];
    [self initUI];
   
}

- (void)initUI {
    if ([USER_MANAGER isLogin]) {
        self.fd_prefersNavigationBarHidden = YES;
        
    }else {
        self.navigationItem.title = @"个人钱包";
        [self.view addSubview:self.unLoginView];
        [self.unLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake([self contentOffset], 0, 0, 0));
        }];
        self.unLoginView.hidden = NO;
    }
}

//登录, 登出都刷新
- (void)refreshWhenLoginChange {
    [self initUI];
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
    UIImageView *iv = [[UIImageView alloc]initWithImage:Image_Named(@"wallet_not_login")];
    [self addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(self.sizeH(76));
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
