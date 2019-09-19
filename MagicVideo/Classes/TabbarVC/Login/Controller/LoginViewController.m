//
//  LoginViewController.m
//  MagicVideo
//
//  Created by young He on 2019/9/18.
//  Copyright © 2019年 youngHe. All rights reserved.
//

#import "LoginViewController.h"
#import "KSBaseWebViewController.h"
#import "UILabel+Category.h"
#import "UIButton+Category.h"
#import "LoginTextField.h"
#import "LoginAlphaBtn.h"
#import "WXApi.h"

@interface LoginViewController()<WXApiDelegate>

@property (nonatomic,weak) LoginTextField *phoneTF;
@property (nonatomic,weak) LoginTextField *codeTF;

@property (nonatomic,weak) LoginAlphaBtn *codeLoginBtn;
@property (nonatomic,weak) LoginAlphaBtn *wxLoginBtn;

@property (nonatomic,weak) UIButton *readBtn; //用户需知
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
    
    LoginTextField *phoneTF = [[LoginTextField alloc]initWithPlaceholder:@"请输入手机号" andStyle:Normal_Type];
    WS()
    phoneTF.textChangeBlock = ^(NSString *text) {
        weakSelf.codeTF.mobileText = text;
    };
    [self.view addSubview:phoneTF];
    self.phoneTF = phoneTF;
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoTextIV.mas_bottom).offset(self.sizeH(65));
        make.centerX.equalTo(self.view);
        make.width.equalTo(ScreenWidth*4/5);
        make.height.equalTo(self.sizeH(LoginAlphaBtnHeight));
    }];
    
    LoginTextField *codeTF = [[LoginTextField alloc]initWithPlaceholder:@"请输入验证码" andStyle:GetCode_type];
    
    codeTF.codeType = 2;
    [self.view addSubview:codeTF];
    self.codeTF = codeTF;
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTF.mas_bottom).offset(self.sizeH(20));
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(self.phoneTF);
    }];
    
    LoginAlphaBtn *codeLoginBtn = [[LoginAlphaBtn alloc]initWithTitle:@"短信登录" andBtnImage:Image_Named(@"") andTarget:self andAction:@selector(codeLoginBtnAction)];
    [self.view addSubview:codeLoginBtn];
    self.codeLoginBtn = codeLoginBtn;
    [self.codeLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTF.mas_bottom).offset(self.sizeH(20));
        make.centerX.equalTo(self.view);
        make.width.equalTo(ScreenWidth*4/5);
        make.height.equalTo(self.sizeH(LoginAlphaBtnHeight));
    }];
    
    LoginAlphaBtn *wxLoginBtn = [[LoginAlphaBtn alloc]initWithTitle:@"微信登录" andBtnImage:Image_Named(@"loginWXLogo") andTarget:self andAction:@selector(wxLoginBtnAction)];
    [self.view addSubview:wxLoginBtn];
    self.wxLoginBtn = wxLoginBtn;
    [self.wxLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeLoginBtn.mas_bottom).offset(self.sizeH(20));
        make.centerX.equalTo(self.view);
        make.width.equalTo(ScreenWidth*4/5);
        make.height.equalTo(self.sizeH(LoginAlphaBtnHeight));
    }];
   
    self.wxLoginBtn.hidden = ![WXApi isWXAppInstalled];
    
    UIButton * readBtn = [UIButton buttonWithTitle:@"《神奇视频注册协议》,《神奇视频隐私政策》" titleColor:White_Color bgColor:Clear_Color highlightedColor:White_Color];
    [readBtn.titleLabel setFont:Font_Size(12)];
    [readBtn addTarget:self action:@selector(protocolToWebViewAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:readBtn];
    self.readBtn = readBtn;
    [self.readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(self.sizeH(-62));
        make.centerX.equalTo(self.view);
    }];
    UILabel *labRead = [UILabel labelWithTitle:@"点击获取验证码即同意" font:12 textColor:White_Color textAlignment:1];
    [self.view addSubview:labRead];
    [labRead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.readBtn.mas_top).offset(self.sizeH(-3));
        make.centerX.equalTo(self.view);
    }];
    
}

- (void)protocolToWebViewAction {
    KSBaseWebViewController * web  = [[KSBaseWebViewController alloc]init];
    web.webType = WKType;
    web.bannerUrl = @"https://www.baidu.com";
//    web.bannerUrl = [USER_MANAGER isPrdServer]?  UserProtocol_H5_Url_PRD: UserProtocol_H5_Url;
    [self.navigationController pushViewController:web animated:YES];
}

//wxLogin
- (void)wxLoginBtnAction {
    SSMBToast(@"微信登录", MainWindow);
    
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
//    req.state = @"";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp {
    SSMBToast(@"微信登录Test", MainWindow);
}

//codeLogin
- (void)codeLoginBtnAction {
    if(self.phoneTF.text.length !=11 ) {
        SSMBToast(@"请填写正确的手机号", MainWindow);
        return;
    }
    if(self.codeTF.text.length == 0) {
        SSMBToast(@"请输入验证码", MainWindow);
        return;
    }
    
    SSGifShow(MainWindow, @"加载中");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SSDissMissAllGifHud(MainWindow, YES);
        SSMBToast(@"登录成功", MainWindow);
        
        if (self.vcFrom) {
            [NOTIFICATION postNotificationName:LoginAndRefreshNoti object:nil];
            [self.navigationController popToViewController:self.vcFrom animated:YES];
        }else {
            KSTabBarController * tabBar = [[KSTabBarController alloc]init];
            [g_App restoreRootViewController:tabBar];
        }
    });
    
//    SSGifShow(MainWindow, @"加载中");
//    NSDictionary *dic = @{@"mobile" : self.phoneTF.text,
//                          @"code": self.codeTF.text
//                          };
//    [[SSRequest request] POSTAboutLogin:Login_MsgCodeUrl parameters:[dic mutableCopy] success:^(SSRequest *request, NSDictionary *response) {
//        SSDissMissAllGifHud(MainWindow, YES);
//        SSMBToast(@"登录成功", MainWindow);
//        [[UserManager shareManager] saveUserDataWithDic:response[@"data"]];
//
//        if (self.vcFrom) {
//            [NOTIFICATION postNotificationName:LoginAndRefreshNoti object:nil];
//            if (self.isLoginToVIP) {
//                [NOTIFICATION postNotificationName:LoginAndGoVIPNoti object:nil];
//            }
//            [self.navigationController popToViewController:self.vcFrom animated:YES];
//        }else {
//            KSTabBarController * tabBar = [[KSTabBarController alloc]init];
//            [g_App restoreRootViewController:tabBar];
//        }
//
//    } failure:^(SSRequest *request, NSString *errorMsg) {
//        SSDissMissAllGifHud(MainWindow, YES);
//        SSMBToast(errorMsg, MainWindow);
//
//    }];
    
    
}

- (void)backAction {
    if (self.vcFrom) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
