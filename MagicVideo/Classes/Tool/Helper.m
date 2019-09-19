//
//  Helper.m
//

#import "Helper.h"
#import "Tool.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AFNetworking.h>
#import "TZImageManager.h"
#import <SDWebImageManager.h>
#import <CoreGraphics/CoreGraphics.h>
#import "UIImage+ZipSizeAndLength.h"

//忽略编译器的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
//时间key  数量key
#define DAY_KEY @"day"
#define NUM_KEY @"number_day"
//star key
#define STAR_KEY @"star_app"
#define Phote_name @"娱乐猫视频"
//保存视频
static NSURL * _videoUrl;
static FinishVideoBlock _block;
@implementation Helper
+(NSDictionary *)returnMD5WithDict:(NSDictionary *)parameters andURLstr:(NSString *)str andType:(NSInteger)type{
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDate *endDat = [NSDate dateWithTimeIntervalSinceNow:180];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSTimeInterval b = [endDat timeIntervalSince1970];
    NSInteger startTime = round(a);
    NSInteger endTime = round(b);
    NSString * version = @"4";
    
    
    NSString *md5MM = [Tool md5:[NSString stringWithFormat:@"%d%d%@%@",startTime,endTime,@"B710C1B000EC2AB929AD25D19226919B",version]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:parameters];
    [dict setValue:[NSString stringWithFormat:@"%d",(int)startTime] forKey:@"starttime"];
    [dict setValue:[NSString stringWithFormat:@"%d",(int)endTime]forKey:@"endtime"];
    [dict setValue:version forKey:@"version"];
    [dict setValue:md5MM forKey:@"md5str"];
    
    
    
    NSMutableString * urlString=[[NSMutableString alloc]init];
    for(NSString * keys in parameters)
    {
        [urlString appendFormat:@"&%@=%@",keys,[parameters objectForKey:keys]];
    }
    if (type == 1) {
        NSLog(@"GET:%@%@?starttime=%d&endtime=%d&version=%@&md5str=%@",str,urlString,startTime,endTime,version,md5MM);
    }else{
        NSLog(@"POST:%@%@?starttime=%d&endtime=%d&version=%@&md5str=%@",str,urlString,startTime,endTime,version,md5MM);
    }
   
    return [dict copy];
}


+(CGFloat)widthOfString:(NSString *)string font:(UIFont *)font height:(CGFloat)height
{
    NSDictionary * dict=[NSDictionary dictionaryWithObject: font forKey:NSFontAttributeName];
    CGRect rect=[string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width;
}

+(CGFloat)heightOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width
{
    CGRect bounds;
    NSDictionary * parameterDict=[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    bounds=[string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:parameterDict context:nil];
    CGRect newBounds;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>8.0){
        newBounds=bounds;
    }else{
        newBounds=bounds;
        newBounds.size.height=bounds.size.height+10;
    }
    return newBounds.size.height;
}

+(CGRect)boundsOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width
{
    CGRect bounds;
    NSDictionary * parameterDict=[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    bounds=[string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:parameterDict context:nil];
    CGRect newBounds;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>8.0){
        newBounds=bounds;
    }else{
        newBounds=bounds;
        newBounds.size.height=bounds.size.height+10;
    }
    return newBounds;
}





#pragma  mark - 获取当天的日期：年月日
+ (NSDictionary *)getTodayDate
{
    
    //获取今天的日期
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay;
    
    NSDateComponents *components = [calendar components:unit fromDate:today];
    NSString *year = [NSString stringWithFormat:@"%ld", [components year]];
    NSString *month = [NSString stringWithFormat:@"%02ld", [components month]];
    NSString *day = [NSString stringWithFormat:@"%02ld", [components day]];
    
    NSMutableDictionary *todayDic = [[NSMutableDictionary alloc] init];
    [todayDic setObject:year forKey:@"year"];
    [todayDic setObject:month forKey:@"month"];
    [todayDic setObject:day forKey:@"day"];
    
    return todayDic;
    
}
//邮箱
+ (BOOL) justEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//手机号码验证
+ (BOOL) justMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (mobile.length != 11)
        {
            return NO;
        }else{
            return YES;
            
//            /**
//             * 移动号段正则表达式
//             */
//            NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
//            /**
//             * 联通号段正则表达式
//             */
//            NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
//            /**
//             * 电信号段正则表达式
//             */
//            NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
//            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
//            BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
//            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
//            BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
//            NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
//            BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
//            
//            if (isMatch1 || isMatch2 || isMatch3) {
//                return YES;
//            }else{
//                return NO;
//            }
        }
}


//车牌号验证
+ (BOOL) justCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}


//车型
+ (BOOL) justCarType:(NSString *)CarType
{
    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];
    return [carTest evaluateWithObject:CarType];
}


//用户名
+ (BOOL) justUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}


//密码
+ (BOOL) justPassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}


//昵称
+ (BOOL) justNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}


//身份证号
+ (BOOL) justIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+(NSString *) compareCurrentTime:(NSNumber*) compareDate
{
    NSDate * date=[NSDate date];
    NSTimeInterval  timeInterval1 = [date timeIntervalSince1970];
    timeInterval1 = -timeInterval1;
    NSInteger timeInterval2=[compareDate integerValue];
    NSInteger timeInterval=timeInterval1-timeInterval2;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

+(NSString *) returnUploadTime:(NSString *)timeStr {
    return [Helper findendliyTime:timeStr];
}


+(NSInteger)compareTime:(NSString *)timeStr{
    //创建一种时间格式
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //将字符串格式化
    NSDate *d=[date dateFromString:timeStr];
    //返回以1970/01/01 GMT为基准，然后过了secs秒的时间
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    //返回以当前时间为基准，然后过了secs秒的时间
    NSDate* dat = [NSDate date];
    //获取到了当前时刻距离GMT基准的总秒数
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    //    NSString *timeString=@"";
    //得到时间差
    NSTimeInterval cha=late-now;
    
    if (cha/86400>=1)
    {
        return 1;
    }else if(cha/86400<1&&cha/86400>=0){
        return 0;
    }else{
        return -1;
    }
    
}


//+(NSString *) returnTimeIsToday:(NSString *)timeStr
//{
//    //创建一种时间格式
//    NSDateFormatter *date=[[NSDateFormatter alloc] init];
//    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    //将字符串格式化
//    NSDate *d=[date dateFromString:timeStr];
//    //返回以1970/01/01 GMT为基准，然后过了secs秒的时间
//    NSTimeInterval late=[d timeIntervalSince1970]*1;
//    //返回以当前时间为基准，然后过了secs秒的时间
//    NSDate* dat = [NSDate date];
//    //获取到了当前时刻距离GMT基准的总秒数
//    NSTimeInterval now=[dat timeIntervalSince1970]*1;
////    NSString *timeString=@"";
//    //得到时间差
//    NSTimeInterval cha=now-late;
//    
//    //时间差在一个小时到一天时的显示格式
//    if (cha/86400<1)
//    {
//        return @"1";
//    }else{
//        return @"0";
//    }
//    
//}

+(NSString *) returnAge:(NSString *)timeStr
{
    //创建一种时间格式
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //将字符串格式化
    NSDate *d=[date dateFromString:timeStr];
    //返回以1970/01/01 GMT为基准，然后过了secs秒的时间
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    //返回以当前时间为基准，然后过了secs秒的时间
    NSDate* dat = [NSDate date];
    //获取到了当前时刻距离GMT基准的总秒数
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    //得到时间差
    NSTimeInterval cha=now-late;
    
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%d",(int)cha/86400/365];
    }
    return timeString;
}



+(NSString*)countDownTime:(NSString*)time
{
    //创建一种时间格式
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //将字符串格式化
    NSDate *d=[date dateFromString:time];
    //返回以1970/01/01 GMT为基准，然后过了secs秒的时间
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    //返回以当前时间为基准，然后过了secs秒的时间
    NSDate* dat = [NSDate date];
    //获取到了当前时刻距离GMT基准的总秒数
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    //得到时间差
    NSTimeInterval cha1=late-now;

    if (cha1/3600<1)
    {
        if (cha1/60<1) {
            timeString = @"";
        }else{
            timeString = [NSString stringWithFormat:@"0天0时%d分", (int)cha1/60];
        }
        
    }
    //时间差在一个小时到一天时的显示格式
    if (cha1/3600>1&&cha1/86400<1)
    {
        
        timeString = [NSString stringWithFormat:@"0天%d小时%d分",(int)cha1/3600,((int)cha1%3600)/60];
    }
    //时间差大于一天时的显示格式
    if (cha1/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%d天%d小时%d分",(int)cha1/86400,((int)cha1%86400)/3600,((int)cha1%3600)/60];
    }
    return timeString;
}
//POST请求
-(void)startRequestWithPOST:(NSString *)url parameter:(NSDictionary *)parameter{
        
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url]];
        
        [request setHTTPMethod:@"POST"];
        
        
        //解析请求参数，用NSDictionary来存参数，通过自定义的函数parseParams把它解析成一个post格式的字符串
        NSString *parseParamsResult = [self parseParams:parameter];
        
        NSData *postData = [parseParamsResult dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        
       // _connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        
        
    }
    
    //把NSDictionary解析成post格式的NSString字符串
    - (NSString *)parseParams:(NSDictionary *)params{
        NSString *keyValueFormat;
        NSMutableString *result = [NSMutableString new];
        //    //实例化一个key枚举器用来存放dictionary的key
        //    NSEnumerator *keyEnum = [params keyEnumerator];
        //    id key;
        //    while (key = [keyEnum nextObject]) {
        //        keyValueFormat = [NSString stringWithFormat:@"%@=%@&",key,[params valueForKey:key]];
        //        [result appendString:keyValueFormat];
        //        NSLog(@"post()方法参数解析结果：%@",result);
        //    }
        //
        NSArray * allkey = [params allKeys];
        NSArray * allValue = [params allValues];
        
        for (int i=0; i<allkey.count; i++) {
            keyValueFormat = [NSString stringWithFormat:@"%@=%@&",allkey[i],allValue[i]];
            [result appendString:keyValueFormat];
            NSLog(@"post()方法参数解析结果：%@",result);
            
        }
        
        return result;
    }

+(NSString*)returnUpDate:(NSString *)time
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //将字符串格式化
    NSDate *d=[date dateFromString:time];
    //返回以1970/01/01 GMT为基准，然后过了secs秒的时间
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    //返回以当前时间为基准，然后过了secs秒的时间
    NSDate* dat = [NSDate date];
    //获取到了当前时刻距离GMT基准的总秒数
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString* str=@"";
  if(now>late)
  {
    str=@"已结束";
  }else
      str=@"马上开始";
   

    return str;
}
//将当前时间转化为年月日格式
+(NSString *)changeDate:(NSDate *)date
{
//NSDateFormatter *d=[[NSDateFormatter alloc] init];
//    [d setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//     //将字符串格式化
//    NSDate *date=[d dateFromString:time];
    // NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags =  NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
     NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
     NSInteger year = [comps year];
     NSInteger month = [comps month];
     NSInteger day = [comps day];
     NSInteger hour = [comps hour];
     NSInteger min = [comps minute];
     NSInteger sec = [comps second];
     NSString *string = [NSString stringWithFormat:@"%ld,%ld,%ld",year,month,day];
    if(year==0){
    return @"";
    }else
    return string;
}
+(float) heightForString:(NSString *)value andWidth:(float)width{
    //获取当前文本的属性 NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[value dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }  documentAttributes:nil error:nil];
    NSRange range = NSMakeRange(0, attrStr.length);
    // 获取该段attributedString的属性字典
    //NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    
    // 计算文本的大小
    // CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width , 0) // 用于计算文本绘制时占据的矩形块
    //                                           options:NSStringDrawingTruncatesLastVisibleLine |
    //                        NSStringDrawingUsesLineFragmentOrigin |
    //                        NSStringDrawingUsesFontLeading// 文本绘制时的附加选项
    //                                        attributes:dic        // 文字的属性
    //                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    CGRect rect=[attrStr boundingRectWithSize:CGSizeMake(width , 0) options:NSStringDrawingTruncatesLastVisibleLine |
                 NSStringDrawingUsesLineFragmentOrigin |
                 NSStringDrawingUsesFontLeading context:nil];
    
    
    //return sizeToFit.height;
    return rect.size.height;
}
+(NSString *)translation:(NSString *)arebic

{   NSString *str = arebic;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]])
        {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
            {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            }else
            {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum])
            {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    
    NSString *sumStr = [sums  componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    NSLog(@"%@",str);
    NSLog(@"%@",chinese);
    return chinese;
}
//判断是否有中文
+(BOOL)IsChinese:(NSString *)str {
    
    for(int i=0; i< [str length];i++){ int a = [str characterAtIndex:i]; if( a > 0x4e00 && a < 0x9fff)
    {
        return YES;
    }
    } return NO;
}

//判断是否有中文
+(NSURL *)cleanChinese:(NSString *)str {
    
//    for(int i=0; i< [str length];i++){
//        int a = [str characterAtIndex:i]; if( a > 0x4e00 && a < 0x9fff)
//    {
//        //是中文return YES;
//        return [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    }
//    }
    NSRange _range = [str rangeOfString:@" "];
    NSString * newName=@"";
    if (_range.location != NSNotFound) {
        //有空格
        newName=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
        return [NSURL URLWithString:newName];
        
    }else {
        //无空格
        newName=str;
         return [NSURL URLWithString:newName];
    }

    //非中文
    return [NSURL URLWithString:str];
}
//时间转化
+(NSString*)getSomeDay:(NSInteger)index
{
    NSDate *date = [NSDate date];//给定的时间
    
    //NSDate *lastDay = [NSDate dateWithTimeInterval:index*24*60*60 sinceDate:date];//前一天
    
    NSDate *nextDat = [NSDate dateWithTimeInterval:24*60*60*index sinceDate:date];//后一天
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    NSString *destDateString = [dateFormatter stringFromDate:nextDat];
    return destDateString;
}
//时间转化
+(NSString*)isToday:(NSString*)str
{
    NSDate *date = [NSDate date];//给定的时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    if([str isEqualToString:destDateString])
    {
        return @"1";
    }else
    return @"0";
}
//date转换为时间
+(NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
     return destDateString;
    
}
+(NSString *)classIsNSNull:(id)str
{
  if([str isKindOfClass:[NSNull class]])
  {
  return @"";
  
  }else
      return str;
}
//等比例长度
+(CGFloat)returnUpHeight:(CGFloat)height
{
    return (height/667.0)*[UIScreen mainScreen].bounds.size.height;
}
+(CGFloat)returnUpWidth:(CGFloat)width
{
return (width/375.0)*[UIScreen mainScreen].bounds.size.width;

}
///
+(NSString *)changeNsnumber:(NSNumber *)number
{
    return [number stringValue];

}
+(NSNumber *)changeString:(NSString *)str andIsAdd:(BOOL)isAdd
{
    NSInteger index = [str integerValue];
   if(isAdd)
   {
       ++index;
   
   }else
   {
       --index;
   }

    return [NSNumber numberWithInteger:index];
}
+(BOOL)tryToSwitchYesOrNo:(NSNumber*)number
{
  if([[number stringValue] isEqualToString:@"0"])
  {
      return NO;
  }else
      return YES;

}
+(NSString*)getUploadName
{
    return [NSString stringWithFormat:@"%@_%@",[Helper getDateTimeString],[Helper randomStringWithLength:8]];
}
//给图片命名
+ (NSString*)getDateTimeString
{
    
    NSDateFormatter*formatter;
    
    NSString*dateString;
    
    formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    return dateString;
    
}

+ (NSString*)randomStringWithLength:(int)len
{
    NSString*letters =@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString*randomString = [NSMutableString stringWithCapacity: len];
    for(int i =0; i<len; i++){
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform((int)[letters length])]] ;
    }
    return randomString;
}

/**
 *  调整图片尺寸和大小
 *
 *  @param sourceImage  原始图片
 *  @param maxImageSize 新图片最大尺寸
 *  @param maxSize      新图片最大存储大小
 *
 *  @return 新图片imageData
 */
+ (NSData *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize
{
    
    if (maxSize <= 0.0) maxSize = 1024.0;
    if (maxImageSize <= 0.0) maxImageSize = 1024.0;
    
    //先调整分辨率
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
//    CGFloat tempHeight = newSize.height / maxImageSize;
//    CGFloat tempWidth = newSize.width / maxImageSize;
    
    CGFloat tempHeight = 0.7;
    CGFloat tempWidth = 0.7;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    CGFloat sizeOriginKB = imageData.length / 1024.0;
    
    CGFloat resizeRate = 0.9;
    while (sizeOriginKB > maxSize && resizeRate > 0.1) {
        imageData = UIImageJPEGRepresentation(newImage,resizeRate);
        sizeOriginKB = imageData.length / 1024.0;
        resizeRate -= 0.1;
    }
    
    return imageData;
}
+(BOOL)isKindOfClass:(Class)Kind andFor:(id)respons
{
    return [respons isKindOfClass:Kind];
}
+(BOOL)isSuccess:(id)dic
{
    if(![dic isKindOfClass:[NSDictionary class]])
    {
        return NO;
    }
    return [dic[@"status"]integerValue] == 1?YES:NO;
}
//过滤html标签
+(NSString *)flattenHTML:(NSString *)html {
    
         NSScanner *theScanner;
        NSString *text = nil;
    
       theScanner = [NSScanner scannerWithString:html];
    
        while ([theScanner isAtEnd] == NO) {
                // find start of tag
                [theScanner scanUpToString:@"<" intoString:NULL] ;
                // find end of tag
                 [theScanner scanUpToString:@">" intoString:&text] ;
                 // replace the found tag with a space
                 //(you can filter multi-spaces out later if you wish)
                 html = [html stringByReplacingOccurrencesOfString:
                                           [NSString stringWithFormat:@"%@>", text]
                                                                        withString:@""];
            } // while //
    
        NSLog(@"-----===%@",html);
        return html;
}
//判断图片格式
+ (NSString *)typeForImageData:(NSData *)data {
    
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    
    
    switch (c) {
            
        case 0xFF:
            
            return @"image/jpeg";
            
        case 0x89:
            
            return @"image/png";
            
        case 0x47:
            
            return @"image/gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @"image/tiff";
            
    }
    
    return nil;
    
}

+(BOOL)isGitPhoto:(NSString *)url
{
    NSRange a =  [url rangeOfString:@"GIF"];
    
    if (a.location!=NSNotFound){
        return YES;
    }else{
        return NO;
    }

}

//数字切换
+(NSString*)numberForStr:(NSString*)number
{
    NSInteger index = [number floatValue];
    NSString * str ;
    if(index<1000)
    {
        str  = number;
    }else if (index>=1000&&index<10000)
    {
        str = [NSString stringWithFormat:@"%.1fk",index/1000.f];
        
    }else
    {
    
     str = [NSString stringWithFormat:@"%.1fw",index/10000.f];
    }
    
    return str;
}

/**
 *  仿QQ空间时间显示
 *  @param string eg:2015年5月24日 02时21分30秒
 */
+ (NSString *)format:(NSString *)string{
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
   [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate*inputDate = [inputFormatter dateFromString:string];
    NSLog(@"startDate= %@", inputDate);
    
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //get date str
    NSString *str= [outputFormatter stringFromDate:inputDate];
    //str to nsdate
    NSDate *strDate = [outputFormatter dateFromString:str];
    //修正8小时的差时
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: strDate];
    NSDate *endDate = [strDate  dateByAddingTimeInterval: interval];
    NSLog(@"endDate:%@",endDate);
    NSString *lastTime = [Helper compareDate:endDate];
    NSLog(@"lastTime = %@",lastTime);
    NSLog(@"%@",string);
    return str;
}

+(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    //修正8小时之差
    NSDate *date1 = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date1];
    NSDate *localeDate = [date1  dateByAddingTimeInterval: interval];
    
    //NSLog(@"nowdate=%@\nolddate = %@",localeDate,date);
    NSDate *today = localeDate;
    NSDate *yesterday,*beforeOfYesterday;
    //今年
    NSString *toYears;
    
    toYears = [[today description] substringToIndex:4];
    
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    beforeOfYesterday = [yesterday dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *beforeOfYesterdayString = [[beforeOfYesterday description] substringToIndex:10];
    
    NSString *dateString = [[date description] substringToIndex:10];
    NSString *dateYears = [[date description] substringToIndex:4];
    
    NSString *dateContent;
    if ([dateYears isEqualToString:toYears]) {//同一年
        //今 昨 前天的时间
        NSString *time = [[date description] substringWithRange:(NSRange){11,5}];
        //其他时间
        NSString *time2 = [[date description] substringWithRange:(NSRange){5,11}];
        if ([dateString isEqualToString:todayString]){
            dateContent = [NSString stringWithFormat:@"今天 %@",time];
            return dateContent;
        } else if ([dateString isEqualToString:yesterdayString]){
            dateContent = [NSString stringWithFormat:@"昨天 %@",time];
            return dateContent;
        }else if ([dateString isEqualToString:beforeOfYesterdayString]){
            dateContent = [NSString stringWithFormat:@"前天 %@",time];
            return dateContent;
        }else{
            return time2;
        }
    }else{
        return dateString;
    }
}

+ (NSString *)findendliyTime:(NSString *)dataTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置格式 年yyyy 月 MM 日dd 小时hh(HH) 分钟 mm 秒 ss MMM单月 eee周几 eeee星期几 a上午下午
    //与字符串保持一致
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //现在的时间转换成字符串
    NSDate * nowDate = [NSDate date];
    NSString * noewTime = [formatter stringFromDate:nowDate];
    //参数字符串转化成时间格式
    NSDate * date = [formatter dateFromString:dataTime];
    //参数时间距现在的时间差
    NSTimeInterval time = -[date timeIntervalSinceNow];
    //上述时间差输出不同信息
    if (time < 60) {
        return @"刚刚";
    }else if (time <3600) {
        int minute = time/60;
        NSString * minuteStr = [NSString stringWithFormat:@"%d分钟前",minute];
        return  minuteStr;
    }else if (time/3600>1&&time/86400<1) {
        return  [NSString stringWithFormat:@"%d小时前",(int)time/3600];
    }else if (time/86400 >= 1&&time/86400 < 2) {
        return  @"昨天";
    }else if (time/86400 >= 2&&time/86400 < 3) {
        return  @"前天";
    }else {
        //如果年不同输出某年某月某日
        if ([[dataTime substringToIndex:4] isEqualToString:[noewTime substringToIndex:4]]) {
            //截取字符串从下标为5开始 2个
            NSRange rangeM = NSMakeRange(5, 2);
            //如果月份不同输出某月某日某时
            if ([[dataTime substringWithRange:rangeM]isEqualToString:[noewTime substringWithRange:rangeM]]) {
                NSRange rangD = NSMakeRange(8, 2);
                //如果日期不同输出某日某时
                if ([[dataTime substringWithRange:rangD]isEqualToString:[noewTime substringWithRange:rangD]]) {
                    NSRange rangeSSD = NSMakeRange(11, 5);
                    NSString * Rstr = [NSString stringWithFormat:@"今日%@",[dataTime substringWithRange:rangeSSD]];
                    return  Rstr;
                }else {
                    NSRange rangSD = NSMakeRange(5, 5);
                    return [dataTime substringWithRange:rangSD];
                }
            }else {
                NSRange rangeSM = NSMakeRange(5,5);
                return [dataTime substringWithRange:rangeSM];
            }
        }else {
            return [dataTime substringToIndex:10];
        }
    }
}

+ (BOOL)isSystemVersioniOS8 {
    
      //check systemVerson of device
    
    UIDevice *device = [UIDevice currentDevice];
    
     float sysVersion = [device.systemVersion floatValue];
    
    
    
       if (sysVersion >= 8.0f) {
        
                return YES;
        
            }
    
        return NO;
    
}

+ (BOOL)isAllowedNotification {
    
       //iOS8 check if user allow notification
    
      if ([Helper isSystemVersioniOS8]) {// system is iOS8
        
               UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
              if (UIUserNotificationTypeNone != setting.types) {
            
                        return YES;
            
                    }
        
            } else {//iOS7
            
                    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        
                 if(UIRemoteNotificationTypeNone != type)
                
                            return YES;
            
                }
    
    
    
        return NO;
    
}

////判断是否允许使用麦克风7.0新增的方法requestRecordPermission
//+(BOOL)canRecord
//{
//    __block BOOL bCanRecord = YES;
//    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
//    {
//        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
//            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
//                if (granted) {
//                    bCanRecord = YES;
//                }
//                else {
//                    bCanRecord = NO;
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [[[UIAlertView alloc] initWithTitle:nil
//                                                    message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
//                                                   delegate:nil
//                                          cancelButtonTitle:@"关闭"
//                                          otherButtonTitles:nil] show];
//                    });
//                }
//            }];
//        }
//    }
//    SSLog(@"是否开启麦克风%d",bCanRecord);
//    return bCanRecord;
//}

+(void)saveCloseNowDate
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    date = [formatter stringFromDate:[NSDate date]];
    [userDefault setObject:date forKey:DAY_KEY];
    [userDefault synchronize];
}
+(BOOL)showNotiView
{
    BOOL isShow;
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    date = [formatter stringFromDate:[NSDate date]];
    
    //从未存储过
    if(![userDefault objectForKey:DAY_KEY])
    {
        isShow = YES;
    }else
    {
        NSString * dateStr = [userDefault objectForKey:DAY_KEY];
        if([date isEqualToString:dateStr])
        {
            isShow = NO;
        }else
        {
            isShow = YES;
        }
    }
    return isShow;
}
//登录三次提示
+(BOOL)gotoStarForApp
{
    BOOL isShow;
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    date = [formatter stringFromDate:[NSDate date]];
    
    //从未存储过
    if(![userDefault objectForKey:DAY_KEY])
    {
        [userDefault setInteger:1 forKey:NUM_KEY];

        [userDefault setObject:date forKey:DAY_KEY];
        isShow = YES;
    }else
    {
        NSInteger index = [userDefault integerForKey:NUM_KEY];
        NSString * dateStr = [userDefault objectForKey:DAY_KEY];
       //不等于三
        if(index == 3)
        {
            isShow = NO;
        }else{
            //同一天
   if([date isEqualToString:dateStr])
   {
       isShow = NO;
   }else
   {
       //其他累加
       [userDefault setInteger:index+1 forKey:NUM_KEY];
       [userDefault setObject:date forKey:DAY_KEY];
       isShow = YES;
   }
       
    }
    }
    [userDefault synchronize];
    return isShow;
}
+(void)GET:(NSString *)URLString animated:(BOOL)animated parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
+(NSString *)GBKString:(NSString *)html
{
    NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return   [NSString stringWithContentsOfURL:[NSURL URLWithString:html] encoding:enc error:nil];
}
//0 无 1 秒拍 2 B站
+(NSInteger)isVideoForUrl:(NSString*)htmlString
{
    NSInteger isVideo;
    //bilibili.com/video/ 哔哩哔哩
    //weibo.com/tv/ 微博
    //miaopai.com/show/ 秒拍
    NSRange a =  [htmlString rangeOfString:@"miaopai.com/show/"];
    NSRange  b = [htmlString rangeOfString:@"bilibili.com/video/"];
    NSRange c = [htmlString rangeOfString:@"bilibili.com/mobile/video/"];
    NSRange d = [htmlString rangeOfString:@"//mp.weixin.qq.com/"];
    if (a.location!=NSNotFound&&[Helper urlValidation:htmlString]){
        isVideo =  1;
    }else if (c.location!=NSNotFound&&[Helper urlValidation:htmlString])
    {
        isVideo =  2;
    }
    else if (b.location!=NSNotFound&&[Helper urlValidation:htmlString])
    {
        isVideo =  2;
    }
    else if (d.location != NSNotFound&&[Helper urlValidation:htmlString])
    {
        isVideo = 3;
    }
    else{
        isVideo =  0;
    }
    
    return isVideo;
}
+(BOOL)showStarForApp
{
    BOOL isShow;
     NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    
if([userDefault integerForKey:STAR_KEY])
{
    NSInteger index = [userDefault integerForKey:STAR_KEY];
    
    if(index == 4)
    {
        isShow = YES;
        index++;
    }else
    {
        if(index<=5)
        {
        index++;
        }
        isShow = NO;
    }
      [userDefault setInteger:index forKey:STAR_KEY];
}else
{
    [userDefault setInteger:1 forKey:STAR_KEY];
    isShow = NO;
}
    [userDefault synchronize];
    return isShow;
}

/**
 
 * 网址正则验证 1或者2使用哪个都可以
 
 *
 
 *  @param string 要验证的字符串
 
 *
 
 *  @return 返回值类型为BOOL
 
 */

+(BOOL)urlValidation:(NSString *)string {
    
    NSError *error;
    
    // 正则1
    
//    NSString *regulaStr =@"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
//    

    
  NSString*  regulaStr =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                  
                                                                          options:NSRegularExpressionCaseInsensitive
                                  
                                                                            error:&error];
    
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    

    for (NSTextCheckingResult *match in arrayOfAllMatches){
        
        NSString* substringForMatch = [string substringWithRange:match.range];
        
        NSLog(@"匹配");
        
        return YES;
        
    }
    
    return NO;
    
}
+(BOOL)isAllowSelectVideo
 {
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"tz_allowPickingVideo"])
    {
      return  [[[NSUserDefaults standardUserDefaults] objectForKey:@"tz_allowPickingVideo"] boolValue];
    }else
        return NO;
}
// 异步获取帧图片，可以一次获取多帧图片
+(void)centerFrameImageWithVideoURL:(NSURL *)videoURL completion:(void (^)(UIImage *image))completion {
    // AVAssetImageGenerator
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    // calculate the midpoint time of video
    Float64 duration = CMTimeGetSeconds([asset duration]);
    // 取某个帧的时间，参数一表示哪个时间（秒），参数二表示每秒多少帧
    // 通常来说，600是一个常用的公共参数，苹果有说明:
    // 24 frames per second (fps) for film, 30 fps for NTSC (used for TV in North America and
    // Japan), and 25 fps for PAL (used for TV in Europe).
    // Using a timescale of 600, you can exactly represent any number of frames in these systems
    CMTime midpoint = CMTimeMakeWithSeconds(duration/2.0, 600);
    
    // 异步获取多帧图片
    NSValue *midTime = [NSValue valueWithCMTime:midpoint];
    [imageGenerator generateCGImagesAsynchronouslyForTimes:@[midTime] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if (result == AVAssetImageGeneratorSucceeded && image != NULL) {
            UIImage *centerFrameImage = [[UIImage alloc] initWithCGImage:image];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(centerFrameImage);
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil);
                }
            });
        }
    }];
}
+(void)compressVideoWithVideoURL:(NSURL *)videoURL
                        savedName:(NSString *)savedName
                       completion:(void (^)(NSString *savedPath))completion {
    // Accessing video by URL
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    // Find compatible presets by video asset.
//    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    
    // Begin to compress video
    // Now we just compress to low resolution if it supports
    // If you need to upload to the server, but server does't support to upload by streaming,
    // You can compress the resolution to lower. Or you can support more higher resolution.
//    if ([presets containsObject:AVAssetExportPreset640x480]) {
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:videoAsset  presetName:AVAssetExportPreset1280x720];
        
        NSString *doc = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *folder = [doc stringByAppendingPathComponent:@"MYHVideos"];
        BOOL isDir = NO;
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:folder isDirectory:&isDir];
        if (!isExist || (isExist && !isDir)) {
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:folder
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error == nil) {
                NSLog(@"目录创建成功");
            } else {
                NSLog(@"目录创建失败");
            }
        }
        
        NSString *outPutPath = [folder stringByAppendingPathComponent:savedName];
        session.outputURL = [NSURL fileURLWithPath:outPutPath];
        
        // Optimize for network use.
        session.shouldOptimizeForNetworkUse = true;
        
        NSArray *supportedTypeArray = session.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            session.outputFileType = AVFileTypeMPEG4;
        } else if (supportedTypeArray.count == 0) {
            NSLog(@"No supported file types");
            return;
        } else {
            session.outputFileType = [supportedTypeArray objectAtIndex:0];
        }
        
        // Begin to export video to the output path asynchronously.
        [session exportAsynchronouslyWithCompletionHandler:^{
            if ([session status] == AVAssetExportSessionStatusCompleted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion([session.outputURL path]);
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(nil);
                    }
                });
            }
        }];
//    }
}
+(void)saveImage:(id)data isGif:(BOOL)isGif complet:(FinishBlock)complete{
    /*
     PHAuthorizationStatusNotDetermined,     用户还没有做出选择
     PHAuthorizationStatusDenied,            用户拒绝当前应用访问相册(用户当初点击了"不允许")
     PHAuthorizationStatusAuthorized         用户允许当前应用访问相册(用户当初点击了"好")
     PHAuthorizationStatusRestricted,        因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
     */
    
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
        [MBProgressHUD showError:@"因为系统原因, 无法访问相册"];
    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册(用户当初点击了"不允许")
        SSLog(@"提醒用户去[设置-隐私-照片-xxx]打开访问开关");
        [MBProgressHUD showError:@"请您去[设置-隐私-照片-xxx]打开访问开关"];
    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册(用户当初点击了"好")
        [Helper saveimageData:data isGif:isGif complete:complete];
    } else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                 [Helper saveimageData:data isGif:isGif complete:complete];
            }else if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册(用户当初点击了"不允许")
                SSLog(@"提醒用户去[设置-隐私-照片-xxx]打开访问开关");
                [MBProgressHUD showError:@"保存失败"];
            }
        }];
    }
}
+(void)saveimageData:(id)data isGif:(BOOL)isGif complete:(FinishBlock)complete{
    
    if(!isGif)
    { dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[TZImageManager manager] savePhotoWithImage:data completion:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error) {
                    if(complete)
                    {
                        complete(YES,nil);
                    }
                }else
                {
                    if(complete)
                    {
                        complete(NO,error);
                    }
                }
            });
        }];
    });
        
    }else
    {
        if(iOS9Later)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:nil];
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(success && !error){
                            if(complete)
                            {
                                complete(YES,nil);
                            }
                        }else
                        {
                            if(complete)
                            {
                                complete(NO,error);
                            }
                            }
                    });
                }];
            });
        }else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (!error) {
                            if(complete)
                            {
                                complete(YES,nil);
                            }
                        }else
                           {
                               if(complete)
                               {
                                   complete(NO,error);
                               }
                           }
                    });
                }];
            });
        }
        
    }
    
}
//保存视频至系统相册
+(void)saveVideoWithVideoURL:(NSURL*)videoURL andFinishBlock:(FinishVideoBlock)finishBlock
{
    
    _videoUrl = videoURL;
    _block = finishBlock;
    /*
     PHAuthorizationStatusNotDetermined,     用户还没有做出选择
     PHAuthorizationStatusDenied,            用户拒绝当前应用访问相册(用户当初点击了"不允许")
     PHAuthorizationStatusAuthorized         用户允许当前应用访问相册(用户当初点击了"好")
     PHAuthorizationStatusRestricted,        因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
     */
    
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
        [MBProgressHUD showError:@"因为系统原因, 无法访问相册"];
    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册(用户当初点击了"不允许")
        SSLog(@"提醒用户去[设置-隐私-照片-xxx]打开访问开关");
        [MBProgressHUD showError:@"请您去[设置-隐私-照片-xxx]打开访问开关"];
    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册(用户当初点击了"好")
        [Helper saveVideo];
    } else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                [Helper saveVideo];
            }else if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册(用户当初点击了"不允许")
                SSLog(@"提醒用户去[设置-隐私-照片-xxx]打开访问开关");
                [MBProgressHUD showError:@"保存失败"];
            }
        }];
    }
}

+(void)saveVideo{
    
    if(!iOS9Later) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeVideoAtPathToSavedPhotosAlbum:_videoUrl
                                    completionBlock:^(NSURL *assetURL, NSError *error) {
                                        if (error) {
                                            SSLog(@"添加图片到相册中失败");
                                            _block(NO,error);
                                            return;
                                        }
                                        _block(YES,nil);
                                    }];
        return;
    }
    
    /*
     PHAsset : 一个PHAsset对象就代表一个资源文件,比如一张图片
     PHAssetCollection : 一个PHAssetCollection对象就代表一个相册
     */
    
    __block NSString *assetId = nil;
    // 1. 存储图片到"相机胶卷"
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{ // 这个block里保存一些"修改"性质的代码
        // 新建一个PHAssetCreationRequest对象, 保存图片到"相机胶卷"
        // 返回PHAsset(图片)的字符串标识
        assetId = [PHAssetCreationRequest creationRequestForAssetFromVideoAtFileURL:_videoUrl].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            SSLog(@"保存图片到相机胶卷中失败");
            _block(NO,error);
            return;
        }
        
        SSLog(@"成功保存图片到相机胶卷中");
        
        // 2. 获得相册对象
        PHAssetCollection *collection = [Helper createdAssetCollection];
        
        // 3. 将“相机胶卷”中的图片添加到新的相册
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
            
            // 根据唯一标示获得相片对象
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
            // 添加图片到相册中
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (error) {
                SSLog(@"添加图片到相册中失败");
                _block(NO,error);
                return;
            }
             _block(YES,nil);
            SSLog(@"成功添加图片到相册中");
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
//            }];
        }];
    }];

}
/**
 *  获得曾经创建过的相簿
 */
+ (PHAssetCollection *)createdAssetCollection
{

    // 先获得之前创建过的相册
    PHFetchResult<PHAssetCollection *> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collectionResult) {
        if ([collection.localizedTitle isEqualToString:Phote_name]) {
            return collection;
        }
    }
    
    // 如果相册不存在,就创建新的相册(文件夹)
    __block NSString *collectionId = nil; // __block修改block外部的变量的值
    // 这个方法会在相册创建完毕后才会返回
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 新建一个PHAssertCollectionChangeRequest对象, 用来创建一个新的相册
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:Phote_name].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].firstObject;
}


+(CGFloat)labelHeightWithStr:(NSString *)str andFont:(UIFont *)font andLineSpacing:(CGFloat) lineSpacing andLabelWidth:(CGFloat)labelWidth{
    
    if(str  == nil){
        return 0;
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange allRange = [str rangeOfString:str];
    
    [attrStr addAttribute:NSFontAttributeName
     
                    value:font
     
                    range:allRange];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if(lineSpacing){
        [paragraphStyle setLineSpacing:lineSpacing];
        [attrStr addAttribute:NSParagraphStyleAttributeName
                        value:paragraphStyle
                        range:allRange];
    }
    CGFloat titleHeight;
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                   
                                        options:options
                   
                                        context:nil];
    
    titleHeight = ceilf(rect.size.height);
    
    return titleHeight;
}

+(NSAttributedString *)attributedStringWithStr:(NSString *)str andFont:(UIFont *)font andColorStr:(NSString *)colorStr andLineSpacing:(CGFloat) lineSpacing{
    if(str == nil)
    {
        str = @"";
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange allRange = [str rangeOfString:str];
    
    [attrStr addAttribute:NSFontAttributeName
     
                    value:font
     
                    range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName
     
                    value:KCOLOR(colorStr)
     
                    range:allRange];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if(lineSpacing){
        [paragraphStyle setLineSpacing:lineSpacing];
    }
    [attrStr addAttribute:NSParagraphStyleAttributeName
                    value:paragraphStyle
                    range:allRange];
    return attrStr;
}
+(NSString *)originImgUrlStr:(NSString *)str withSize:(CGFloat)size
{
    if(!size)size = ScreenWidth;
    NSInteger index = 800;
    return [NSString stringWithFormat:@"%@&maxSize=%zd",str,index];
}
+(NSString*)originImageURL:(NSString*)str
{
    NSString * searchStr = @"?x-oss-process";
    NSRange range = [str rangeOfString:searchStr];
    NSString * getStr = str;
    if(range.location!=NSNotFound)
    {
        getStr = [str substringWithRange:NSMakeRange(0, range.location)];
    }
    SSLog(@"转换后---%@",getStr);
    return getStr;
}
+ (BOOL)isIphoneX
{
    return  CGRectEqualToRect([UIScreen mainScreen].bounds, CGRectMake(0, 0, 375, 812));
}
+(UIImage*)imageFromSdcache:(NSString*)url{
    
    UIImage *imageData =nil;
    NSString*cacheImageKey = [[SDWebImageManager sharedManager]cacheKeyForURL:[NSURL URLWithString:url]];
        
        if(cacheImageKey.length) {
                        
            SDImageCache* cache = [SDImageCache sharedImageCache];
            //此方法会先从memory中取。
            imageData = [cache imageFromDiskCacheForKey:cacheImageKey];
            
        }
    
    return imageData?imageData:img_placeHolder;
    
}

//+(BOOL)isHasWeChat
//{
//  return  [[BAShareManage ba_shareManage] ba_UMSocialIsInstall:UMSocialPlatformType_WechatSession];
//}

+ (NSData *)zipGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage = nil;
    NSMutableArray *images = [NSMutableArray array];
    NSTimeInterval duration = 0.0f;
    for (size_t i = 0; i < count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        duration += [Helper sd_frameDurationAtIndex:i source:source];
        UIImage *ima = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        ima = [ima zip];
        [images addObject:ima];
        CGImageRelease(image);
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    CFRelease(source);
    return UIImagePNGRepresentation(animatedImage);
}
+ (float)sd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    //获取这一帧图片的属性字典
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    //获取gif属性字典
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    //获取这一帧持续的时间
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    //如果帧数小于0.1,则指定为0.1
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    CFRelease(cfFrameProperties);
    return frameDuration;
}
#pragma clang diagnostic pop

/** 字典or数组转Json */
+ (NSString *)convertToJsonData:(id)dictOrArray {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictOrArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

/** 时间戳转日期 */
+ (NSString *)convertDateWithTime:(NSString *)timeStampString {
    // timeStampString 是服务器返回的13位时间戳
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];  //yyyy-MM-dd HH:mm:ss
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

/** 时间戳转分钟*/
+ (NSString *)convertSecondWithTime:(NSString *)time {
    // time 是服务器返回的13位时间戳

    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[time doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm"];
    NSString *dateString       = [formatter stringFromDate: date];
    NSInteger num = [dateString integerValue];
    return [NSString stringWithFormat:@"%ld分钟",(long)num];
}

#pragma mark -得到当前时间date
+ (NSDate *)getCurrentTime {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    return date;
}

/** 判断时间戳是否过期 */
+ (BOOL)isOverDueWithDate:(NSString *)timeStampString {
    // timeStampString 是服务器返回的13位时间戳
    // iOS 生成的时间戳是10位
    NSTimeInterval interval = [timeStampString doubleValue]/1000.0;
    NSDate *oneDay = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *todayStr = [dateFormatter stringFromDate:[self getCurrentTime]];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateToday = [dateFormatter dateFromString:todayStr];
    NSComparisonResult result = [dateA compare:dateToday];
    if (result == NSOrderedDescending) {
        SSLog(@"oneDay  is in the future");
        return NO;
    }
    else if (result == NSOrderedAscending){
        SSLog(@"Date1 is in the past");
        return YES;
    }
    //刚好时间一样, 也算过期
    SSLog(@"Both dates are the same");
    return YES;
    
}
@end
