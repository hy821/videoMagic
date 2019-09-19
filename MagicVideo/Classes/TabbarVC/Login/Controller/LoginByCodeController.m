//
//  LoginByCodeController.m
//  MagicVideo
//
//  Created by young He on 2019/9/18.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "LoginByCodeController.h"

#import "UILabel+Category.h"
#import "UIButton+Category.h"

@interface LoginByCodeController ()

@property (nonatomic,weak) UIButton *loginBtn;

@end

@implementation LoginByCodeController

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
    loginAlphaView.layer.borderColor = KCOLOR(@"#ffffff").CGColor;
    loginAlphaView.layer.borderWidth = 1.2;
    [self.view addSubview:loginAlphaView];
    [loginAlphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoTextIV.mas_bottom).offset(self.sizeH(100));
        make.centerX.equalTo(self.view);
        make.width.equalTo(ScreenWidth*4/5);
        make.height.equalTo(self.sizeH(45));
    }];
    UIButton * loginBtn = [UIButton buttonWithTitle:@"验证" titleColor:KCOLOR(@"#ffffff") image:Image_Named(@"loginWXLogo") font:18];
    [loginBtn setBackgroundColor:Clear_Color forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:Clear_Color forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [loginAlphaView addSubview:loginBtn];
    self.loginBtn = loginBtn;
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(loginAlphaView);
    }];
  
}

- (void)loginBtnClick {
    if (self.vcFrom) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
