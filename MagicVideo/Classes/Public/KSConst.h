//
//  KSConst.h
//  KSMovie
//
//  Created by young He on 2018/9/11.
//  Copyright © 2018年 youngHe. All rights reserved.
//  存放常量

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SSNetState) {
    SSNetNormal_state = 0,//正常网络
    SSNetError_state,//网络错误
    SSNetLoading_state,//加载数据
};

typedef enum : NSUInteger {
    TZAssetCellTypePhoto = 0,
    TZAssetCellTypeLivePhoto,
    TZAssetCellTypePhotoGif,
    TZAssetCellTypeVideo,
    TZAssetCellTypeAudio,
} TZAssetCellType;

/** 首页: 推荐List的Cell类型 */
typedef enum : NSUInteger {
    RecomListCellType_Watch,
    RecomListCellType_OnLine,
    RecomListCellType_Hot,
    RecomListCellType_Top,
    RecomListCellType_PageTwins,  //左右滑动,每页两行4个,一共3页
    RecomListCellType_Twins,
    RecomListCellType_Adv
} RecomListCellType;

/** 首页: 非推荐List的Cell类型 */
typedef enum : NSUInteger {
    OtherListCellType_Constant,  //固定6个
    OtherListCellType_OneBigOneLine,
    OtherListCellType_OneBigTwoLine,
    OtherListCellType_Adv
} OtherListCellType;

typedef enum : NSUInteger {
    OtherHomeListType_Movie = 0,
    OtherHomeListType_TVSeries,  //电视剧
    OtherHomeListType_Anime,  //动漫
    OtherHomeListType_Variety, //综艺
    OtherHomeListType_Recom, //Add---推荐页, for AdvClickPercent
    OtherHomeListType_ShortVideo //Add---暂时用不到
} OtherHomeListType;

//视频类型 根据type字段判断
typedef enum : NSUInteger {
    VideoType_UnKnow = 0,  //未知,或者没复制
    VideoType_TV = 1,  //电视剧
    VideoType_Movie = 2,  //电影
    VideoType_Variety = 3, //综艺
    VideoType_Anime = 4, //动漫
    VideoType_Short = 5 //短视频
} VideoType;

typedef enum : NSUInteger {
    VideoTagType_Cash = 1,  //现金购买
    VideoTagType_Ticket = 2,  //影券兑换
    VideoTagType_Vip = 3,  //权益所得
    VideoTagType_Code = 4, //券码兑换
    VideoTagType_Operate = 5, //运营管控
    VideoTagType_Reward = 6 //奖励赠送
} VideoTagType;

typedef enum : NSUInteger {
    RecycleRedirectType_External, //跳外部
    RecycleRedirectType_Subject, //主题
    RecycleRedirectType_Video,
} RecycleRedirectType;

typedef enum : NSUInteger {
    PlayModeType_NONE = 0,
    PlayModeType_NORMAL = 1,
    PlayModeType_HIGH = 2,
    PlayModeType_MINI_HIGH = 3
} PlayModeType;

//自定义 视频播放类型
typedef enum : NSUInteger {
    VideoPlayType_NoSource = 1,  //被偷走
    VideoPlayType_WebViewPlay = 2,  //后台解析失败, 跳webView
    VideoPlayType_PlayUrlLong = 3,  // 自有源 直接播放
    VideoPlayType_PlayUrlAnalyse = 4,//后台解析成功, 返回的Url 直接播放
    VideoPlayType_PlayUrlShort = 5,  // 自有源 短视频直接播放
    VideoPlayType_PlayUrlAnalyseShort = 6, //XXX--->短视频后台解析成功, 返回的Url 直接播放
    VideoPlayType_SafariPlay = 7, // 跳Safari
    VideoPlayType_WebViewSearch = 8, // 跳webView搜索
    VideoPlayType_PlayUrlAnalyseLongVideo = 9, //长视频: 点击时, 去后台解析 用返回的Url 跳单独页面播放
    VideoPlayType_ShortVideoWkWebPlay = 10 //XXX--->短视频wkWebView播放
} VideoPlayType;

////缓存状态
//typedef enum : NSUInteger {
//    CacheStatusType_Wait,  //等待
//    CacheStatusType_Init,   //初始化
//    CacheStatusType_Downloading,  //缓存ing
//    CacheStatusType_Paused,    //已暂停
//    CacheStatusType_Merge,    //缓存合并中
//    CacheStatusType_Finished, //完成
//    CacheStatusType_Paused_NoNetWork,  //无网暂停
//    CacheStatusType_Paused_MobileNetWork, //流量暂停
//    CacheStatusType_Fail,  //失败
//} CacheStatusType;

//观看权限
typedef enum : NSUInteger {
    WatchRightsType_NORMAL,  //正常模式
    WatchRightsType_RIGHTS,   //权益模式 vip
    WatchRightsType_MONEYS,   //现金模式 zhifu
    WatchRightsType_TICKET,   //有券模式 quan
    WatchRightsType_PROMPT,   //提示模式 用券但是用户没有券
} WatchRightsType;

//观影券使用状态
typedef enum : NSUInteger {
    TicketStateType_EXPIRE,  //过期
    TicketStateType_ENABLE,  //可用
    TicketStateType_LOCKED,  //已用
} TicketStateType;

// VIDEOPAY_1("1","3元付费影片"),
// VIDEOPAY_2("2","6元付费影片"),
// VIDEOPAY_3("3","8元付费影片"),
// VIP_1("4","VIP_Annual"),//年卡
// VIP_2("5","VIP_Month"), //月卡
// VIP_3("6","VIP_Season");//季卡
typedef enum : NSUInteger {
    IAPShopType_VIDEOPAY_1,
    IAPShopType_VIDEOPAY_2,
    IAPShopType_VIDEOPAY_3,
    IAPShopType_VIP_1,
    IAPShopType_VIP_2,
    IAPShopType_VIP_3,
} IAPShopType;


//SW001   推荐热词，显示在输入框
//SW002  精选热词
typedef enum : NSUInteger {
    KeyWordType_Recom,  // 推荐热词，显示在输入框
    KeyWordType_Normal, //  精选热词
} KeyWordType;

//下载页面使用, 根据type显示提示语
typedef NS_ENUM(NSUInteger, NetWorkDownloadTipState) {
    NetWorkDownloadTipState_normal = 0, //正常网络
    NetWorkDownloadTipState_noNetwork = 1, //无网络
    NetWorkDownloadTipState_forbidDownloadWhenCellular = 2, //流量网络时禁止下载
};

//广告类型
typedef enum : NSUInteger {
    ADTypeNone = 0,  //未赋值
    ADTypeKS = 1,
    ADTypeGDT = 2,
    ADTypeBD = 3,
    ADTypeTT = 4
} ADType;

//视频广告类型
typedef enum : NSUInteger {
    AdvVideoTypeNone = 0, //未赋值
    AdvVideoTypeDraw = 1,  //沉浸式横屏视频广告
    AdvVideoTypeFeed = 2,  //信息流视频广告
    AdvVideoTypeFullScreen = 3, //全屏视频广告
    AdvVideoTypeReward = 4 //激励视频广告
} AdvVideoType;

@interface KSConst : NSObject

extern NSString * const USER_DATA;
extern NSString * const isAnonymous;
extern NSString * const isCK;
extern NSString * const isVIPUser;
extern NSString * const VIPExpireTime;
extern NSString * const MaxDownloadCount;
extern NSString * const DragShowAdvCount;
extern NSString * const USER_NickName;
extern NSString * const USER_ICON;
extern NSString * const USER_UserName;
extern NSString * const CREATE_Time;
extern NSString * const USER_ID;
extern NSString * const LastRequestDurTime;
extern NSString * const LocationLongitude; /** 定位---经度 */
extern NSString * const LocationLatitude;  /** 定位---纬度 */
extern NSString * const CREDENTIAL;  //证书,拼接token用
extern NSString * const HomeCategoryVer; //首页请求分类时传的版本
extern NSString * const HomeCategoryDic; //首页分类频道,字典,保存起来,在片库里取出转模型用
extern NSString * const CanSeeVideoNoWifi; //允许使用流量看视频
//--------->允许使用流量下载视频   LJDownloadAllowsCellularAccessKey
extern NSString * const FIRSTRegisterSuccess; //首次安装, 首次登录时, 没网, 记录是否注册成功


extern NSString * const MOBILE;    //手机号码,注意为了避免用户隐私泄露，用户id改成了uuid，用户phone另外新增了字段phone表示，请大家注意，这里的userid其实应该是手机号
extern NSString * const CODE; //验证码参数
extern NSString * const QD;//渠道
extern NSString * const TYPE;//验证码类型 1登录注册 3找回密码
extern NSString * const Code_Type;//0:语音 ,1:普通短信
extern NSString * const Nick_name;//用户昵称
extern NSString * const Sex;//性别（0：未知， 1： 男 ， 2：女）
extern NSString * const Avatar;//用户头像
extern NSString * const Birth;//用户出生年代（例：1980）
extern NSString * const City;//用户所在城市
extern NSString * const District;//用户所在的区
extern NSString * const Province;//用户所在省份
extern NSString * const Lon;//纬度,获取不到时传10000
extern NSString * const Lat;//纬度,获取不到时传10000
extern NSString * const RegistCode;//0表示带有注册信息，1表示跳过跳过时，用户昵称、头像、性别、出生年代传空
extern NSString * const Uid;//第三方登录获取的uid

/******************统一常用参数***************************/
extern NSString * const  Authorization; //token
extern NSString * const  Version;//版本号
extern NSString * const Device;//设备
extern NSString * const Timestamp;//时间戳 10位
extern NSString * const Sign;//参数签名
/******************统一常用参数***************************/
/******************其他常用参数***************************/
extern NSString * const Mobile;//手机号
extern NSString * const Type;//型号


/******************  通知Noti  ***************************/
extern NSString *const AnonymousSuccessNoti;  //注册成功,通知首页加载数据
extern NSString *const PageViewScrollNoti; //点击更多,跳转到对应pageView
extern NSString *const LOGIN_IN;
extern NSString *const LOGIN_OUT;
extern NSString *const RefreshUserMsgNoti;
extern NSString *const TabBarRefresh;
extern NSString *const IAPSuccessNoti;
extern NSString *const SEARCH_HotWord_Noti;  //搜索热词通知, 更新topSearchView的placeHolder
extern NSString *const LoginAndRefreshNoti;  //从某个页面进去了登录页面, 登录成功后, 通知进来的页面, 刷新
extern NSString * const FIRSTRegisterFailNoti; //首次注册失败, 通知首页显示按钮
extern NSString *const LoginAndGoVIPNoti;
extern NSString *const AdvCloseNoti;
extern NSString *const WithdrawSuccessNoti; //提现成功,通知各页面刷新

/******************  通知类型 是否开启对应通知  ***************************/
extern NSString *const NotiTypeAll;
extern NSString *const NotiTypeSystem;
extern NSString *const NotiTypeVideo;
extern NSString *const NotiTypeComment;
extern NSString *const NotiTypeLike;
extern NSString *const NotiTypeSignOrActivity;

@end
