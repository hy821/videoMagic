//
//  KSBaseWebViewController.m
//  KSMovie
//
//  Created by young He on 2018/9/11.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import "KSBaseWebViewController.h"
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"

@interface KSBaseWebViewController ()
<UIWebViewDelegate,
WKNavigationDelegate,
WKUIDelegate,
UIGestureRecognizerDelegate,
WKScriptMessageHandler>
@property (nonatomic,weak) YHWebViewProgressView * progressView;
@property (strong, nonatomic) YHWebViewProgress *progressProxy;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *closeItem;
@property (nonatomic,strong) WKWebView * wkWeb;
@property (nonatomic,strong) UIButton * backBtn;
@property (nonatomic,strong) UIButton * closeBtn;
@property (nonatomic,weak) WKWebViewConfiguration * wkConfig;
@property (nonatomic,strong) UIView * showErrorView;
@property (nonatomic,strong) UIImageView * errorIV;
@property (nonatomic,strong) UILabel * errorLab;
@property (nonatomic,assign) BOOL isFirstAppear;

@end

@implementation KSBaseWebViewController

//打开QQ, 加入QQ群
static NSString *JoinQQGroup = @"joinQQGroupByH5";
//抽奖页 加载时拿数据
static NSString *LotteryGetUserMsg = @"requestDataByApp";
//抽奖页加载完毕时
static NSString *AppPageLoadFinish = @"AppPageFinished()";
//抽奖页 做任务赚金币  提现  抽完奖 拿数据
static NSString *LotteryOpenPage = @"openAppPageByType";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webType = WKType;
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if(self.bannerUrl == nil) {
        self.bannerUrl = @"";
    }
//    else if ([self.bannerUrl containsString:LotteryH5_Url]) {
//        [self setNavButtonImageName:@"vipQA" andIsLeft:NO andTarget:self andAction:@selector(goRuleVC)];
//    }
    
    if(self.isNavBarHidden) {
        self.closeBtn.hidden = YES;
        [self.view bringSubviewToFront:self.closeBtn];
        // register for orientation changes
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrame:)
                                                     name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    }
    [self createUI];
    [self resolveURL];
    if (self.titleStr) {
        self.title = _titleStr;
    }
    self.navigationItem.leftBarButtonItem = self.backItem;
    self.fd_prefersNavigationBarHidden = self.isNavBarHidden;
}

- (void)willChangeStatusBarFrame:(NSNotification*)notification {
    CGRect newBarFrame = [notification.userInfo[UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
    if([self.wkWeb canGoBack]&&self.isNavBarHidden){
        [self.wkWeb mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).offset(UIEdgeInsetsMake([self contentOffset], 0, 0, 0));
        }];
    }else{
        if(self.isNavBarHidden){
            [self.wkWeb mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).offset(UIEdgeInsetsMake(newBarFrame.size.height , 0, 0, 0));
            }];
        }
    }
}

- (void)createUI {
    if(self.webType == NormalType) {
        [self.view addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.view);
        }];
    }else {
        [self.view addSubview:self.wkWeb];
        [self.wkWeb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset([self contentOffset]);
        }];
    }

    [self.view addSubview:self.showErrorView];
    self.showErrorView.hidden = YES;
    self.showErrorView.backgroundColor = [UIColor whiteColor];
    [self.showErrorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    // 创建进度条代理，用于处理进度控制
    _progressProxy = [[YHWebViewProgress alloc] init];
    // 创建进度条
    YHWebViewProgressView *progressView = [[YHWebViewProgressView alloc] initWithFrame:CGRectMake(0, self.isNavBarHidden?[UIApplication sharedApplication].statusBarFrame.size.height :[self contentOffset],ScreenWidth, 3.f)];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    // 添加到视图
    [self.view addSubview:progressView];
    self.progressView = progressView;
    [self.view bringSubviewToFront:_progressView];
    if(self.isNavBarHidden)
    {
        [self.view bringSubviewToFront:self.closeBtn];
        [self.view bringSubviewToFront:self.backBtn];
    }
}

-(void)resolveURL
{
    [self.wkWeb addObserver:self
                 forKeyPath:@"loading"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    
    [self.wkWeb addObserver:self
                 forKeyPath:@"title"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    
    [self.wkWeb addObserver:self
                 forKeyPath:@"estimatedProgress"
                    options:NSKeyValueObservingOptionNew
                    context:nil];
    
    //Cookie
    NSURL *url = [NSURL URLWithString:_bannerUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
     [self.wkWeb loadRequest:request];
}

#pragma mark--KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"loading"])
    {
        //         self.navigationItem.title = @"加载中...";
        
    } else if ([keyPath isEqualToString:@"title"])
    {
        self.navigationItem.title = self.wkWeb.title;
    } else if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        [self.progressView setProgress:[change[@"new"] doubleValue] animated:YES];
        
    }
}

/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!self.isFirstAppear)
    {
        return;
    }
    if([self.wkWeb canGoBack]&&self.isNavBarHidden&&(self.navigationController.isNavigationBarHidden))
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([self.wkWeb canGoBack]&&self.isNavBarHidden)
    {
        
        self.wkWeb.mj_y = [self contentOffset];
    }else
    {
        if(self.isNavBarHidden)
        {
            if(!self.isFirstAppear)
            {
                self.isFirstAppear = YES;
                return;
            }
            self.wkWeb.mj_y = [UIApplication sharedApplication].statusBarFrame.size.height;
            self.backBtn.mj_y = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
    }
}
- (void)updateButtonItems
{
    
    if ([self.wkWeb canGoBack]&&self.navigationItem.leftBarButtonItems.count!=2) {
        self.navigationItem.leftBarButtonItems = @[self.backItem];
        //, self.closeItem
        if(self.isNavBarHidden)
        {
            self.progressView.mj_y = [self contentOffset];
            [self.view bringSubviewToFront:self.progressView];
            self.wkWeb.mj_y = [self contentOffset];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            self.closeBtn.hidden = NO;
            self.fd_interactivePopDisabled = YES;
        }
    } else  if ([self.wkWeb canGoBack]&&self.navigationItem.leftBarButtonItems.count==2)
    {
        if(self.isNavBarHidden)
        {
            self.progressView.mj_y = [self contentOffset];
            [self.view bringSubviewToFront:self.progressView];
            self.wkWeb.mj_y = [self contentOffset];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            self.closeBtn.hidden = NO;
            self.fd_interactivePopDisabled = YES;
        }
    }
    else
    {
        
        self.navigationItem.leftBarButtonItems = @[self.backItem];
        if(self.isNavBarHidden)
        {
            self.fd_interactivePopDisabled = NO;
            self.closeBtn.hidden = YES;
            self.progressView.mj_y = [UIApplication sharedApplication].statusBarFrame.size.height ;
            [self.view bringSubviewToFront:self.progressView];
            self.wkWeb.mj_y = [UIApplication sharedApplication].statusBarFrame.size.height;
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
    if(self.isNavBarHidden){
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

-(UIButton *)backBtn {
    if(!_backBtn) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 44, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backBtn = button;
    }return _backBtn;
}

-(UIButton *)closeBtn {
    if(!_closeBtn) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(64, 20, 44, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn = button;
    }return _closeBtn;
}

- (UIBarButtonItem *)backItem {
    if (!_backItem) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:KCOLOR(@"#333333") forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }return _backItem;
}


- (UIBarButtonItem *)closeItem {
    if (!_closeItem) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button setTitleColor:KCOLOR(@"#333333") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
        _closeItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }return _closeItem;
}

#pragma mark - Action
- (void)backAction {
    if ([self.wkWeb canGoBack]) {
        [self.wkWeb goBack];
    } else {
        [self closeSelf];
    }
}

-(UIView *)showErrorView {
    if(_showErrorView == nil) {
        _showErrorView = [[UIView alloc]init];
        [_showErrorView addSubview:self.errorIV];
        [_showErrorView addSubview:self.errorLab];
        [self.errorIV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.showErrorView.center);
        }];
        [self.errorLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.errorIV.mas_bottom).offset(16);
            make.height.mas_equalTo(20.f);
            make.left.right.equalTo(self.showErrorView);
        }];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadTap)];
        [_showErrorView addGestureRecognizer:tap];
    }
    return _showErrorView;
}

-(void)reloadTap {
    self.showErrorView.hidden = YES;
    [self.view bringSubviewToFront:self.progressView];
    [self.wkWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_bannerUrl]]];
}

- (UIImageView *)errorIV {
    if(_errorIV == nil) {
        _errorIV = [[UIImageView alloc]initWithImage:Image_Named(@"netError")];
        _errorIV.userInteractionEnabled = YES;
    }return _errorIV;
}

-(UILabel *)errorLab {
    if(_errorLab == nil){
        _errorLab = [[UILabel alloc]init];
        _errorLab.font = Font_Size(16);
        _errorLab.textAlignment = NSTextAlignmentCenter;
        _errorLab.textColor = DarkGray_Color;
        _errorLab.text = @"加载失败, 请点击重试";
    }return _errorLab;
}

-(void)dealloc {
    SSLog(@"%s",__func__);
    [_wkWeb removeObserver:self forKeyPath:@"loading" context:nil];//移除kvo
    [_wkWeb removeObserver:self forKeyPath:@"title" context:nil];
    [_wkWeb removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
 
    if(self.isHaveInteration) {
        [self.wkConfig.userContentController removeScriptMessageHandlerForName:JoinQQGroup];
        [self.wkConfig.userContentController removeScriptMessageHandlerForName:LotteryGetUserMsg];
        [self.wkConfig.userContentController removeScriptMessageHandlerForName:LotteryOpenPage];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark-- wkWebViewDelegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if(!self.showErrorView.isHidden) {
        self.showErrorView.hidden = YES;
    }
    if (self.isHaveInteration) {
        [webView evaluateJavaScript:AppPageLoadFinish completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            SSLog(@"%@ %@",response,error);
        }];
    }
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if(self.showErrorView.isHidden) {
        self.showErrorView.hidden = NO;
        [self.view bringSubviewToFront:self.showErrorView];
        [self.view bringSubviewToFront:self.progressView];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    if(!self.showErrorView.isHidden) {
        self.showErrorView.hidden = YES;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(!self.showErrorView.isHidden) {
        self.showErrorView.hidden = YES;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if(self.showErrorView.isHidden) {
        self.showErrorView.hidden = NO;
        [self.view bringSubviewToFront:self.showErrorView];
        [self.view bringSubviewToFront:self.progressView];
    }
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:JoinQQGroup])
    {
      
    }else if ([message.name isEqualToString:LotteryGetUserMsg]) {
        
    }else if ([message.name isEqualToString:LotteryOpenPage]) {
        
        NSString *type = message.body;
        if ([type isEqualToString:@"signtask"]) {  //做任务赚金币
            
        }else if ([type isEqualToString:@"myRedPacket"]) {  //提现
            
        }else if ([type isEqualToString:@"GoQQWebView"]) {  //联系我们页面 点击加入QQ群
            
        }
        
    }
}

- (void)closeSelf {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.opaque = NO;
        _webView.scalesPageToFit = YES;
        _webView.autoresizesSubviews = NO;
        _webView.backgroundColor = White_Color;
    }return _webView;
}

-(WKWebView *)wkWeb {
    if(_wkWeb == nil) {
        NSDictionary *dic = @{@"ks_http_userName":[USER_MANAGER getUserName],
                              @"ks_http_ostype" : @"ios",
                              @"ks_http_prod" : @"ks8"
                              };
        // 将所有cookie以document.cookie = 'key=value';形式进行拼接
        NSMutableString *cookie = @"".mutableCopy;
        
        if (dic) {
            for (NSString *key in dic.allKeys) {
                [cookie appendFormat:@"document.cookie = '%@=%@';\n",key,dic[key]];
            }
        }
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookie injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [userContentController addUserScript:cookieScript];
        
        WKWebViewConfiguration* webViewConfig = [[WKWebViewConfiguration alloc]init];
        webViewConfig.userContentController = userContentController;
        webViewConfig.processPool = [[WKProcessPool alloc] init];
        webViewConfig.userContentController = userContentController;
        webViewConfig.allowsInlineMediaPlayback = YES;
        self.wkConfig = webViewConfig;
        
        _wkWeb = [[WKWebView alloc]initWithFrame:CGRectZero configuration:self.wkConfig];
        _wkWeb.UIDelegate = self;
        _wkWeb.navigationDelegate = self;
        //开启手势触摸
        [_wkWeb.scrollView setAlwaysBounceVertical:YES];
        // 这行代码可以是侧滑返回webView的上一级，而不是根控制器（*只针对侧滑有效）
        [_wkWeb setAllowsBackForwardNavigationGestures:true];
        _wkWeb.backgroundColor = [UIColor whiteColor];
     
        if(self.isHaveInteration){  //有交互
            [self.wkConfig.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:JoinQQGroup];
            [self.wkConfig.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:LotteryGetUserMsg];
            [self.wkConfig.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:LotteryOpenPage];
        }
    }return _wkWeb;
}

@end


@implementation WeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}
-(void)dealloc
{
    SSLog(@"%s",__func__);
}
@end
