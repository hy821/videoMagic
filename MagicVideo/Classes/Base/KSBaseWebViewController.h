//
//  KSBaseWebViewController.h
//  KSMovie
//
//  Created by young He on 2018/9/11.
//  Copyright © 2018年 youngHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
typedef NS_ENUM(NSUInteger, WebType) {
    NormalType       = 0,  //webview
    WKType             = 1,  //wkWebView
};

@interface KSBaseWebViewController : KSBaseViewController
@property (nonatomic, copy) NSString *bannerUrl;
@property (nonatomic,assign) WebType webType;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic,assign) BOOL isNavBarHidden;
@property (nonatomic,assign) BOOL isHaveInteration;  //有交互
@end

@interface WeakScriptMessageDelegate : NSObject<WKScriptMessageHandler>
@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
@end
