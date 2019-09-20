//
//  UserManager.h
//  NewTarget
//  Copyright © 2016年  rw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIDevice+FCUUID.h"

@interface UserManager : NSObject
/**
 *实例化用户管理器对象
 */
+(id)shareManager;

 //*  保存数据
- (void)saveUserDataWithDic:(NSDictionary *)dic;

// *  保存首页分类
- (void)saveHomeCategoryWithDic:(NSDictionary *)dic;

//用户头像UrlString
- (NSString *)getUserIcon;

//用户昵称
-(NSString *)getUserNickName;

//USER_UserName
-(NSString *)getUserName;

/*修改头像 修改昵称*/
-(void)reloadAvatar:(NSString *)imgUrl;

-(void)reloadNickName:(NSString *)name;

/**
 保存绑定手机
 */
-(void)saveMobileWith:(NSString*)str;
-(NSString*)mobile;
-(NSString *)userToken;

- (void)removeUserAllData;

@property (nonatomic,assign) BOOL isLogin;

/**是否是VIP*/
@property (nonatomic,assign) BOOL isVIPUser;

-(NSInteger)getMaxDownloadCount;
-(NSInteger)getDragShowAdvCount;

/**
 * 通过键获取值
 **/
-(id)dataStrForKey:(NSString*)key;

//-(void)gotoLogin;

/** 从某个vc去登录, 成功后返回这个vc*/
- (void)gotoLoginFromVC:(UIViewController *)vcFrom;

-(BOOL)isDevStatus;

//是否是CK
-(BOOL)isCK;

//服务器地址, 非登录类接口
-(NSString*)serverAddress;

//服务器地址, 登录类接口
-(NSString*)serverAddressWithLogin;

//非登录类 公钥
-(NSString*)publicKey;

//登录类 公钥
-(NSString*)publicKeyWithLogin;

//获取User-Agent
- (NSString *)getUserAgent;

//获取版本号
- (NSString *)getVersionStr;

//获取SIM Type   联调移动电信
- (NSString *)getSimType;

//获取网络环境
- (NSString *)getNetWorkType;

//获取证书--->拼接token用
- (NSString *)getCredential;

//UserID
- (NSString *)getUserID;

// (单位毫秒)  当前时间 + (上次请求开始请求时的时间 - 上次请求成功时的时间)
- (NSString *)getTimeForToken;

//获取dpi 屏幕密度
- (NSString*)getDpi;

//获取设备序列号
- (NSString*)getUUID;

//获取手机型号
- (NSString*)getDeviceName;

//应用发布渠道
- (NSString*)getAppPubChannel;

/** 短视频交互: 赞 踩 */
- (void)shortVideoInteractWithPar:(NSDictionary *)par success:(void (^)(id))success failure:(void (^)(NSString *))failure;

/** 视频收藏, 取消收藏 */
- (void)videoCollectionWithPar:(NSDictionary *)par andIsCollection:(BOOL)isCollection success:(void (^)(id))success failure:(void (^)(NSString *))failure;

//搜索历史-存储
-(void)searchHistorySaveWithWord:(NSString *)word;
//查找-删除-搜索历史
-(void)searchHistoryDeleteWithWord:(NSString *)receipt;
//获取存储的搜索历史
-(NSArray *)getSearchHistorySaveList;
//清空-搜索历史
-(void)searchHistoryDeleteAll;


//登录后, 获取热门搜索并保存
- (void)loadAndSaveHotSearchWord;
//获取保存的热搜词Model数组
- (NSArray *)getSavedHotSearchWordArray;
//获取保存的热搜词 占位热词
- (NSString *)getSavedHotSearchWordForPlaceHolder;

//观看历史-存储
-(void)watchHistorySaveWithWord:(NSString *)word;
//查找-删除-观看历史
-(void)watchHistoryDeleteWithWord:(NSString *)receipt;
//获取存储的观看历史
-(NSArray *)getWatchHistorySaveList;

- (NSString *)getLocationLongitude;
- (NSString *)getLocationLatitude;
- (NSString *)getIDFA;

//获取广告公共参数
-(NSDictionary*)getAdvParamDicWithPositionID:(NSString *)positionID slotWidth:(NSInteger)advWidth slotHeight:(NSInteger)advHeight;

//广告展示相关 回调
- (void)callBackAdvWithUrls:(NSArray *)urls;

//广告误点:   YES:今天点过了  NO:今天未点
- (BOOL)getAdvClickPercentWithAdvID:(NSString*)advID;

//判断 滑动进度条 是否 出广告
- (BOOL)isShowAdvWhenDragVideoWithVideoID:(NSString*)videoID;

//短视频(推荐页第一个 or 详情页)广告:   YES:今天展示过了  NO:今天未展示
- (BOOL)isShowShortVideoDayOnceAdvWithShortVideoID:(NSString*)svID;
//短视频当天展示过广告, 调用   点击跳过 or 倒计时完
- (void)showShortVideoDayOnceAdvSuccessWithShortVideoID:(NSString *)svID;

//分享模块弹框创建前, 根据判断显示弹框高度
- (NSInteger)getShareNumBeforeShowShareViewWithNotInterest:(BOOL)isInterest;

typedef NS_ENUM(NSUInteger, NotiType) {
    NotiType_All = 0,
    NotiType_System = 1,
    NotiType_Video = 2,
    NotiType_Comment = 3,
    NotiType_Like = 4,
    NotiType_SignOrActivity = 5
};

//消息通知开关状态
- (BOOL)getNotiStatusWithType:(NotiType)type;

//抽奖页面为H5请求后台数据成功后,数据callBack给H5
- (void)requestMsgForH5WithIsPost:(BOOL)isPost url:(NSString*)url params:(NSDictionary*)params success:(void (^)(id response))success failure:(void(^)(NSString* errMsg))failure;

/*通知推送 (未读消息数加减)
 *  点击推送 对应类型 -1
 *  返回总未读消息数, 根据这个设置BadgeNumber
 */
- (NSInteger)notiPushNumberWithType:(NotiType)type isAdd:(BOOL)isAdd;

//未读消息数, 某个类型的消息,   未读消息总数 type = NotiType_All
- (NSInteger)notiPushNumberWithType:(NotiType)type;

//登录, 退出登录, 清空未读消息数 某个未读消息类型
- (void)notiPushNumberClearWithType:(NotiType)type;

//设置App角标, MineTab角标, 个人中心我的消息角标
- (void)refreshAllBadge;

//播放失败时的上报
- (void)reportPlayFailLogWithProgramID:(NSString *)programID andVideoUrl:(NSString *)VideoUrl;

//每日弹框记录, 当天第一次启动请求弹框并记录
//YES:今天启动过了  NO:今天未启动
- (BOOL)haveShowDailyPopOut;

//IAP_支付失败报警
- (void)reportIAP_FailWithIapType:(NSString *)content;


//控制广告H5弹出后不会立即被点击返回
- (void)missControlForAdv;

@end
