//
//  Helper.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^FinishVideoBlock)(BOOL isFinish,NSError * error);
typedef void(^FinishBlock)(BOOL isFinish,NSError * error);
@interface Helper : NSObject

+(NSDictionary *)returnMD5WithDict:(NSDictionary *)parameters andURLstr:(NSString *)str andType:(NSInteger)type;

//字符串文字的长度
+(CGFloat)widthOfString:(NSString *)string font:(UIFont*)font height:(CGFloat)height;

//字符串文字的高度
+(CGFloat)heightOfString:(NSString *)string font:(UIFont*)font width:(CGFloat)width;
//字符串文字的label bounds
+(CGRect)boundsOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width;

//获取今天的日期：年月日
+ (NSDictionary *)getTodayDate;

//邮箱
+ (BOOL) justEmail:(NSString *)email;

//手机号码验证
+ (BOOL) justMobile:(NSString *)mobile;

//车牌号验证
+ (BOOL) justCarNo:(NSString *)carNo;

//车型
+ (BOOL) justCarType:(NSString *)CarType;

//用户名
+ (BOOL) justUserName:(NSString *)name;

//密码
+ (BOOL) justPassword:(NSString *)passWord;

//昵称
+ (BOOL) justNickname:(NSString *)nickname;

//身份证号
+ (BOOL) justIdentityCard: (NSString *)identityCard;
//获取时间差
+(NSString *) compareCurrentTime:(NSNumber*) compareDate;
//+(NSString *)returnUpTime:(NSNumber *)index;
+(NSString *) returnUploadTime:(NSString *)timeStr;
+(NSString *) returnAge:(NSString *)timeStr;
+(NSInteger)compareTime:(NSString *)timeStr;
//+(NSString *) returnTimeIsToday:(NSString *)timeStr;

//判断时间前后
+(NSString*)returnUpDate:(NSString* )time;
//计算文本高度
+(float) heightForString:(NSString *)value andWidth:(float)width;
//数字转换为中文
+(NSString *)translation:(NSString *)arebic;
//判断是否含有中文
+(BOOL)IsChinese:(NSString *)str;
//将当前时间转化为年月日格式
+(NSString *)changeDate:(NSDate *)date;
//date转换为string
+(NSString *)stringFromDate:(NSDate *)date;
//倒计时
+(NSString*)countDownTime:(NSString*)time;
//获得网上照片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL;
//图片URL地址默认使用
+(NSURL *)cleanChinese:(NSString *)str ;
//转换为特定时间段
+(NSString*)getSomeDay:(NSInteger)index;
//判断字段是否为NULL并返回相应的字符串
+(NSString*)classIsNSNull:(id)str;
//等比例长度及长度
+(CGFloat)returnUpHeight:(CGFloat)height;
+(CGFloat)returnUpWidth:(CGFloat)width;
//不同屏幕不同尺寸
+(UIFont*)returnUpFont:(CGFloat)screenWidth;
//nsnumber转换
+(NSString*)changeNsnumber:(NSNumber*)number;
//string->nsnumber
+(NSNumber*)changeString:(NSString*)str andIsAdd:(BOOL)isAdd;
//-->nsnumber判断是否
+(BOOL)tryToSwitchYesOrNo:(NSNumber*)number;
//判断字典是否存在键值
+(BOOL)isExist;
//是否为今天
+(NSString*)isToday:(NSString*)str;


/////
+ (NSString*)getDateTimeString;
+ (NSString*)randomStringWithLength:(int)len;
+(NSString*)getUploadName;
// 调整图片
/**
 *  调整图片尺寸和大小
 *
 *  @param sourceImage  原始图片
 *  @param maxImageSize 新图片最大尺寸
 *  @param maxSize      新图片最大存储大小
 *
 *  @return 新图片imageData
 */
+ (NSData *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize;
//判断类型属性
+(BOOL)isKindOfClass:(Class)Kind andFor:(id)respons;
//判断网络请求成功与否
+(BOOL)isSuccess:(NSDictionary*)dic;
//过滤html标签
+ (NSString *)flattenHTML:(NSString *)html;
//判断图片格式
+ (NSString *)typeForImageData:(NSData *)data;
//判断是否为动图
+(BOOL)isGitPhoto:(NSString*)url;
//数字切换
+(NSString*)numberForStr:(NSString*)number;
//是否用户打开了推送
+ (BOOL)isAllowedNotification;

////判断是否允许使用麦克风7.0新增的方法requestRecordPermission
//+(BOOL)canRecord;

//判断是否连续登录三天给予用户积分累加提示
+(BOOL)gotoStarForApp;
//GBK转码成utf8
+(NSString*)GBKString:(NSString*)html;
//0 无 1 秒拍 2 B站
+(NSInteger)isVideoForUrl:(NSString*)htmlString;

+(void)GET:(NSString *)URLString animated:(BOOL)animated parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//是否给APP点赞
+(BOOL)showStarForApp;
/**
 
 * 网址正则验证 1或者2使用哪个都可以
 
 *
 
 *  @param string 要验证的字符串
 
 *
 
 *  @return 返回值类型为BOOL
 
 */

+(BOOL)urlValidation:(NSString *)string;
//是否允许选择视频
+(BOOL)isAllowSelectVideo;
// 异步获取帧图片，可以一次获取多帧图片
+(void)centerFrameImageWithVideoURL:(NSURL *)videoURL completion:(void (^)(UIImage *image))completion;
//视频压缩
+(void)compressVideoWithVideoURL:(NSURL *)videoURL
                       savedName:(NSString *)savedName
                      completion:(void (^)(NSString *savedPath))completion;
//保存视频至系统相册
+(void)saveVideoWithVideoURL:(NSURL*)videoURL andFinishBlock:(FinishVideoBlock)finishBlock;

+(CGFloat)labelHeightWithStr:(NSString *)str andFont:(UIFont *)font andLineSpacing:(CGFloat) lineSpacing andLabelWidth:(CGFloat)labelWidth;

+(NSAttributedString *)attributedStringWithStr:(NSString *)str andFont:(UIFont *)font andColorStr:(NSString *)colorStr andLineSpacing:(CGFloat) lineSpacing;
+(NSString *)originImgUrlStr:(NSString *)str withSize:(CGFloat)size;
+ (BOOL)isIphoneX;
+(NSString*)originImageURL:(NSString*)str;
+(void)saveCloseNowDate;
+(BOOL)showNotiView;
/**
 * 保存图片或者动图
 *@param isGif  是否为动图的判断
 * @param data  id类型传 image或者data
 * @param complete 成功或者失败的回调
 */
+(void)saveImage:(id)data isGif:(BOOL)isGif complet:(FinishBlock)complete;

//获取sd的cache image
+(UIImage*)imageFromSdcache:(NSString*)url;

//+(BOOL)isHasWeChat;

//获取动图缩略图
+ (NSData *)zipGIFWithData:(NSData *)data;

/** 字典or数组转Json */
+ (NSString *)convertToJsonData:(id)dictOrArray;

/** 时间戳转日期 */
+ (NSString *)convertDateWithTime:(NSString *)time;

/** 时间戳转分钟*/
+ (NSString *)convertSecondWithTime:(NSString *)time;

/** 判断时间戳是否过期 */
+ (BOOL)isOverDueWithDate:(NSString *)timeStampString;

@end


