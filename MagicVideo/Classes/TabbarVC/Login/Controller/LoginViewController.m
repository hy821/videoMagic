//
//  LoginViewController.m
//  MagicVideo
//
//  Created by young He on 2019/9/18.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginByCodeController.h"

#import "UILabel+Category.h"
#import "UIButton+Category.h"

@interface LoginViewController()

@property (nonatomic,weak) UIButton *codeLoginBtn;
@property (nonatomic,weak) UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)createUI {
    self.fd_prefersNavigationBarHidden = YES;
    UIImageView *bgIV = [[UIImageView alloc]initWithImage:Image_Named(@"loginBG")];
    bgIV.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgIV];
    [bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIButton *backBtn = [UIButton buttonWithImage:Image_Named(@"back_login") selectedImage:Image_Named(@"back_login")];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.sizeH(43));
        make.left.equalTo(self.view).offset(self.sizeW(15));
    }];
    
    UIImageView *logoIV = [[UIImageView alloc]initWithImage:Image_Named(@"loginLogo")];
    [self.view addSubview:logoIV];
    [logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.sizeH(68));
        make.centerX.equalTo(self.view);
    }];
    UIImageView *logoTextIV = [[UIImageView alloc]initWithImage:Image_Named(@"loginLogoText")];
    [self.view addSubview:logoTextIV];
    [logoTextIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoIV.mas_bottom).offset(self.sizeH(10));
        make.centerX.equalTo(self.view);
    }];
    
    UIView *loginAlphaView = [[UIView alloc]init];
    loginAlphaView.backgroundColor = KCOLOR(@"#ffffff");
    loginAlphaView.alpha = 0.2;
    loginAlphaView.layer.masksToBounds = YES;
    loginAlphaView.layer.cornerRadius = self.sizeH(8);
    [self.view addSubview:loginAlphaView];
    [loginAlphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoTextIV.mas_bottom).offset(self.sizeH(120));
        make.centerX.equalTo(self.view);
        make.width.equalTo(ScreenWidth*4/5);
        make.height.equalTo(self.sizeH(45));
    }];
    UIButton * loginBtn = [UIButton buttonWithTitle:@"微信登录" titleColor:KCOLOR(@"#ffffff") image:Image_Named(@"loginWXLogo") font:18];
    [loginBtn setBackgroundColor:Clear_Color forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:Clear_Color forState:UIControlStateHighlighted];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = self.sizeH(8);
    loginBtn.layer.borderColor = KCOLOR(@"#ffffff").CGColor;
    loginBtn.layer.borderWidth = 1.5;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(loginAlphaView);
    }];
    
    UIButton *codeLoginBtn = [UIButton buttonWithTitle:@"短信快捷登录" titleColor:KCOLOR(@"#ffffff") bgColor:Clear_Color highlightedColor:KCOLOR(@"#ffffff")];
    NSString *text = @"短信快捷登录";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0, text.length)];
    [codeLoginBtn.titleLabel setFont:Font_Size(14)];
    codeLoginBtn.titleLabel.attributedText = attrString;
    [codeLoginBtn addTarget:self action:@selector(codeLoginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeLoginBtn];
    self.codeLoginBtn = codeLoginBtn;
    [self.codeLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginAlphaView.mas_bottom).offset(self.sizeH(15));
        make.centerX.equalTo(self.view);
        make.height.equalTo(self.sizeH(35));
//        make.width.equalTo(self.sizeW(150));
    }];
    
}

//wxLogin
- (void)loginBtnClick {
    
}

- (void)backAction {
    if (self.vcFrom) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)codeLoginBtnAction {
    LoginByCodeController *vc = [[LoginByCodeController alloc]init];
    if (self.vcFrom) {
        vc.vcFrom = self.vcFrom;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
