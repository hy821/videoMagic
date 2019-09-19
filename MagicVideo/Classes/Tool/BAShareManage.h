
/*!
 *  @header BAKit.h
 *          BABaseProject
 *
 *  @brief  BAKit
 *
 *  @author 博爱
 *  @copyright    Copyright © 2016年 博爱. All rights reserved.
 *  @version    V1.0
 */
/*!
 
 最新更新时间：2016-12-06 【倒叙】
 最新Version：【Version：2.1 基于友盟 6.1.0 版本封装】
 更新内容：
 2.1.1、优化方法名命名规范
 2.1.2、优化 分享类型选择枚举，可以随意配置分享类型
 2.1.3、优化 全部软件安装判断方法
 2.1.4、新增友盟自带 UI 界面更清新！
 
 最新更新时间：2016-11-17 【倒叙】
 最新Version：【Version：2.0】
 更新内容：
     2.0.1、优化方法名命名规范
     2.0.2、新增 分享类型选择，可以单独选择分享类型
     2.0.3、新增 软件安装判断，如果没有安装就不显示
     2.0.4、新增 友盟登录封装，返回用户信息代理更详细
 */
#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

#define BASHAREMANAGER [BAShareManage ba_shareManage]

/*! 友盟分享 SDK：接入自己项目时需要更改各个属性值 */
#define BA_Umeng_Appkey        @"5926777e45297d310e001cb8"

#define BA_Sina_AppKey          @"4272630245"
#define BA_SinaAppSecret        @"7a6a8da01787ff90976fe309dad245a9"

#define BA_WX_APPKEY            @"wxd85d7af8199854ec"
#define BA_WX_APPSECRET     @"da7e501eb08edd08fe591f8cc6f406b8"

#define BA_QQKey                   @"3G122b5SYPF2jpAr"
#define BA_QQAppID                @"1101059892"

typedef NS_ENUM(NSUInteger, BAUM_SHARE_TYPE)
{
    /*! 纯文本 */
    BAUM_SHARE_TYPE_TEXT = 1,
    
    /*! 纯图片：本地图片 */
    BAUM_SHARE_TYPE_IMAGE,
    
    /*! 纯图片：网络图片 URL */
    BAUM_SHARE_TYPE_IMAGE_URL,
    
    /*! 网页：一般的分享是这种，title、content、缩略图、URL */
    BAUM_SHARE_TYPE_WEB_LINK,

    /*! 文本 + 图片 【暂时只对新浪分享有效】 */
    BAUM_SHARE_TYPE_TEXT_IMAGE,

    /*! 音乐 */
    BAUM_SHARE_TYPE_MUSIC_LINK,

    /*! 视频 */
    BAUM_SHARE_TYPE_VIDEO_LINK,

    /*! gif 动图【注：目前只有微信支持动图分享，其他平台均不支持】*/
    BAUM_SHARE_TYPE_GIF,

    /*! 文件【注：目前只有微信支持动图分享，其他平台均不支持】 */
    BAUM_SHARE_TYPE_FILE
};

/*! 登录后返回的数据回调 */
typedef void (^BAUMLoginCallback)(UMSocialUserInfoResponse *response);

@interface BAShareManage : NSObject

/*! 登录后返回的数据回调 */
@property (nonatomic, copy) BAUMLoginCallback loginCallback;

/*! 分享类型 */
@property (nonatomic, assign) BAUM_SHARE_TYPE shareType;

/*! 分享标题 */
@property (nonatomic, strong) NSString *shareTitle;
/*! 分享摘要 */
@property (nonatomic, strong) NSString *shareText;
/*! 分享缩略图【如果有缩略图，则设置缩略图 可为本地 imageName 或者 URL】 */
//@property (nonatomic, strong) NSString *shareThumbImage;
/*! 分享大图【本地 imageName】】 */
@property (nonatomic, strong) NSString *shareBigImage;
/*! hy----Add------分享大图【截图 imageName】】 */
@property (nonatomic, strong) UIImage *screenShotsImage;
/*! 分享 URL 图片 */
@property (nonatomic, strong) NSString *shareImageUrl;
/*! 分享网页 */
@property (nonatomic, strong) NSString *shareWebpageUrl;
/*! 分享音乐 URL【必传】 */
@property (nonatomic, strong) NSString *shareMusicUrl;
/*! 分享音乐 DataUrl */
@property (nonatomic, strong) NSString *shareMusicDataUrl;
/*! 分享视频 URL */
@property (nonatomic, strong) NSString *shareVideoUrl;
/*! 分享 gif 动图路径 */
@property (nonatomic, strong) NSString *shareGifFilePath;
/*! 分享文件路径 */
@property (nonatomic, strong) NSString *shareFileFilePath;
/*! 分享文件后缀类型 */
@property (nonatomic, strong) NSString *shareFileFileExtension;

/*! 授权回调 */
@property (nonatomic, strong) void (^authOpFinish)(void);

/*!
 *  友盟分享工具类封装
 *
 *  @return 返回：友盟分享工具类封装的实例
 */
+ (BAShareManage *)ba_shareManage;

/*!
 *  友盟分享设置
 */
- (void)ba_setupShareConfig;

/*!
 *  判断平台是否安装
 *
 *  @param platformType 平台类型 @see UMSocialPlatformType
 *
 *  @return YES 代表安装，NO 代表未安装
 *  @note 在判断QQ空间的App的时候，QQApi判断会出问题
 */
- (BOOL)ba_UMSocialIsInstall:(UMSocialPlatformType)platformType;

#pragma mark - 友盟分享 version 2.1
/*! 微信分享 */
#pragma mark 微信分享 version 2.1
- (void)ba_wechatShareWithShareType:(BAUM_SHARE_TYPE)shareType
                     viewController:(UIViewController *)viewController;

#pragma mark 微信朋友圈分享 version 2.1
- (void)ba_wechatTimeLineShareWithShareType:(BAUM_SHARE_TYPE)shareType
                             viewController:(UIViewController *)viewController;

//Add-------------
#pragma mark 微信分享 version 2.1
- (void)hy_wechatShareWithShareType:(BAUM_SHARE_TYPE)shareType
                     viewController:(UIViewController *)viewController;
//Add-------------
#pragma mark 微信朋友圈分享 version 2.1
- (void)hy_wechatTimeLineShareWithShareType:(BAUM_SHARE_TYPE)shareType
                             viewController:(UIViewController *)viewController;




#pragma mark 新浪微博分享 version 2.1
- (void)ba_sinaShareWithShareType:(BAUM_SHARE_TYPE)shareType
                   viewController:(UIViewController *)viewController;

#pragma mark qq分享 version 2.1
- (void)ba_qqShareWithShareType:(BAUM_SHARE_TYPE)shareType
                 viewController:(UIViewController *)viewController;

#pragma mark Qzone分享 version 2.1
- (void)ba_qZoneShareWithShareType:(BAUM_SHARE_TYPE)shareType
                    viewController:(UIViewController *)viewController;

#pragma mark - 博爱友盟分享列表 version 2.1
/*!
 *  博爱友盟分享列表 version 2.1
 *
 *  @param shareType      分享类型，具体看枚举
 *  @param viewController viewController
 */
- (void)ba_shareListWithShareType:(BAUM_SHARE_TYPE)shareType
                   viewController:(UIViewController *)viewController;

#pragma mark - 友盟登录
#pragma mark 微信登录 version 2.1
- (void)ba_wechatLoginWithViewController:(UIViewController *)viewController
                   isGetAuthWithUserInfo:(BOOL)isGetAuthWithUserInfo
                           loginCallback:(BAUMLoginCallback)loginCallback;

#pragma mark QQ登录 version 2.1
- (void)ba_qqLoginWithViewController:(UIViewController *)viewController
               isGetAuthWithUserInfo:(BOOL)isGetAuthWithUserInfo
                       loginCallback:(BAUMLoginCallback)loginCallback;

#pragma mark QQZone登录 version 2.1
- (void)ba_qZoneLoginWithViewController:(UIViewController *)viewController
                  isGetAuthWithUserInfo:(BOOL)isGetAuthWithUserInfo
                           loginCallback:(BAUMLoginCallback)loginCallback;

#pragma mark 微博登录 version 2.1
- (void)ba_sinaLoginWithViewController:(UIViewController *)viewController
                 isGetAuthWithUserInfo:(BOOL)isGetAuthWithUserInfo
                         loginCallback:(BAUMLoginCallback)loginCallback;

#pragma mark - 友盟登录列表 version 2.1
/*!
 *  友盟登录列表 version 2.1
 *
 *  @param viewController        viewController description
 *  @param isGetAuthWithUserInfo 
                YES:授权并获取用户信息(获取uid、access token及用户名等)
                NO：只需获取第三方平台token和uid，不获取用户名等用户信息，可以调用以下接口
 *  @param loginCallback         登录后返回的数据回调
 */
- (void)ba_loginListWithViewController:(UIViewController *)viewController
                 isGetAuthWithUserInfo:(BOOL)isGetAuthWithUserInfo
                         loginCallback:(BAUMLoginCallback)loginCallback;

#pragma mark - 清除授权
- (void)ba_cancelAuthWithPlatformType:(UMSocialPlatformType)platformType;

@end
