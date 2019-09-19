// PrivacyPermission.h
//
// Copyright (c) 2017 BANYAN
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,PrivacyPermissionType) {
    PrivacyPermissionTypePhoto = 0,//相册权限
    PrivacyPermissionTypeCamera,//相机权限
    PrivacyPermissionTypeLocation,//位置权限
    PrivacyPermissionTypePushNotification,//推送权限
//    PrivacyPermissionTypeReminder,//提醒事项权限
//    PrivacyPermissionTypeMedia,//媒体资料
//    PrivacyPermissionTypeSpeech,//语音识别权限
//    PrivacyPermissionTypeMicrophone,//麦克风权限
//    PrivacyPermissionTypeBluetooth,//蓝牙权限
//    PrivacyPermissionTypeEvent,//日历权限
//    PrivacyPermissionTypeContact,//通讯录权限
//    PrivacyPermissionTypeHealth,//运动与健身权限
};
/*`PrivacyPermissionTypeHealth only have three kinds of permission for read and write,setp count、distance walking running and flights climbed,if you want to access more permissions about `HealthStore`,please refer to the link` -> PrivacyPermissionTypeHealth只有步数,步行+跑步距离和以爬楼层三种读写权限，如果想要访问更多关于`HealthStore`权限请参考链接*/
// https://github.com/GREENBANYAN/skoal

typedef NS_ENUM(NSUInteger,PrivacyPermissionAuthorizationStatus) {
    PrivacyPermissionAuthorizationStatusAuthorized = 0,
    PrivacyPermissionAuthorizationStatusDenied,
    PrivacyPermissionAuthorizationStatusNotDetermined,
    PrivacyPermissionAuthorizationStatusRestricted,
    PrivacyPermissionAuthorizationStatusLocationAlways,
    PrivacyPermissionAuthorizationStatusLocationWhenInUse,
    PrivacyPermissionAuthorizationStatusUnkonwn,
};

@interface PrivacyPermission : NSObject

+(instancetype)sharedInstance;

/**
 * @brief `Function for access the permissions` -> 获取权限函数
 * @param type `The enumeration type for access permission` -> 获取权限枚举类型
 * @param completion `A block for the permission result and the value of authorization status` -> 获取权限结果和对应权限状态的block
 */
-(void)accessPrivacyPermissionWithType:(PrivacyPermissionType)type completion:(void(^)(BOOL response,PrivacyPermissionAuthorizationStatus status))completion;

@end
